LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_vhdl_crc IS
   PORT (
      clk                     : IN std_logic;   
      data                    : IN std_logic;   
      enable                  : IN std_logic;   
      initialize              : IN std_logic;   
      crc                     : OUT std_logic_vector(14 DOWNTO 0));   
END ENTITY can_vhdl_crc;

ARCHITECTURE RTL OF can_vhdl_crc IS

   TYPE xhdl_46 IS ARRAY (0 TO 7) OF std_logic_vector(7 DOWNTO 0);

   SIGNAL crc_next                 :  std_logic;   
   SIGNAL crc_tmp                  :  std_logic_vector(14 DOWNTO 0);   
   SIGNAL crc_xhdl1                :  std_logic_vector(14 DOWNTO 0);   

BEGIN
   crc <= crc_xhdl1;
   crc_next <= data XOR crc_xhdl1(14) ;
   crc_tmp <= crc_xhdl1(13 DOWNTO 0) & '0' ;

   PROCESS (clk)
   BEGIN
      IF (clk'EVENT AND clk = '1') THEN
         IF (initialize = '1') THEN
            crc_xhdl1 <= "000000000000000";    
         ELSE
            IF (enable = '1') THEN
               IF (crc_next = '1') THEN
                  crc_xhdl1 <= crc_tmp XOR "100010110011001";    
               ELSE
                  crc_xhdl1 <= crc_tmp ;    
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

END ARCHITECTURE RTL;