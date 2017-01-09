library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

--clk   : input clock signal
--data  : input data bit = sampled bit
--enable: to control the crc generator
--init  : when set initialize the crc number
--crc   : after the data field in the transmission/reception, crc will contain the crc sequence
--        applied on START OF FRAME, ARBITRATION FIELD, CONTROL FIELD, DATA FIELD

entity can_crc is 
    port (
             clk        :  in std_logic;
             data       :  in std_logic;
             enable     :  in std_logic;
             initialize :  in std_logic;
             crc        :  out std_logic_vector(14 downto 0) 
         );
end entity; 


architecture arch_can_crc of can_crc is 

	 
   SIGNAL crc_next                 :  std_logic;   
   SIGNAL crc_tmp                  :  std_logic_vector(14 DOWNTO 0);   
   SIGNAL crc_tmp2                 :  std_logic_vector(14 DOWNTO 0);   

BEGIN
   crc <= crc_tmp2;
   crc_next <= data XOR crc_tmp2(14) ;
   crc_tmp <= crc_tmp2(13 DOWNTO 0) & '0' ;

   PROCESS (clk)
   BEGIN
      IF (clk'EVENT AND clk = '1') THEN
         IF (initialize = '1') THEN
            crc_tmp2 <= "000000000000000";    
         ELSE
            IF (enable = '1') THEN
               IF (crc_next = '1') THEN
                  crc_tmp2 <= crc_tmp XOR "100010110011001";    
               ELSE
                  crc_tmp2 <= crc_tmp ;    
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;
    
end arch_can_crc; 
