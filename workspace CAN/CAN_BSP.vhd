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

    --Each bit of a CAN protocol frame can be referenced by its FIELD and POSITION 
    signal field : can_field_type:=SOF;
    signal position : std_logic_vector(3 downto 0):=X"1"; --used to count 11 recessive bit in BRO and position in frame
                                                                  --field

    signal recessive_counter : std_logic_vector(3 downto 0):=X"0"; --used to count 11 recessive bits int WFBI
    signal receive_error_counter : std_logic_vector(7 downto 0):=X"00"; --used to count 128 occurences of 11 recessive bits
    signal transmit_error_counter : std_logic_vector(7 downto 0):=X"00";
    signal stuff_enable: std_logic:='0'; --used to enable/disable bit stuffing
    signal active_error_flag_counter : std_logic_vector(3 downto 0):=X"00";
    signal err_delim_position : std_logic_vector( 3 downto 0):=X"1";
    signal general_counter : std_logic_vector(3 downto 0):=X"0";
    signal six_consecutive_dominant : std_logic_vector(3 downto 0):=X"0";
    signal six_consecutive_recessive : std_logic_vector(3 downto 0):=X"0";
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
            active_error_flag_counter<=X"00";
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
                        hard_sync_en<='0';
                        stuff_enable<='1';
                        field<=id;
                        ns<=RCV;
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
                    when RCV =>
                        case field is
                            when ACTIVE_ERROR_FLAG =>
                                bus_drive<='0';
                                if ( active_error_flag_counter < X"06" ) then
                                    if ( bit_err = '1' ) then
                                        --send another active_error_flag
                                        active_error_flag_counter<=X"00";
                                        --increment receive_error_counter by 8 
                                        receive_error_counter<=
                                            std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,4));
                                    else 
                                        --increment counter by 1 which corresponds to a dominant bit sent
                                        active_error_flag_counter<=
                                            std_logic_vector(to_unsigned(to_integer(unsigned(active_error_flag_counter))+1,4));
                                    end if ;
                                else 
                                    bus_drive<='1';
                                    if ( rcv_bit = '1') then
                                        err_delim_position<=X"2";
                                        general_counter<=X"0";
                                        field<=ERROR_DELIMITER;
                                    elsif ( rcv_bit = '0') then
                                        receive_error_counter<=
                                                std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,4));
                                        if ( general_counter < X"08" ) then
                                            general_counter <= 
                                                std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                                        else
                                        receive_error_counter<=
                                                std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,4));
                                        if ( receive_error_counter >= X"80" ) then 
                                            -- A node is 'error passive' when the RECEIVE ERROR COUNT equals or exceeds 128.
                                            general_counter<=X"0";
                                            field<=PASSIVE_ERROR_FLAG;
                                        end if ;
                                    end if ;
                                end if ;
                            when PASSIVE_ERROR_FLAG=>
                            --wait for six consecutive bits of same polarity
                                if ( six_consecutive_dominant/=X"6" and six_consecutive_recessive/=X"6") then
                                    if ( rcv_bit = '1' ) then
                                        six_consecutive_dominant<=X"0";
                                        if ( six_consecutive_recessive <X"6" ) then
                                            six_consecutive_recessive  <= 
                                               std_logic_vector(to_unsigned(to_integer(unsigned(six_consecutive_recessive ))+1,4));
                                        end if;
                                    elsif (rcv_bit ='0' ) then
                                        six_consecutive_recessive<=X"0";
                                        if ( six_consecutive_dominant <X"6" ) then
                                            six_consecutive_dominant  <= 
                                               std_logic_vector(to_unsigned(to_integer(unsigned(six_consecutive_dominant ))+1,4));
                                        end if;
                                    end if ;
                                elsif ( six_consecutive_dominant=X"6" or six_consecutive_recessive=X"6" ) then
                                    if ( rcv_bit  = '0' ) then 
                                        receive_error_counter<=
                                               std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,4));
                                        if ( general_counter < X"7" ) then
                                            general_counter<=
                                               std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                                        elsif ( general_counter =X"7" ) then
                                            --after each sequence of additional
                                            --eight consecutive dominant bits the RECEIVE_ERROR_COUNTER is incremented by 8
                                        receive_error_counter<=
                                               std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,4));
                                        general_counter<=X"0";
                                        end if ;
                                   elsif ( rcv_bit ='1' ) then
                                       err_delim_position<=X"2";
                                       general_counter<=X"0";
                                       field<=ERROR_DELIMITER;
                                   end if ;
                               end if ;
                           when ERROR_DELIMITER=>
                           when OVERLOAD_FLAG=>
                           when OVERLOAD_DELIMITER=>
                           when INTERMISSION=>
                           when others => 
                   --reception of a data frame from the field STart_Of_Frame to End_Of_Frame
                       end case ;
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
