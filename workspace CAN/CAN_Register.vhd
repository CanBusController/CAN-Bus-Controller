LIBRARY ieee ;
USE ieee.std_logic_1164.all ;



ENTITY can_register IS 
	GENERIC 
	( width: integer := 16
		);
	PORT
	(
		data_in 	: IN STD_LOGIC_VECTOR( width - 1 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(width  - 1 DOWNTO 0);
		we 			: IN STD_LOGIC ;
		clk			: IN STD_LOGIC ;
		rst 		: IN STD_LOGIC
		);
END ENTITY can_register ;

ARCHITECTURE RTL OF can_register IS
	BEGIN
		PROCESS(clk,rst)
		BEGIN
		  IF(rst='1') THEN
				data_out<=(OTHERS=>'0');
			ELSIF (clk'EVENT AND clk='1' and rst='0') THEN 
				IF (we='1') THEN
					data_out<= data_in ;
				END IF;
			END IF;
		END PROCESS;
END ARCHITECTURE RTL ;
