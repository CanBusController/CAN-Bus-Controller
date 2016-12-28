library ieee;
use ieee.std_logic_1164.all;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity can_banc_registers is  
  port(clk,WrE,RdE  : in  std_logic; 
      DIn          : in std_logic_vector(7 downto 0);
      DOut         : out std_logic_vector(7 downto 0);
      Add           : in std_logic_vector(3 downto 0));
      
  end can_banc_registers;  

architecture arch of can_banc_registers is 
component can_register is
	port(
		clk,rst,E: in std_logic;
		regin: in std_logic_vector(7 downto 0);
		regout: out std_logic_vector(7 downto 0)
	);
end component 

  signal E: std_logic;
  signal  
  begin  
  forreg:for i in 0 to 15 generate
		regi : can_register port map(clk => clk, D =>DIn, rst=> rst,E=>E,regout=>);
	end generate;
end arch;
    
    
    
      
  end arch; 