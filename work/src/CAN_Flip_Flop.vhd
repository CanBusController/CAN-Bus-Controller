library ieee;  
use ieee.std_logic_1164.all;  

entity can_flip_flop is  
    port(clk, D, E,reset  : in  std_logic; 
	 Q          : out std_logic);

end can_flip_flop;  
-- in asynchronous flip flop, we should test the reset pin first
-- if it is set, we do Q<=0 and then exit
-- else we check the clock signal, not the other way around
architecture archi of can_flip_flop is  
begin  
    process (clk,reset)  
    begin  
	if (reset='1') then 
	    Q <= '0';
	elsif (clk'event and clk='1') then  
	    if ( E='1') then  
		Q <= D;  
	    end if;  
	end if;
    end process;  
end archi; 
