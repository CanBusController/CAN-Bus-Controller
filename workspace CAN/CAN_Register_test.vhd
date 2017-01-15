LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity CAN_Register_test is
end entity ;

architecture arch_CAN_Register_test of CAN_Register_test is
component CAN_Register 
	port ( 
        data_in 	  	: IN STD_LOGIC_VECTOR( 15 DOWNTO 0);
        data_out  	        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        we 		        : IN STD_LOGIC ;
        we_async 		: IN STD_LOGIC ;
        clk			: IN STD_LOGIC ;
        rst 			: IN STD_LOGIC
    );
end component ;
signal        data_in 	  		:  STD_LOGIC_VECTOR( 15 DOWNTO 0);
signal        data_out  	        :  STD_LOGIC_VECTOR(15 DOWNTO 0);
signal        we 		        :  STD_LOGIC:='0' ;
signal        we_async 			:  STD_LOGIC:='0' ;
signal        clk			:  STD_LOGIC ;
signal        rst 			:  STD_LOGIC ;
constant      clk_period		:  time := 100 ps;
begin
    rg_test: CAN_Register port map ( data_in=>data_in, data_out=>data_out, we=>we, we_async=>we_async, clk=>clk,
					rst=>rst );
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
		rst<='1';
		data_in<=X"ABCD";
		wait for 2*clk_period;
		rst<='0';
		wait for 2*clk_period;
		we<='1';
		wait for 2*clk_period;
		we<='0';
		we_async<='1';
		wait for clk_period;
		data_in<=X"1234";
		wait for 2*clk_period;
	end process;
end architecture ;
