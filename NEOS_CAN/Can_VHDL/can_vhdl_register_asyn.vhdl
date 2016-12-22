
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;


ENTITY can_vhdl_register_asyn IS
   GENERIC (
      WIDTH                          :  integer := 8;    --  default parameter of the register width
      RESET_VALUE                    :  integer := 0);    
   PORT (
      data_in                 : IN std_logic_vector(WIDTH - 1 DOWNTO 0);   
      data_out                : OUT std_logic_vector(WIDTH - 1 DOWNTO 0);   
      we                      : IN std_logic;   
      clk                     : IN std_logic;   
      rst                     : IN std_logic);   
END ENTITY can_vhdl_register_asyn;

ARCHITECTURE RTL OF can_vhdl_register_asyn IS

   SIGNAL data_out_xhdl1           :  std_logic_vector(WIDTH - 1 DOWNTO 0);   

BEGIN
   data_out <= data_out_xhdl1;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         -- asynchronous reset
         
         data_out_xhdl1 <= STD_LOGIC_VECTOR(conv_unsigned(RESET_VALUE, WIDTH));   
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (we = '1') THEN
            -- write
            
            data_out_xhdl1 <= data_in ;    
         END IF;
      END IF;
   END PROCESS;

END ARCHITECTURE RTL;