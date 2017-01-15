LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY CAN_Flip_Flop_TestB IS
    END CAN_Flip_Flop_TestB ; 

ARCHITECTURE CFFT_bhv of CAN_Flip_Flop_TestB is

    COMPONENT CAN_Flip_Flop
	port(
		clk, D, E,reset  : in  std_logic; 
	        Q                : out std_logic 
	    );
    END COMPONENT ;

    signal clk : std_logic := '0';
    signal D : std_logic := '0' ;
    signal E : std_logic := '0';
    signal reset : std_logic := '1' ;
    signal Q : std_logic  ;

    constant clk_period : time := 100 ns;

BEGIN
    CFFT: CAN_Flip_Flop PORT MAP ( clk => clk, D=>D, E=>E, reset=>reset, Q=>Q) ;
    --generating the clock signal 
    clk_process :process
    begin
	clk <= '0';
	wait until clk_period/2;  
	clk <= '1';
	wait until clk_period/2;
    end process;

    testing_process: process 
    begin 
	wait until 200 ns ;
	reset<='1';
	wait until 200 ns; 
	reset <= '0' ;
	E<='0';
	D<='1';
	wait until 200 ns ;
	reset <= '0' ;
	E<='0';
	D<='0';
	wait until 200 ns ;
	reset <= '0' ;
	E<='1';
	D<='1';
	wait until 200 ns ;
	reset <= '0' ;
	E<='1';
	D<='0';
    end process ;
END ;
