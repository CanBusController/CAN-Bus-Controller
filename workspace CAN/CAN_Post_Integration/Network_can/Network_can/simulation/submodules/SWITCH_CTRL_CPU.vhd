LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY SWITCH_CTRL_CPU 	IS PORT 
	(	we_ctrl : IN STD_LOGIC ;
		we_cpu	: IN STD_LOGIC ;

		cpu_data_in	:	IN STD_LOGIC_VECTOR ;
		ctrl_data_in:	IN STD_LOGIC_VECTOR (15 DOWNTO 0) ;

		data_out	:	OUT STD_LOGIC_VECTOR (15 DOWNTO 0) ;
		we_OUT		: 	out STD_LOGIC 

		) ;
END ENTITY ;


ARCHITECTURE  SWITCH_CTRL_CPU_ARCH OF SWITCH_CTRL_CPU IS 
	BEGIN 

	we_OUT <=	'0' WHEN we_ctrl = '1' ELSE
				    we_cpu	WHEN we_cpu  = '1' ELSE
				    '0' ;

	data_out <= ctrl_data_in WHEN we_ctrl = '1' ELSE
				    cpu_data_in	WHEN we_cpu  = '1' else
					 (others=>'0');

	END ; 