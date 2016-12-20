LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity Reg_32_TestB is 
    end Reg_32_TestB ;

architecture archi_R32TB of Reg_32_TestB is 

    component CAN_Reg_32
	port (
		 Reg_IN : in std_logic_vector(31 downto 0) ;
		 Load_En: in std_logic; 
		 clock  : in std_logic; 
		 Reg_OUT: out std_logic_vector(31 downto 0) 
	     );
    end component ;

    signal Reg_IN : std_logic_vector(31 downto 0) ;
    signal Load_En: std_logic; 
    signal clock  : std_logic; 
    signal Reg_OUT: std_logic_vector(31 downto 0) ;

    constant clock_period : time := 100 ns ;

begin
    CR32T: CAN_Reg_32 PORT MAP ( Reg_IN => Reg_IN, Load_En => Load_En, clock => clock, Reg_OUT=>Reg_OUT);
    --generate clock signal
    clock_process:process
    begin
	clock <= '0' ;
	wait for clock_period/2;
	clock <= '1' ;
	wait for clock_period/2;
    end process;
    --feed the input signals to the register
    testing_process:process
    begin
	Load_En<= '0';
	Reg_IN <= X"ABCDEFAA";
	wait for 200 ns;
	Load_En <= '1';
	Reg_IN <= X"ABCDEFAA";
	wait for 200 ns ;
	Load_En <= '1';
	Reg_IN <= X"01234567";
	wait for 200 ns ;
    end process ;

end archi_R32TB;
