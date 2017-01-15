LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity CAN_Control_test is
end entity ;

architecture arch_CAN_Control_test of CAN_Control_test is
component CAN_Control port (
		time_reg_in	:	IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		time_reg_out	:	OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		time_reg_we	:	IN STD_LOGIC ;
		clk		:	IN STD_LOGIC ;
		RST 		:	IN STD_LOGIC 
	        );
end component ;

signal		time_reg_in	:	 STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
signal		time_reg_out	:	 STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
signal		time_reg_we	:	 STD_LOGIC ;
signal		clk		:	 STD_LOGIC ;
signal		RST 		:	 STD_LOGIC ;
constant      clk_period	: 	 time := 100 ps;

  

begin
  control_test: CAN_Control port map(time_reg_in=>time_reg_in, time_reg_out=>time_reg_out, time_reg_we=>time_reg_we,
					clk=>clk, RST=>RST);
  --generating the clock signal 
    clk_process :process
    begin
	clk <= '0';
	wait for clk_period/2;  
	clk <= '1';
	wait for clk_period/2;
    end process;

    testing_process:process
    begin
	RST<='1';
	wait for 2*clk_period;
	time_reg_we<='0';
	time_reg_in<=X"ABCD";
	RST<='0';
	wait for 2*clk_period;
	time_reg_we<='1';
	wait for clk_period;
	time_reg_in<=X"4567";
	wait for clk_period;
	time_reg_we<='0';
	wait for clk_period;
	time_reg_in<=X"789A";
	wait for 2*clk_period;
    end process;
end architecture ;