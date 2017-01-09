
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
      time_reg                : IN std_logic_vector(15 DOWNTO 0);
      -- OUT/IN BSM -- 
      sample_point            : OUT std_logic;     
      busmon                  : OUT std_logic;   
      hard_sync_enable        : in std_logic;
      bit_err                 : out std_logic; 
      bus_drive               : in std_logic);
        
 
END ENTITY can_bit_timing_logic;



ARCHITECTURE RTL OF can_bit_timing_logic IS


function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end; 


	  SIGNAL PB_SEGMENT2            :  std_logic_vector(2 DOWNTO 0);
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
    --time--
    signal sync_jump_width          :  std_logic_vector(1 DOWNTO 0); 
    signal time_segment1            :  std_logic_vector(3 DOWNTO 0); 
    signal time_segment_temp        :  std_logic_vector(5 DOWNTO 0);
    --synchornisation--
    SIGNAL SYNC_ENABLE            :  std_logic;
    

BEGIN
 
sync_jump_width <= time_reg(15 downto 14); 
time_segment1 <= ('0' & time_reg(2 downto 0)) + ('0' & time_reg(6 downto 4)) ;
time_segment_temp <= time_reg(13 downto 8) - ('0' & ('0' & (time_segment1 + 1)));
PB_SEGMENT2 <= time_segment_temp(2 downto 0);

SAMPLE <= time_segment1 + '1';
NTQ <= time_reg (13 downto 8);
	 
	 
bit_err <= not conv_std_logic( TxCan_i = rx_CAN_i ) when seg2='1' else '0';  

BIT_TIMING: process(RESET,TQ_clk,rx_CAN_i )
begin
      if RESET='1' then
        sample_point_i <= '0'; 
        counter <= "00010";       
        Qcounter <= "00001";
        sync<='0';
        seg1<='1';
        seg2<='0';
        TRANSMIT_POINT <= '0';
      elsif TQ_clk'event and TQ_clk = '1' then
              if (counter = NTQ) then 
                counter <= "00001";
              elsif (TRANSMIT_POINT = '0' and SAMPLE_POINT_i = '0') then
                counter <= counter + "00001";
              end if;
            
              if (Qcounter = "00001" and sync='1') then 
                  Qcounter <= "00001";
                  sync <='0';
                  seg1<='1';
                  seg2<='0';
              elsif (Qcounter = SAMPLE and seg1='1' and SAMPLE_POINT_i = '1') then
                  Qcounter <= "00001";
                  sync <='0';
                  seg1<='0';
                  seg2<='1';
              elsif (Qcounter = PB_SEGMENT2+'1' and seg2='1' and TRANSMIT_POINT = '1') then
                  Qcounter <= "00001";
                  sync <='1';
                  seg1<='0';
                  seg2<='0';  
              elsif (TRANSMIT_POINT = '0' and SAMPLE_POINT_i = '0') then
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
                            if (counter - '0' & SAMPLE ) >= ("000" & sync_jump_width) then
                                   TRANSMIT_POINT <= '1';
                            end if;
                    end if;
              end if;
      end if;

end process;

rx_CAN_i <= RxCan;
sample_point <= SAMPLE_POINT_i;
busmon_i <= RxCan when SAMPLE_POINT_i ='1';
busmon <= busmon_i;
TxCan_i <= bus_drive when TRANSMIT_POINT ='1';
TxCan <= TxCan_i;

END ARCHITECTURE RTL;  
   
   