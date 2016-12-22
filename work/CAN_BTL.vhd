
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_btl IS
   PORT (
     --clock & rst signals--
      clk                     : in std_logic;  
      clk_e                   : in std_logic;     
      clk_eQ                  : in std_logic;     
      rst                     : IN std_logic;   
      
      --can bus signals--
      CAN_rx                      : IN std_logic;
          
      -- Bus Timing register --
      sync_jump_width         : IN std_logic_vector(1 DOWNTO 0);
      time_segment1           : IN std_logic_vector(3 DOWNTO 0);   
      time_segment2           : IN std_logic_vector(2 DOWNTO 0);
      

      -- Output signals from this module 
      sample_point            : OUT std_logic;   
      sampled_bit             : OUT std_logic;   
      sampled_bit_q           : OUT std_logic; 
        
        
      tx_point                : OUT std_logic;   
      hard_sync               : OUT std_logic; 
      
      -- Output from can_bsp module
      
      TX_state                : IN std_logic_vector(7 downto 0);
      RX_state                : IN std_logic_vector(7 downto 0);
      RX_IngStat              : IN std_logic_vector(7 downto 0);
      TX_IngStat              : IN std_logic_vector(7 downto 0);

      bit_to_send             : IN std_logic;  
      bus_off                 : IN std_logic);   
      
END ENTITY can_bit_timing_logic;



ARCHITECTURE RTL OF can_btl IS

function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end;

   SIGNAL   bit_trans_state          :  std_logic_vector(2 downto 0); 
   SIGNAL   sync_blocked             :  std_logic;   
   SIGNAL   hard_sync_blocked        :  std_logic;   
   
   SIGNAL quant_cnt                :  std_logic_vector(4 DOWNTO 0);   
   
   
   SIGNAL delay                    :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL sync                     :  std_logic;   
   SIGNAL seg1                     :  std_logic;   
   SIGNAL seg2                     :  std_logic;   


   SIGNAL resync_latched           :  std_logic;
       
   SIGNAL tx_next_sp               :  std_logic;
      
   SIGNAL go_sync                  :  std_logic;   
   SIGNAL go_seg1                  :  std_logic;   
   SIGNAL go_seg2                  :  std_logic; 
   
   SIGNAL sync_window              :  std_logic;   
   SIGNAL resync                   :  std_logic;   


   -- when transmitting 0 with positive error delay is set to 0
   
   
   SIGNAL delay_temp               :  std_logic_vector(4 DOWNTO 0);  
    
   SIGNAL sample_point_temp       :  std_logic;   
   SIGNAL sampled_bit_temp        :  std_logic;   
   SIGNAL sampled_bit_q_temp      :  std_logic;   
   SIGNAL tx_point_temp           :  std_logic;   
   SIGNAL hard_sync_temp          :  std_logic;   

BEGIN
  
    if 





















   sample_point <= sample_point_temp;
   sampled_bit <= sampled_bit_temp;
   sampled_bit_q <= sampled_bit_q_temp;
  
   tx_point <= tx_point_temp;
   hard_sync <= hard_sync_temp;
   
   hard_sync_temp <= (((rx_idle OR rx_inter) AND (NOT rx)) AND sampled_bit_temp) AND (NOT hard_sync_blocked) ;
   resync <= ((((NOT rx_idle) AND (NOT rx_inter)) AND (NOT rx)) AND sampled_bit_temp) AND (NOT sync_blocked) ;


   -- Changing states 
   go_sync <= (((clk_en_q AND seg2) AND CONV_STD_LOGIC(quant_cnt(2 DOWNTO 0) = time_segment2))) AND (NOT resync) ;
   go_seg1 <= clk_en_q AND (sync OR hard_sync_temp OR ((resync AND seg2) AND sync_window) OR (resync_latched AND sync_window)) ;
   go_seg2 <= clk_en_q AND ((seg1 AND (NOT hard_sync_temp)) AND CONV_STD_LOGIC(quant_cnt = ( '0' & (time_segment1 + delay)))) ;


   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         tx_point_temp <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         tx_point_temp <= (NOT tx_point_temp AND seg2) AND ((clk_en AND CONV_STD_LOGIC(quant_cnt(2 DOWNTO 0) = time_segment2)) OR ((clk_en OR clk_en_q) AND (resync OR hard_sync_temp))) ;    
         
         --  When transmitter we should transmit as soon as possible.
      END IF;
   END PROCESS;

   -- When early edge is detected outside of the SJW field, synchronization request is latched and performed when
   --  When early edge is detected outside of the SJW field, synchronization request is latched and performed when
   --    SJW is reached 
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         resync_latched <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (((resync AND seg2) AND (NOT sync_window)) = '1') THEN
            resync_latched <= '1' ;    
         ELSE
            IF (go_seg1 = '1') THEN
               resync_latched <= '0';    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Synchronization stage/segment 
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         sync <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (clk_en_q = '1') THEN
            sync <= go_sync ;    
         END IF;
      END IF;
   END PROCESS;

   -- Seg1 stage/segment (together with propagation segment which is 1 quant long) 
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         seg1 <= '1';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (go_seg1 = '1') THEN
            seg1 <= '1' ;    
         ELSE
            IF (go_seg2 = '1') THEN
               seg1 <= '0' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Seg2 stage/segment 
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         seg2 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (go_seg2 = '1') THEN
            seg2 <= '1' ;    
         ELSE
            IF ((go_sync OR go_seg1) = '1') THEN
               seg2 <= '0' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Quant counter 
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         quant_cnt <= "00000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_sync OR go_seg1 OR go_seg2) = '1') THEN
            quant_cnt <= "00000" ;    
         ELSE
            IF (clk_en_q = '1') THEN
               quant_cnt <= quant_cnt + "00001" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   delay_temp  <= ("0" & ("00" & sync_jump_width + "0001")) WHEN (quant_cnt > "000" & sync_jump_width) ELSE (quant_cnt + "00001");

   -- When late edge is detected (in seg1 stage), stage seg1 is prolonged. 
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         delay <= "0000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (((resync AND seg1) AND (NOT transmitting OR (transmitting AND (tx_next_sp OR (tx AND (NOT rx)))))) = '1') THEN
            delay <= delay_temp (3 DOWNTO 0) ;    
         ELSE
            IF ((go_sync OR go_seg1) = '1') THEN
               delay <= "0000" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   
  
   -- If early edge appears within this window (in seg2 stage), phase error is fully compensated
   sync_window <= CONV_STD_LOGIC((time_segment2 - quant_cnt(2 DOWNTO 0)) < ('0' & (sync_jump_width + "01"))) ;


   -- tx_next_sp shows next value that will be driven on the TX. When driving 1 and receiving 0 we
   -- need to synchronize (even when we are a transmitter)
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         tx_next_sp <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_overload_frame OR go_error_frame OR go_tx OR send_ack) = '1') THEN
            tx_next_sp <= '0' ;    
         ELSE
               IF (sample_point_temp = '1') THEN
                  tx_next_sp <= tx_next ;    
               END IF;  
         END IF;
      END IF;
   END PROCESS;

   -- Blocking synchronization (can occur only once in a bit time) 
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         sync_blocked <= '1' ;    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (clk_en_q = '1') THEN
            IF (resync = '1') THEN
               sync_blocked <= '1' ;    
            ELSE
               IF (go_seg2 = '1') THEN
                  sync_blocked <= '0' ;    
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;
   

   -- Blocking hard synchronization when occurs once or when we are transmitting a msg 
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         hard_sync_blocked <= '0' ;    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (((hard_sync_temp AND clk_en_q) OR ((((transmitting AND transmitter) OR go_tx) AND tx_point_temp) AND (NOT tx_next))) = '1') THEN
            hard_sync_blocked <= '1' ;    
         ELSE
            IF ((go_rx_inter OR (((rx_idle OR rx_inter) AND sample_point_temp) AND sampled_bit_temp)) = '1') THEN
               -- When a glitch performed synchronization
               
               hard_sync_blocked <= '0' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

END ARCHITECTURE RTL;
