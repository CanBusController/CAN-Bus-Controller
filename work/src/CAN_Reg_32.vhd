--A 32 bit register
library ieee;  
use ieee.std_logic_1164.all;  

--Reg_IN    : the signal that carries the data to be written into the register
--REG_OUT   : the output signal
--Load_En   : used to control writing to the register
--clock	    : clock signal

entity CAN_Reg_32 is 
    port (
	    Reg_IN : in std_logic_vector(31 downto 0) ;
	    Load_En: in std_logic; 
	    clock  : in std_logic; 
	    Reg_OUT: out std_logic_vector(31 downto 0) 
	 );
end CAN_Reg_32; 

architecture archi_reg_32 of CAN_Reg_32 is 
begin
    reg: process(Load_En, clock, Reg_IN)
    begin
	if ( clock'event and clock='1' ) then
	    if ( Load_En = '1' ) then
		Reg_OUT <= Reg_IN ;
	    end if; 
	end if ;
    end process ;
end archi_reg_32 ;
