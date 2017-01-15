library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity CAN_baudrate_prescaler is
	port (     
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      baud_r_presc            : IN std_logic_vector(5 DOWNTO 0);    
      clk_eQ                  : OUT std_logic
);   
end entity ;

architecture arch of CAN_baudrate_prescaler is

signal baud_count : integer range 0 to 64 ;
begin

	baud_timer: process(clk,rst)
	begin
	if ( rst = '1' ) then
		baud_count<=0;

	elsif clk'event and clk='1' then
		if baud_count=unsigned(baud_r_presc)then
			baud_count <= 0;
			clk_eQ <= '1';
		else
			baud_count <= baud_count + 1;
			clk_eQ <= '0';
		end if;
	end if;
	end process baud_timer;
end architecture;
