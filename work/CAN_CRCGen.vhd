LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_crcgen IS
   PORT (
      clk                     : IN std_logic;   
      data                    : IN std_logic;   
      enable                  : IN std_logic;   
      initialize              : IN std_logic;   
      crc                     : OUT std_logic_vector(14 DOWNTO 0));   
END ENTITY can_crcgen;

ARCHITECTURE RTL OF can_crcgen IS

   SIGNAL crc_next                 :  std_logic;   
   SIGNAL crc_tmp                  :  std_logic_vector(14 DOWNTO 0);   
   SIGNAL crc_res                :  std_logic_vector(14 DOWNTO 0);   

BEGIN
   crc <= crc_res;
   crc_next <= data XOR crc_res(14) ;
   crc_tmp <= crc_res(13 DOWNTO 0) & '0' ;

   PROCESS (clk)
   BEGIN
      IF (clk'EVENT AND clk = '1') THEN
         IF (initialize = '1') THEN
            crc_res <= "000000000000000";    
         ELSE
            IF (enable = '1') THEN
               IF (crc_next = '1') THEN
                  crc_res <= crc_tmp XOR "100010110011001";    
               ELSE
                  crc_res <= crc_tmp ;    
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

END ARCHITECTURE RTL;