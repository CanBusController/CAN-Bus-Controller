library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity can_bsp is
    port(
            clk :        in std_logic;
            rst :        in std_logic;
            process_bit: in std_logic;
            rcv_bit:     in std_logic;
            bit_err:     in std_logic;

            --tx
            tx_rqst:     in std_logic;
            tx_id:       in std_logic_vector(10 downto 0);
            tx_rtr:      in std_logic;
            tx_data:     in std_logic_vector(63 downto 0);
            tx_dlc:      in std_logic_vector(3 downto 0);
            tx_done:     out std_logic;

            --rx
            rx_id:       out std_logic_vector(10 downto 0);
            rx_data:     out std_logic_vector(63 downto 0);
            rx_dlc:      out std_logic_vector(3 downto 0);
            rx_rtr:      out std_logic;
            rx_valid:    out std_logic;

            hard_sync_en:out std_logic;
            bus_drive:   out std_logic

        );
end entity ;

architecture arch_can_bsp of can_bsp is

    component can_crc 
        port (
                 clk        :  in std_logic;
                 data       :  in std_logic;
                 enable     :  in std_logic;
                 initialize :  in std_logic;
                 crc        :  out std_logic_vector(14 downto 0) 
             );
    end component ;

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
    signal crc_sequence: std_logic_vector(14 downto 0) ;
    signal crc_init: std_logic:='0';
    signal crc_enable: std_logic:='0';
    signal crc_input:std_logic:='0';
    signal receive_error_counter : std_logic_vector(7 downto 0):=X"00"; --used to count 128 occurences of 11 recessive bits
    signal transmit_error_counter : std_logic_vector(7 downto 0):=X"00";
    signal rx_inner_id:std_logic_vector(10 downto 0) :=(others=>'0');
    signal rx_inner_data:std_logic_vector(63 downto 0) :=(others=>'0');
    signal rx_inner_dlc:std_logic_vector(3 downto 0) :=(others=>'0');
    signal rx_inner_crc: std_logic_vector(14 downto 0) :=(others=>'0');
    signal rx_inner_rtr: std_logic :='0';
    signal field : can_field_type:=SOF;
    signal position : std_logic_vector(3 downto 0):=X"1"; --used to count 11 recessive bit in BRO and position in frame
        --field

    signal recessive_counter : std_logic_vector(3 downto 0):=X"0"; --used to count 11 recessive bits int WFBI
    signal stuff_enable: std_logic:='0'; --used to enable/disable bit stuffing
    signal active_error_flag_counter : std_logic_vector(3 downto 0):=X"0";
    signal err_delim_position : std_logic_vector( 3 downto 0):=X"1";
    signal general_counter : std_logic_vector(3 downto 0):=X"0";
    signal six_consecutive_dominant : std_logic_vector(3 downto 0):=X"0";
    signal six_consecutive_recessive : std_logic_vector(3 downto 0):=X"0";
    signal active_error_flag_first_dominant : std_logic:='0';
    signal intermission_read_sof: std_logic:='0';



begin

    crc_generator: can_crc port map (
                                        clk        =>  clk,
                                        data       =>  crc_input,
                                        enable     =>  crc_enable,
                                        initialize =>  crc_init,
                                        crc        =>  crc_sequence
                                    );

    sync_process:process(clk)
    begin
        if ( rst = '1' ) then
            ps<=WFBI;
        elsif ( clk = '1' ) then
            ps <= ns ;
        end if;
    end process ;

    bsp_engine:process(clk, rst, ns)
        variable next_bit:std_logic;
        variable frame_position:integer range 1 to 128:=1 ; --frame length is 108
        variable receive_recessive_stuff_counter : integer range 0 to 6:=0;
        variable receive_dominant_stuff_counter : integer range 0 to 6:=0;
        variable tx_recessive_stuff_counter : integer range 0 to 6:=0;
        variable tx_dominant_stuff_counter : integer range 0 to 6:=0;
        variable rx_recessive_stuff_counter : integer range 0 to 6:=0;
        variable rx_dominant_stuff_counter : integer range 0 to 6:=0;
        variable crc_error: std_logic:='0';
    begin
        if ( rst = '1' ) then
            --initialization 
            tx_done<='0';
            receive_error_counter<=X"00";
            transmit_error_counter<=X"00";
            ns<=WFBI;
            recessive_counter<=(others=>'0');
            stuff_enable<='0';
            active_error_flag_counter<=X"0";
            active_error_flag_first_dominant<='0'; 
            intermission_read_sof<='0';
            general_counter<=X"0";
            frame_position:=1;
            crc_init<='1';
            crc_enable<='0';
            receive_recessive_stuff_counter:=0; 
            receive_dominant_stuff_counter:=0;
        elsif ( clk'event and clk='1') then
            crc_init<='0';
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
                            if ( tx_rqst ='1' ) then
                                ns<=TRAN;
                            else
                                ns<=I;
                            end if;
                        end if ;
                    when I =>
                        hard_sync_en<='1';
                        --receiving : wait for dominant bit marking the start of frame
                        --            The node becomes receiver with setting STATUS to RECEIVING and
                        --            HARD_SYNC_ENABLE to '0'
                        if ( rcv_bit = '0' ) then 
                            hard_sync_en<='0';
                            stuff_enable<='1';
                            field<=ID;
                            receive_dominant_stuff_counter:=1;
                            ns<=RCV;
                        else
                            --transmitting: If no dominant bit appears on the bus the node waits for a TRANSMISSION_REQUEST 
                            --              to become transmitter. Then STATUS is changed to TRANSMITTING. The FIELD of the
                            --              next bit is Start_Of_Frame. STUFF_ENABLE becomes true. BUS_DRIVE is set to dominant 
                            --              (because of Start_Of_Frame) and HARD_SYNC_ENABLE will be set to '0'.
                            if ( tx_rqst = '1' ) then
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
                                        active_error_flag_counter<=X"0";
                                        --increment receive_error_counter by 8 
                                        receive_error_counter<=
                                       std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,8));
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
                                     std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,8));
                                     if ( general_counter < X"8" ) then
                                         general_counter <= 
                                                           std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                                     else
                                         receive_error_counter<=
                                        std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,8));
                                    end if ;
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
                                    if ( active_error_flag_first_dominant='0' ) then
                                        receive_error_counter<=
                                       std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,8));
                                       active_error_flag_first_dominant<='1';
                                   end if ;
                                   if ( general_counter < X"7" ) then
                                       general_counter<=
                                      std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                                  elsif ( general_counter =X"7" ) then
                                      --after each sequence of additional
                                      --eight consecutive dominant bits the RECEIVE_ERROR_COUNTER is incremented by 8
                                      receive_error_counter<=
                                     std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,8));
                                     general_counter<=X"0";
                                     if ( receive_error_counter >= X"80" ) then 
                                         -- A node is 'error passive' when the RECEIVE ERROR COUNT equals or exceeds 128.
                                         six_consecutive_recessive  <= X"0";
                                         six_consecutive_dominant  <= X"0";
                                         general_counter<=X"0";
                                         field<=PASSIVE_ERROR_FLAG;
                                     end if ;
                                 end if ;
                             elsif ( rcv_bit ='1' ) then
                                 err_delim_position<=X"2";
                                 general_counter<=X"0";
                                 field<=ERROR_DELIMITER;
                             end if ;
                         end if ;
                     when ERROR_DELIMITER=>
                         --send 8 recessive bits and change to intermission
                         bus_drive<='1';
                         if ( general_counter < X"8" ) then
                             general_counter <= 
                                               std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                         elsif ( general_counter = X"8" ) then
                             bus_drive<='0';
                             general_counter<=X"0";
                             field<=INTERMISSION;
                         end if ;

                     when OVERLOAD_FLAG=>
                         bus_drive<='0';
                         if ( active_error_flag_counter < X"06" ) then
                             if ( bit_err = '1' ) then
                                 --send another active_error_flag
                                 active_error_flag_counter<=X"0";
                                 --increment receive_error_counter by 8 
                                 receive_error_counter<=
                                std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,8));
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
                               if ( general_counter < X"8" ) then
                                   general_counter <= 
                                                     std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                               else
                                   receive_error_counter<=
                                  std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,8));
                              end if ;
                              if ( receive_error_counter >= X"80" ) then 
                                  -- A node is 'error passive' when the RECEIVE ERROR COUNT equals or exceeds 128.
                                  general_counter<=X"0";
                                  field<=PASSIVE_ERROR_FLAG;
                              end if ;
                          end if ;
                      end if ;

                  when OVERLOAD_DELIMITER=>
                      --send 8 recessive bits and change to intermission
                      bus_drive<='1';
                      if ( general_counter < X"8" ) then
                          general_counter <= 
                                            std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                      elsif ( general_counter = X"8" ) then
                          bus_drive<='0';
                          general_counter<=X"0";
                          field<=INTERMISSION;
                      end if ;
                  when INTERMISSION=>
                      if ( general_counter < X"3" ) then
                          general_counter <= 
                                            std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                          if ( (general_counter = X"0" or general_counter = X"1")and rcv_bit='0') then
                              general_counter<=X"0";
                              field<=OVERLOAD_FLAG;
                          elsif ( general_counter=X"2" and rcv_bit='0') then
                              intermission_read_sof<='1';
                          end if ;
                      elsif ( general_counter = X"3" ) then
                          --have read 11X, if X = 0 then it will be considered as start of frame
                          --               if X = 1 then if  transmission_request = 1 next state <= Transmitting
                          --                             else next state <= Idle
                          general_counter<=X"0";
                          if ( intermission_read_sof = '1' ) then
                              field<=ID;
                              if ( tx_rqst = '1' ) then
                                  ns <= TRAN ;
                              else 
                                  ns <= RCV;
                              end if ;
                          elsif ( intermission_read_sof = '0' ) then
                              if ( tx_rqst = '1' ) then
                                  ns <= TRAN;
                              else 
                                  ns <= I ;
                              end if ;
                          end if;
                      end if ;
                  when others => 
                      if ( frame_position = 109 ) then
                          if ( crc_error = '0') then
                              --receiving success
                              rx_id<=rx_inner_id;
                              rx_dlc<=rx_inner_dlc;
                              rx_rtr<=rx_inner_rtr;
                              rx_data<=rx_inner_data;
                              rx_valid<='1';
                          else
                              rx_valid<='0';
                          end if ;
                          frame_position:=1;
                          ns<=I;
                      else
                          rx_valid<='0';
                      end if ;
                      if ( receive_dominant_stuff_counter < 5 or receive_recessive_stuff_counter < 5 ) then
                          --part 1 : not a stuff bit
                          --running crc
                          if ( frame_position>=2 and frame_position <=12 ) then
                              rx_inner_id(10-(frame_position-2))<=rcv_bit;
                          elsif( frame_position = 13 ) then
                              rx_inner_rtr<=rcv_bit;
                          elsif ( frame_position >=16 and frame_position <= 19 ) then
                              rx_inner_dlc(3-(frame_position-16))<=rcv_bit;
                          elsif ( frame_position <= 19 + 8 * unsigned(rx_inner_dlc) ) then
                              rx_inner_data(63-(frame_position-20))<=rcv_bit;
                          elsif ( frame_position <= 34 + 8 * unsigned(rx_inner_dlc)) then
                              rx_inner_crc(14-(frame_position-(20+8*to_integer(unsigned(rx_inner_dlc)) )))<=rcv_bit; 
                          elsif ( frame_position <= 35 + 8 * unsigned(rx_inner_dlc)) then
                              if ( rcv_bit /= '1' ) then
                                  --crc delimiter must be recessive otherwise it's an error
                                  field<=ACTIVE_ERROR_FLAG;
                              end if ;
                          elsif ( frame_position <= 44 + 8 * unsigned(rx_inner_dlc)) then
                              --the remaining bits must be recessive
                              if ( rcv_bit /= '1' ) then
                                  field<=ACTIVE_ERROR_FLAG;
                              end if ;
                          end if ;
                          if ( frame_position <= 98 ) then
                              crc_input<=rcv_bit;
                              crc_enable<='1';
                          else
                              --stop crc after data field
                              crc_enable<='0';
                          end if ;
                          frame_position:=frame_position+1;
                      else
                          --part 2 : a stuff bit and it must be the complement of the previous bit
                          if ( next_bit /= rcv_bit ) then
                              --stuff error
                              crc_init<='1';
                              crc_enable<='0';
                              frame_position:=1;
                              rx_valid<='0';
                              field<=ACTIVE_ERROR_FLAG;
                          end if;
                          crc_enable<='0';
                          receive_dominant_stuff_counter:=0;
                          receive_recessive_stuff_counter:=0;
                      end if;

                      if (rcv_bit = '1' ) then 
                          receive_dominant_stuff_counter:=0;
                          receive_recessive_stuff_counter:=receive_recessive_stuff_counter+1;
                      elsif ( rcv_bit = '0' ) then
                          receive_recessive_stuff_counter:=0;
                          receive_dominant_stuff_counter:=receive_dominant_stuff_counter+1;
                      end if ;
              end case ;
          when TRAN =>
              case field is 
                  when ACTIVE_ERROR_FLAG =>
                      bus_drive<='0';
                      if ( active_error_flag_counter < X"06" ) then
                          if ( bit_err = '1' ) then
                              --send another active_error_flag
                              active_error_flag_counter<=X"0";
                              --increment transmit_error_counter by 8 
                              transmit_error_counter<=
                             std_logic_vector(to_unsigned(to_integer(unsigned(transmit_error_counter))+8,8));
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
                            transmit_error_counter<=
                           std_logic_vector(to_unsigned(to_integer(unsigned(transmit_error_counter))+8,8));
                           if ( general_counter < X"8" ) then
                               general_counter <= 
                                                 std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                           else
                               transmit_error_counter<=
                              std_logic_vector(to_unsigned(to_integer(unsigned(transmit_error_counter))+8,8));
                          end if ;
                          if ( transmit_error_counter >= X"80" ) then 
                              -- A node is 'error passive' when the RECEIVE ERROR COUNT equals or exceeds 128.
                              general_counter<=X"0";
                              field<=PASSIVE_ERROR_FLAG;
                          elsif ( transmit_error_counter >= X"100" ) then
                              --A node is 'bus off' when the TRANSMIT ERROR COUNT is greater than or equal to 256.
                              --An node which is 'bus off' is permitted to become 'error active' (no longer 'bus off')
                              --with its error counters both set to 0 after 128 occurrence of 11 consecutive
                              --'recessive' bits have been monitored on the bus.
                              general_counter<=X"0";
                              --wait for  128 occurences of 11 recessive bits
                              if ( rcv_bit ='1' ) then
                                  if ( position < X"C") then
                                      position<=std_logic_vector(to_unsigned(to_integer(unsigned(position))+1,4));
                                  end if ;
                              elsif ( rcv_bit='0' ) then
                                  position<=X"1";
                              end if;
                              if (position = X"C") then    
                                  transmit_error_counter<=
                                 std_logic_vector(to_unsigned(to_integer(unsigned(transmit_error_counter))+1,8));
                                 position<=X"1";
                             end if ;
                             if ( transmit_error_counter=X"80" ) then
                                 receive_error_counter<=X"00";
                                 transmit_error_counter<=X"00";
                                 field<=ACTIVE_ERROR_FLAG;
                             end if ;
                         end if ;
                     end if ;
                 end if ;

             when PASSIVE_ERROR_FLAG => 
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
                         if ( active_error_flag_first_dominant='0' ) then
                             transmit_error_counter<=
                            std_logic_vector(to_unsigned(to_integer(unsigned(transmit_error_counter))+8,8));
                            active_error_flag_first_dominant<='1';
                        end if ;
                        if ( general_counter < X"7" ) then
                            general_counter<=
                           std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                        elsif ( general_counter =X"7" ) then
                            --after each sequence of additional
                            --eight consecutive dominant bits the RECEIVE_ERROR_COUNTER is incremented by 8
                           transmit_error_counter<=
                          std_logic_vector(to_unsigned(to_integer(unsigned(transmit_error_counter))+8,8));
                          general_counter<=X"0";
			end if;
                          if ( transmit_error_counter >= X"80" ) then 
                               -- A node is 'error passive' when the RECEIVE ERROR COUNT equals or exceeds 128.
                              general_counter<=X"0";
                              six_consecutive_dominant  <= X"0";
                              six_consecutive_recessive  <= X"0";
                              field<=PASSIVE_ERROR_FLAG;
                          elsif ( transmit_error_counter >= X"100" ) then
                               --A node is 'bus off' when the TRANSMIT ERROR COUNT is greater than or equal to 256.
                               --An node which is 'bus off' is permitted to become 'error active' (no longer 'bus off')
                               --with its error counters both set to 0 after 128 occurrence of 11 consecutive
                               --'recessive' bits have been monitored on the bus.
                              general_counter<=X"0";
                               --wait for  128 occurences of 11 recessive bits
                              if ( rcv_bit ='1' ) then
                                  if ( position < X"C") then
                                      position<=std_logic_vector(to_unsigned(to_integer(unsigned(position))+1,4));
                                  end if ;
                              elsif ( rcv_bit='0' ) then
                                  position<=X"1";
                              end if;
                              if (position = X"C") then    
                                  transmit_error_counter<=
                                 std_logic_vector(to_unsigned(to_integer(unsigned(transmit_error_counter))+1,8));
                                 position<=X"1";
                             end if ;
                             if ( transmit_error_counter=X"80" ) then
                                 receive_error_counter<=X"00";
                                 transmit_error_counter<=X"00";
                                 field<=ACTIVE_ERROR_FLAG;
                             end if ;
                         end if ;
                     elsif ( rcv_bit ='1' ) then
                         err_delim_position<=X"2";
                         general_counter<=X"0";
                         field<=ERROR_DELIMITER;
                     end if ;
                 end if ;
             when ERROR_DELIMITER =>
                  --send 8 recessive bits and change to intermission
                 bus_drive<='1';
                 if ( general_counter < X"8" ) then
                     general_counter <= 
                                       std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                 elsif ( general_counter = X"8" ) then
                     bus_drive<='0';
                     general_counter<=X"0";
                     field<=INTERMISSION;
                 end if ;
             when OVERLOAD_FLAG=>
                 bus_drive<='0';
                 if ( active_error_flag_counter < X"06" ) then
                     if ( bit_err = '1' ) then
                          --send another active_error_flag
                         active_error_flag_counter<=X"0";
                          --increment receive_error_counter by 8 
                         transmit_error_counter<=
                        std_logic_vector(to_unsigned(to_integer(unsigned(transmit_error_counter))+8,8));
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
                       if ( general_counter < X"8" ) then
                           general_counter <= 
                                             std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                       else
                           receive_error_counter<=
                          std_logic_vector(to_unsigned(to_integer(unsigned(receive_error_counter))+8,8));
                      end if ;
                      if ( transmit_error_counter >= X"80" ) then 
                           -- A node is 'error passive' when the RECEIVE ERROR COUNT equals or exceeds 128.
                          general_counter<=X"0";
                          field<=PASSIVE_ERROR_FLAG;
                      end if ;
                  end if ;
              end if ;

          when OVERLOAD_DELIMITER=>
               --send 8 recessive bits and change to intermission
              bus_drive<='1';
              if ( general_counter < X"8" ) then
                  general_counter <= 
                                    std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
              elsif ( general_counter = X"8" ) then
                  bus_drive<='0';
                  general_counter<=X"0";
                  field<=INTERMISSION;
              end if ;
          when INTERMISSION=>
              if ( general_counter < X"3" ) then
                  general_counter <= 
                                    std_logic_vector(to_unsigned(to_integer(unsigned(general_counter))+1,4));
                  if ( (general_counter = X"0" or general_counter = X"1")and rcv_bit='0') then
                      general_counter<=X"0";
                      field<=OVERLOAD_FLAG;
                  elsif ( general_counter=X"2" and rcv_bit='0') then
                      intermission_read_sof<='1';
                  end if ;
              elsif ( general_counter = X"3" ) then
                   --have read 11X, if X = 0 then it will be considered as start of frame
                   --               if X = 1 then if  transmission_request = 1 next state <= Transmitting
                   --                             else next state <= Idle
                  general_counter<=X"0";
                  if ( intermission_read_sof = '1' ) then
                      if ( transmit_error_counter>=X"100" ) then
                          field<=SUSPEND_TRANSMISSION;
                      else 
                          field<=ID;
                          if ( tx_rqst = '1' ) then
                              ns <= TRAN ;
                          else 
                              ns <= RCV;
                          end if ;
		      end if;
                      elsif ( intermission_read_sof = '0' ) then
                          if ( tx_rqst = '1' ) then
                              ns <= TRAN;
                          else 
                              ns <= I ;
                          end if ;
                      end if;
              end if ;
          when SUSPEND_TRANSMISSION =>
              if ( general_counter < X"8" ) then
                  bus_drive<='1';
              else 
                  bus_drive<='0';
                  field<=SOF;
                  if ( tx_rqst = '1' ) then
                      ns<=TRAN;
                  else
                      ns<=I;
                  end if ;
              end if ;
          when others =>
              tx_done<='0';
               --enable crc from start of frame until the last bit of data field
              if ( frame_position>=1 and frame_position <= 18 + 8 * unsigned(tx_dlc))then
                  crc_enable<='1';
              else 
                  crc_enable<='0';
              end if ;
              if ( frame_position > 33 + 8 * unsigned(tx_dlc)) then
                  tx_dominant_stuff_counter:=0;
                  tx_recessive_stuff_counter:=0;
              end if ;
              if ( tx_dominant_stuff_counter = 5 or tx_recessive_stuff_counter = 5 ) then
                   --if we have already encountred 5 consecutive similar bits then insert a stuff bit
                  crc_enable<='0';
                  bus_drive<=not next_bit;
                  tx_dominant_stuff_counter:=0;
                  tx_recessive_stuff_counter:=0;
              else
                  if( frame_position=1)then
                       --send start of frame (1 dominant bit) and activate crc computing
                      crc_input<='0';
                      next_bit:='0';
                      tx_dominant_stuff_counter:=tx_dominant_stuff_counter+1;
                  elsif ( frame_position<=12 )then
                       --send id (11 input bit)
                      crc_input<=tx_id(frame_position-2);
                      next_bit:=tx_id(frame_position-2);
                  elsif ( frame_position=13) then
                   --send remote transmission request (1 input bit)
                      crc_input<=tx_rtr;
                      next_bit:=tx_rtr;
                  elsif ( frame_position = 14 or frame_position = 15 ) then
                   --send identifier extension bit must be dominant for can A (1 dominant bit)
                   --reserved bit is also dominant
                      crc_input<='0';
                      next_bit:='0';
                  elsif ( frame_position <= 19 ) then
                   --data length ( 4 input bits )
                      crc_input<=tx_dlc(frame_position-16);
                      next_bit:=tx_dlc(frame_position-16);
                  else 
                      if ( (tx_rtr='0') ) then
                        if ( (frame_position <= 19 + 8 * unsigned(tx_dlc))) then
                       --data frame, if rtr = '1' then we simply skip data field
                          crc_input<=tx_data(63-(frame_position-20));
                          next_bit:=tx_data(63-(frame_position-20));
                        end if ;
                      elsif ( frame_position <= 34 + 8 * unsigned(tx_dlc)) then
                       --crc sequence (15 bits)
                         next_bit:=crc_sequence(34-frame_position+8*to_integer(unsigned(tx_dlc)));                   
                      elsif ( frame_position <= 35 + 8 * unsigned(tx_dlc)) then
                       --crc delimiter ( 1 recessive bit)
                          next_bit:='1';
                      elsif ( frame_position <= 36 + 8 * unsigned(tx_dlc)) then
                       --ack slot ( 1 recessive bit)
                          next_bit:='1';
                      elsif ( frame_position <= 37 + 8 * unsigned(tx_dlc)) then
                       --ack delimiter ( 1 recessive bit)
                          next_bit:='1';
                      elsif ( frame_position <= 44 + 8 * unsigned(tx_dlc)) then
                       --end of frame ( 7 recessive bits)
                          next_bit:='1';
                      else
                          tx_done<='1';
                          frame_position:=1;
                          field<=ID;
                          ns<=I;
                      end if ;
                  end if ;
                  if ( frame_position <= 33 + 8 * unsigned(tx_dlc)) then
                      if ( next_bit = '1' ) then
                          tx_recessive_stuff_counter:=tx_recessive_stuff_counter+1;
                          tx_dominant_stuff_counter:=0;
                      else
                          tx_recessive_stuff_counter:=0;
                          tx_dominant_stuff_counter:=tx_dominant_stuff_counter+1;
                      end if ;
                  end if ;
                  bus_drive<=next_bit;
                  frame_position:=frame_position+1;
              end if ;
      end case ;
  when others => 
      hard_sync_en <= '0';
  end case ;
  --    elsif adjust_error_counters'event and adjust_error_counters='1' then
  --adjustement assignements
  end if;
       end if;
   end process;

end arch_can_bsp;
