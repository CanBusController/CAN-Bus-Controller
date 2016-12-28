library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CAN_PiSo_Reg is
    port(
	    clk : in STD_LOGIC;
	    reset : in STD_LOGIC;
	    load : in STD_LOGIC;
	    din : in STD_LOGIC_VECTOR(7 downto 0);
	    dout : out STD_LOGIC
	);
end CAN_PiSo_Reg;


architecture piso_arc of CAN_PiSo_Reg is
begin

    piso : process (clk,reset,load,din) is
	variable temp : std_logic_vector (din'range);
    begin
	if (reset='1') then
	    temp := (others=>'0');
	elsif (load='1') then
	    temp := din ;
	elsif (rising_edge (clk)) then
	    dout <= temp(7);
	    temp := temp(6 downto 0) & '0';
	end if;
    end process piso;

end piso_arc;
