Library ieee;
Use ieee.std_logic_1164.All;
Entity CAN_Avalon_interface Is
	Port (
		clock, resetn : In STD_LOGIC;
		read, write, chipselect : In STD_LOGIC;
		address : In STD_LOGIC_VECTOR(3 Downto 0);
		writedata : In STD_LOGIC_VECTOR(15 Downto 0);
		byteenable : In STD_LOGIC_VECTOR(1 Downto 0);
		readdata : Out STD_LOGIC_VECTOR(15 Downto 0);
		Q_export : Out STD_LOGIC_VECTOR(15 Downto 0);
				irq  : out std_logic 
	);
End CAN_Avalon_interface;


Architecture Structure Of CAN_Avalon_interfaceregIs
	Signal local_byteenable : STD_LOGIC_VECTOR(1 Downto 0);
	Signal to_reg, from_reg : STD_LOGIC_VECTOR(15 Downto 0);
	Component CAN_Avalon_reg16
		Port (
			clock, resetn : In STD_LOGIC;
			D : In STD_LOGIC_VECTOR(15 Downto 0);
			byteenable : In STD_LOGIC_VECTOR(1 Downto 0);
			Q : Out STD_LOGIC_VECTOR(15 Downto 0) 
		);
	End Component;
Begin
	to_reg <= writedata;
	With (chipselect And write) Select
	     local_byteenable <= byteenable When '1', "00" When Others;
	reg_instance : CAN_Avalon_reg16 Port Map(clock, resetn, to_reg, local_byteenable, from_reg);
	readdata <= from_reg;
	Q_export <= from_reg;
End Structure;