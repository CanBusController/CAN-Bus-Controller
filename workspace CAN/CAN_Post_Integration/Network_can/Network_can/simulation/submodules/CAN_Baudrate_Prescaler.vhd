
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_baudrate_prescaler IS
   PORT (
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      baud_r_presc            : IN std_logic_vector(5 DOWNTO 0);    
      clk_eQ                  : OUT std_logic);   
END ENTITY can_baudrate_prescaler;



ARCHITECTURE RTL OF can_baudrate_prescaler IS

function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end;

   SIGNAL preset_cnt               :  std_logic_vector(7 DOWNTO 0);  
   SIGNAL clk_cnt                  :  std_logic_vector(6 DOWNTO 0);   
   SIGNAL clk_en                   :  std_logic;   
   SIGNAL clk_en_q                 :  std_logic;   

BEGIN
  
preset_cnt <=  (('0' & baud_r_presc) + 1) & "0" ;
clk_eQ <= clk_en_q;


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
   
END ARCHITECTURE RTL;