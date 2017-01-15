LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity CAN_Baudrate_Prescaler_test is
end entity ;

architecture arch_CAN_Baudrate_Prescaler_test of CAN_Baudrate_Prescaler_test is
component can_baudrate_prescaler
	port (
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      baud_r_presc            : IN std_logic_vector(5 DOWNTO 0);    
      clk_eQ                  : OUT std_logic
      ); 
end component;
signal      clk                     :  std_logic;   
signal      rst                     :  std_logic;   
signal      brp        		    :  std_logic_vector(5 DOWNTO 0);    
signal      eq                      :  std_logic ;
constant clk_period : time := 100 ps;
begin
   cbp_test: can_baudrate_prescaler port map( clk=>clk, rst=>rst, baud_r_presc=>brp, clk_eQ=>eq ) ;
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
	wait for 2*clk_period;
	rst<='0';
	brp<="000010";
	wait for 10*clk_period;
	brp<="001000";
	wait for 10*clk_period;
	
	end process;
end architecture ;