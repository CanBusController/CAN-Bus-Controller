LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY can_vhdl_ibo IS
   PORT (
      di                      : IN std_logic_vector(7 DOWNTO 0);   
      do                      : OUT std_logic_vector(7 DOWNTO 0));   
END ENTITY can_vhdl_ibo;

ARCHITECTURE RTL OF can_vhdl_ibo IS

   SIGNAL do_xhdl1                 :  std_logic_vector(7 DOWNTO 0);   

BEGIN
   do <= do_xhdl1;
   do_xhdl1(0) <= di(7) ;
   do_xhdl1(1) <= di(6) ;
   do_xhdl1(2) <= di(5) ;
   do_xhdl1(3) <= di(4) ;
   do_xhdl1(4) <= di(3) ;
   do_xhdl1(5) <= di(2) ;
   do_xhdl1(6) <= di(1) ;
   do_xhdl1(7) <= di(0) ;

END ARCHITECTURE RTL;