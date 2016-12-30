library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity can_bsp is
    port(
            clk :        in std_logic;
            rst :        in std_logic;
            process_bit :in std_logic ;
            rcv_bit:     in std_logic;
            bit_err:     in std_logic;
            tr_rqst:     in std_logic;
            tr_msg:      in std_logic;

            hard_sync_en:out std_logic;
            bus_drive:   out std_logic;
            tr_rqst_stat:out std_logic;
            rcv_msg:     out std_logic
        );
end entity ;

architecture arch_can_bsp of can_bsp is
    type can_status_type is (BOR, WFBI, I, RCV, TRAN);
    --bus off recovery, wait for bus idle, idle, receiving, transmitting
    signal ps: can_status_type:=WFBI ;
    signal ns: can_status_type:=WFBI ;
    type can_field_type is (SOF,ID,SRR, IDE,EX_ID, RTR, RESERV, DLC, DF, CRC_SEQ, CRC_DELIM, ACK_SLOT, ACK_DELIM, EOF,
                            ACTIVE_ERROR_FLAG, PASSIVE_ERROR_FLAG, ERROR_DELIMITER, OVERLOAD_FLAG, OVERLOAD_DELIMITER,
                            INTERMISSION, SUSPEND_TRANSMISSION);
    --Start_Of_Frame [1],Identifier[1..11],SRR_Bit[1], IDE_Bit[1], Ex_Identifier[1..18], RTR_Bit[1], Reserved_Bits[1..2],
    --Data_Length_Code[1..4], Data_Field[1..8bytes], CRC_Sequence[1..15], CRC_Delimiter[1], ACK_Slot[1], ACK_Delimiter[1],
    --End_Of_Frame[1..7], active_error_flag[1..6], passive_error_flag[1..6], error_delimiter[2..8], overload_flag[1..6],
    --overload_delimiter[2..8], intermission[1..3], suspend_transmission[1..8]
    signal field : can_field_type:=sof;
    signal recessive_counter : std_logic_vector(3 downto 0):=X"0"; --used to count 11 recessive bits int WFBI
    signal receive_error_counter : std_logic_vector(7 downto 0):=X"00"; --used to count 128 occurences of 11 recessive bits
    signal transmit_error_counter : std_logic_vector(7 downto 0):=X"00";
    signal position : std_logic_vector(3 downto 0):=X"1"; --used to count 11 recessive bit in BRO
    signal stuff_enable: std_logic:='0'; --used to enable/disable bit stuffing
begin

    sync_process:process(clk)
    begin
        if ( rst = '1' ) then
            ps<=WFBI;
        elsif ( clk = '1' ) then
            ps <= ns ;
        end if;
    end process ;

    bsp_engine:process(clk, rst, ns)
    begin
        if ( rst = '1' ) then
            --initialization 
            receive_error_counter<=X"00";
            transmit_error_counter<=X"00";
            ns<=WFBI;
            recessive_counter<=(others=>'0');
            stuff_enable<='0';
        elsif ( clk'event and clk='1') then
            if ( process_bit='1') then
            --stuff assignement
            --error status assignement
                case ps is
                when BOR =>
                        --wait for  128 occurences of 11 recessive bits
                        hard_sync_en <= '1';
                        if ( rcv_bit ='1' ) then
                            if ( position < X"C") then
                                position<=std_logic_vector(to_unsigned(to_integer(unsigned(position))+1,4));
                            end if ;
                        elsif ( rcv_bit='0' ) then
                            position<=X"1";
                        end if;
                        if (position = X"C") then    
                            receive_error_counter<=std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+1,8));
                            position<=X"1";
                        end if ;
                        if ( receive_error_counter=X"80" ) then
                            transmit_error_counter<=X"00";
                            receive_error_counter<=X"00";
                            position<=X"1";
                            ns<=I;
                        end if ;
                when WFBI =>
                        --wait for 11 recessive bits
                        hard_sync_en <= '1';
                        if ( rcv_bit ='1' ) then
                            if ( recessive_counter < X"B") then
                                recessive_counter<=std_logic_vector(to_unsigned(to_integer(unsigned(recessive_counter))+1,4));
                            end if ;
                        elsif ( rcv_bit='0' ) then
                            recessive_counter<=(others=>'0');
                        end if;
                        if (recessive_counter = X"B") then    
                            if ( tr_rqst ='1' ) then
                                ns<=TRAN;
                            else
                                ns<=I;
                            end if;
                        end if ;
                when I =>
                    --receiving : wait for dominant bit marking the start of frame
                    --              The node becomes receiver with setting STATUS to RECEIVING and
                    --              HARD_SYNC_ENABLE to '0'
                    if ( rcv_bit = '0' ) then 
                        ns<=RCV;
                        hard_sync_en<='0';
                        stuff_enable<='1';
                        field<=id;
                    else
                    --transmitting: If no dominant bit appears on the bus the node waits for a TRANSMISSION_REQUEST to become
                    --              transmitter. Then STATUS is changed to TRANSMITTING. The FIELD of the next bit is
                    --              Start_Of_Frame. STUFF_ENABLE becomes true. BUS_DRIVE is set to dominant (because of
                    --              Start_Of_Frame) and HARD_SYNC_ENABLE will be set to '0'.
                        if ( tr_rqst = '1' ) then
                             field<=SOF;
                             stuff_enable<='1';
                             bus_drive<='0';
                             hard_sync_en<='0';
                             ns<=TRAN;
                        end if ;
                    end if ;
              --               when RCV =>
              --               when TRAN =>
                    when others => 
                        hard_sync_en <= '0';
                end case ;
            --    elsif adjust_error_counters'event and adjust_error_counters='1' then
            --adjustement assignements
            end if;
        end if;
    end process;

end arch_can_bsp;
