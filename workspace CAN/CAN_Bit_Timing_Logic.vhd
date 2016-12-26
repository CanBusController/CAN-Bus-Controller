
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_bit_timing_logic IS
   PORT (
       -- IN CLK PRESCLEER -- 
     
      clk                         : IN std_logic; 
      TQ_clk                      : IN std_logic;
       -- IN CONTROLLER INTERFACE --   
      RESET                       : IN std_logic;
       -- OUT/IN TRANCEIBVER CAN BUS -- 
      RxCan                       : IN std_logic;   
      TxCan                       : out std_logic;
      -- Bit Timing Conf --
      baud_r_presc            : IN std_logic_vector(5 DOWNTO 0);   
      sync_jump_width         : IN std_logic_vector(1 DOWNTO 0); 
      time_segment1           : IN std_logic_vector(3 DOWNTO 0);   
      time_segment2           : IN std_logic_vector(2 DOWNTO 0);
      BIT_TIMING_CONFIG       : IN std_logic;
      -- OUT/IN BSM -- 
      rx_idle                 : OUT std_logic;
      sample_point            : OUT std_logic;     
      busmon                  : OUT std_logic;   
      hard_sync_enable        : in std_logic; 
      bus_drive               : in std_logic);
        
 
END ENTITY can_bit_timing_logic;



ARCHITECTURE RTL OF can_bit_timing_logic IS


function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end; 



    SIGNAL TRANSMITTER            :  std_logic;
    SIGNAL RECEIVER               :  std_logic;
    SIGNAL IDLE                   :  std_logic;
    SIGNAL rx_idle_temp           :  std_logic;

    SIGNAL PB_SEGMENT2            :  std_logic_vector(2 DOWNTO 0);
    SIGNAL rx_idle_count          :  std_logic_vector(3 DOWNTO 0);
    SIGNAL NTQ                    :  std_logic_vector(5 DOWNTO 0);
    SIGNAL SAMPLE                 :  std_logic_vector(3 DOWNTO 0); 
    SIGNAL TRANSMIT_POINT         :  std_logic;
    SIGNAL Sample_point_i         :  std_logic;
    SIGNAL counter                :  std_logic_vector(4 DOWNTO 0);
    signal Qcounter               :  std_logic_vector(4 DOWNTO 0); 
    SIGNAL sync                   :  std_logic;  
    SIGNAL seg1                   :  std_logic;   
    SIGNAL seg2                   :  std_logic;
    SIGNAL rx_CAN_i               :  std_logic;
    SIGNAL TxCan_i                :  std_logic;
    SIGNAL busmon_i               :  std_logic;
    
    --synchornisation
    SIGNAL SYNC_ENABLE            :  std_logic;
    

BEGIN

IDLE <= rx_idle_temp or conv_std_logic(RECEIVER='0' and TRANSMITTER ='0');
RECEIVER <= '1' when IDLE ='0' and TRANSMITTER = '0' else '0';
TRANSMITTER <= '1' when IDLE = '0' and rx_CAN_i = TxCan_i else '0'; 
    

BIT_TIMING: process(RESET, BIT_TIMING_CONFIG, TQ_clk , rx_CAN_i )

variable DIFF:INTEGER;
begin
      if RESET='1' or BIT_TIMING_CONFIG='1' then
        TxCan <= '1';
        sample_point_i <= '0'; 
        counter <= "00000";       
        Qcounter <= "00000";
        seg1<='1';
        seg2<='0';
        TRANSMIT_POINT <= '0';
        rx_idle_count <= "0000";
        rx_idle_temp <= '0' ;
        RECEIVER <= '0';
        TRANSMITTER <= '0'; 
      end if;
      
      if (BIT_TIMING_CONFIG'event and BIT_TIMING_CONFIG='0') or (RESET'event and RESET='0')then
            SAMPLE <= time_segment1 + '1';
            NTQ <= baud_r_presc ;
            PB_SEGMENT2 <= time_segment2;
            TRANSMIT_POINT <= '0';
      end if;
      
      if TQ_clk'event and TQ_clk = '1' and  RESET='0' then
              
              if (counter = NTQ) then 
                counter <= "00000";
              else 
                counter <= counter + "00001";
              end if;
            
              if (Qcounter = "00001" and sync='1') then 
                  Qcounter <= "00000";
                  sync <='0';
                  seg1<='1';
                  seg2<='0';
              elsif (Qcounter = time_segment1 and seg1='1') then
                  Qcounter <= "00000";
                  sync <='0';
                  seg1<='0';
                  seg2<='1';
              elsif (Qcounter = PB_SEGMENT2 and seg2='1') then
                  Qcounter <= "00000";
                  sync <='1';
                  seg1<='0';
                  seg2<='0';  
              else 
                  Qcounter <= Qcounter + "00001";
              end if;
              
              if (SAMPLE_POINT_i = '1') then 
                     SAMPLE_POINT_i <= '0';
              elsif (counter = SAMPLE and SAMPLE_POINT_i = '0') then
                     SYNC_ENABLE <= '1'; 
                     SAMPLE_POINT_i <= '1';
              end if;
              
              if (counter = NTQ and TRANSMIT_POINT = '0') then 
                    TRANSMIT_POINT <= '1';
              else
                    TRANSMIT_POINT <= '0';
              end if;
              
              IF ((counter = (SAMPLE + time_segment2)) and (rx_idle_count < 6) and (rx_CAN_i ='1')) THEN
                    rx_idle_count <= rx_idle_count + "0001";    
               ELSIF (rx_idle_count = "0110" and rx_CAN_i ='1' ) THEN
                    rx_idle_temp <= '1' ;  
              end if;


  
      --Hard Synchronization
              if  rx_CAN_i = '0'  and  busmon_i = '1'  and SYNC_ENABLE = '1' then
                   SYNC_ENABLE <= '0';
                   if  HARD_SYNC_ENABLE = '1'  then

                    --Transmitter: Synchronize only if edge after sample point
                            if BUS_DRIVE = '1' or counter > SAMPLE then
                                counter <= "00001";
                                Qcounter <= "00001";
                                sync <= '1';
                                seg1 <= '0';
                                seg2 <= '0';
                            end if;
                 --Generation of TRANSMIT_POINT only if edge lies Information Processing Time after sample point
                            if counter - 0 & SAMPLE >= "000010" then
                                   TRANSMIT_POINT <= '1';
                            end if;
                    end if;
              end if;



      elsIF (rx_CAN_i'EVENT AND rx_CAN_i = '0') THEN
              rx_idle_temp <= '0' ; 
              rx_idle_count <= "0000";
      end if;

end process;

rx_CAN_i <= RxCan;
sample_point <= SAMPLE_POINT_i;
busmon_i <= RxCan when SAMPLE_POINT_i ='1';
busmon <= busmon_i;
TxCan_i <= bus_drive when TRANSMIT_POINT ='1' else '1';
TxCan <= TxCan_i;
rx_idle <= rx_idle_temp;

END ARCHITECTURE RTL;  
   
   