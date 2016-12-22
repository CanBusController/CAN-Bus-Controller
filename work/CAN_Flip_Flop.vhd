library ieee;  
use ieee.std_logic_1164.all;  
 
entity can_flip_flop is  
  port(clk, D, E,reset  : in  std_logic; 
      Q          : out std_logic);
   
end can_flip_flop;  
architecture archi of can_flip_flop is  
  begin  
    process (clk,reset)  
      begin  
        if (clk'event and clk='1' and E='1') then   
            Q <= D;  
        end if;
        if (reset='1') then 
            Q <= '0';
      end if;  
    end process;  
end archi; 