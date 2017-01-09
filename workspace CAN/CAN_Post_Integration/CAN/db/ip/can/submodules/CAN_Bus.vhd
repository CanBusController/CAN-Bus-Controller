library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity can_BUS is
    port(
            rx1 :        out std_logic;
            rx2 :        out std_logic;
            tx1 :        in std_logic;
            tx2 :        in std_logic 
        );
end entity ;

architecture can_bus of can_BUS is

signal bus_signal : std_logic :='1'  ;
  
  begin 
    rx1<= bus_signal;
    rx2<= bus_signal;
    process (tx1,tx2)
      begin
          if tx1='0' or tx2='0' then
            bus_signal <='0';
          else 
            bus_signal <='1';
          end if;
      end process;
  end can_bus;