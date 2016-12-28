
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_bit_timing_logic IS
   PORT (
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      rx                      : IN std_logic;   
      tx                      : IN std_logic;   
      -- Bus Timing 0 register 
      baud_r_presc            : IN std_logic_vector(5 DOWNTO 0);   
      sync_jump_width         : IN std_logic_vector(1 DOWNTO 0);   
      -- Bus Timing 1 register 
      time_segment1           : IN std_logic_vector(3 DOWNTO 0);   
      time_segment2           : IN std_logic_vector(2 DOWNTO 0);   
      triple_sampling         : IN std_logic;   
      -- Output signals from this module 
      sample_point            : OUT std_logic;   
      sampled_bit             : OUT std_logic;   
      sampled_bit_q           : OUT std_logic;   
      tx_point                : OUT std_logic;   
      hard_sync               : OUT std_logic;   



      -- Output from can_bsp module 
      rx_idle                 : IN std_logic;   
      rx_inter                : IN std_logic;   
      transmitting            : IN std_logic;   
      transmitter             : IN std_logic;   
      go_rx_inter             : IN std_logic;   
      tx_next                 : IN std_logic;   
      go_overload_frame       : IN std_logic;   
      go_error_frame          : IN std_logic;   
      go_tx                   : IN std_logic;   
      send_ack                : IN std_logic;   
      node_error_passive      : IN std_logic);   
END ENTITY can_bit_timing_logic;



ARCHITECTURE RTL OF can_bit_timing_logic IS

function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end;

   TYPE xhdl_46 IS ARRAY (0 TO 7) OF std_logic_vector(7 DOWNTO 0);

   SIGNAL clk_cnt                  :  std_logic_vector(6 DOWNTO 0);   
   SIGNAL clk_en                   :  std_logic;   
   SIGNAL clk_en_q                 :  std_logic;   
   SIGNAL sync_blocked             :  std_logic;   
   SIGNAL hard_sync_blocked        :  std_logic;   
   SIGNAL quant_cnt                :  std_logic_vector(4 DOWNTO 0);   
   SIGNAL delay                    :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL sync                     :  std_logic;   
   SIGNAL seg1                     :  std_logic;   
   SIGNAL seg2                     :  std_logic;   

   SIGNAL resync_latched           :  std_logic;   
   SIGNAL sample                   :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL tx_next_sp               :  std_logic;   
   SIGNAL go_sync                  :  std_logic;   
   SIGNAL go_seg1                  :  std_logic;   
   SIGNAL go_seg2                  :  std_logic;   
   SIGNAL preset_cnt               :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL sync_window              :  std_logic;   
   SIGNAL resync                   :  std_logic;   

   -- when transmitting 0 with positive error delay is set to 0
   SIGNAL temp_xhdl6               :  std_logic_vector(4 DOWNTO 0);   
   SIGNAL sample_point_xhdl1       :  std_logic;   
   SIGNAL sampled_bit_xhdl2        :  std_logic;   
   SIGNAL sampled_bit_q_xhdl3      :  std_logic;   
   SIGNAL tx_point_xhdl4           :  std_logic;   
   SIGNAL hard_sync_xhdl5          :  std_logic;   

BEGIN
   sample_point <= sample_point_xhdl1;
   sampled_bit <= sampled_bit_xhdl2;
   sampled_bit_q <= sampled_bit_q_xhdl3;
   tx_point <= tx_point_xhdl4;
   hard_sync <= hard_sync_xhdl5;
   preset_cnt <=  (('0' & baud_r_presc) + 1) & "0" ;
   hard_sync_xhdl5 <= (((rx_idle OR rx_inter) AND (NOT rx)) AND sampled_bit_xhdl2) AND (NOT hard_sync_blocked) ;
   resync <= ((((NOT rx_idle) AND (NOT rx_inter)) AND (NOT rx)) AND sampled_bit_xhdl2) AND (NOT sync_blocked) ;

   -- Generating general enable signal that defines baud rate. 
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         clk_cnt <= "0000000";
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (('0' & clk_cnt) >= (preset_cnt - "00000001")) THEN
            clk_cnt <= "0000000";
         ELSE
            clk_cnt <= clk_cnt + "0000001" ; 
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         clk_en <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (('0' & clk_cnt) = (preset_cnt - "00000001")) THEN
            clk_en <= '1' ;    
         ELSE
            clk_en <= '0' ;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         clk_en_q <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         clk_en_q <= clk_en ;    
      END IF;
   END PROCESS;

   -- Changing states 
   go_sync <= (((clk_en_q AND seg2) AND CONV_STD_LOGIC(quant_cnt(2 DOWNTO 0) = time_segment2))) AND (NOT resync) ;
   go_seg1 <= clk_en_q AND (sync OR hard_sync_xhdl5 OR ((resync AND seg2) AND sync_window) OR (resync_latched AND sync_window)) ;
   go_seg2 <= clk_en_q AND ((seg1 AND (NOT hard_sync_xhdl5)) AND CONV_STD_LOGIC(quant_cnt = ( '0' & (time_segment1 + delay)))) ;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         tx_point_xhdl4 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         tx_point_xhdl4 <= (NOT tx_point_xhdl4 AND seg2) AND ((clk_en AND CONV_STD_LOGIC(quant_cnt(2 DOWNTO 0) = time_segment2)) OR ((clk_en OR clk_en_q) AND (resync OR hard_sync_xhdl5))) ;    --  When transmitter we should transmit as soon as possible.
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
   temp_xhdl6 <= ("0" & ("00" & sync_jump_width + "0001")) WHEN (quant_cnt > "000" & sync_jump_width) ELSE (quant_cnt + "00001");

   -- When late edge is detected (in seg1 stage), stage seg1 is prolonged. 
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         delay <= "0000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (((resync AND seg1) AND (NOT transmitting OR (transmitting AND (tx_next_sp OR (tx AND (NOT rx)))))) = '1') THEN
            delay <= temp_xhdl6(3 DOWNTO 0) ;    
         ELSE
            IF ((go_sync OR go_seg1) = '1') THEN
               delay <= "0000" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   -- If early edge appears within this window (in seg2 stage), phase error is fully compensated
   sync_window <= CONV_STD_LOGIC((time_segment2 - quant_cnt(2 DOWNTO 0)) < ('0' & (sync_jump_width + "01"))) ;

   -- Sampling data (memorizing two samples all the time).
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         sample <= "11";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (clk_en_q = '1') THEN
            sample <= sample(0) & rx;    
         END IF;
      END IF;
   END PROCESS;

   -- tx_next_sp shows next value that will be driven on the TX. When driving 1 and receiving 0 we
   -- need to synchronize (even when we are a transmitter)
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         tx_next_sp <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_overload_frame OR (go_error_frame AND (NOT node_error_passive)) OR go_tx OR send_ack) = '1') THEN
            tx_next_sp <= '0' ;    
         ELSE
            IF ((go_error_frame AND node_error_passive) = '1') THEN
               tx_next_sp <= '1' ;    
            ELSE
               IF (sample_point_xhdl1 = '1') THEN
                  tx_next_sp <= tx_next ;    
               END IF;
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
         IF (((hard_sync_xhdl5 AND clk_en_q) OR ((((transmitting AND transmitter) OR go_tx) AND tx_point_xhdl4) AND (NOT tx_next))) = '1') THEN
            hard_sync_blocked <= '1' ;    
         ELSE
            IF ((go_rx_inter OR (((rx_idle OR rx_inter) AND sample_point_xhdl1) AND sampled_bit_xhdl2)) = '1') THEN
               -- When a glitch performed synchronization
               
               hard_sync_blocked <= '0' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

END ARCHITECTURE RTL;