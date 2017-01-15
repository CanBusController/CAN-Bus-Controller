LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity CAN_Controller_Top_test is 
end entity ;

architecture arch_CAN_Controller_Top_test of CAN_Controller_Top_test is
component CAN_Controller_Top port( 
 clk, rst : IN STD_LOGIC;
      read, write : IN STD_LOGIC;
      address : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      writedata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      readdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      TxCAN : OUT STD_LOGIC;
      RxCAN : IN STD_LOGIC 
	);  
end component; 
signal  clk :  STD_LOGIC;
signal  rst :  STD_LOGIC;
 signal     read :  STD_LOGIC;
 signal     write :  STD_LOGIC;
 signal     address :  STD_LOGIC_VECTOR(5 DOWNTO 0);
 signal     writedata :  STD_LOGIC_VECTOR(15 DOWNTO 0);
 signal     readdata :  STD_LOGIC_VECTOR(15 DOWNTO 0);
 signal     TxCAN :  STD_LOGIC;
 signal     RxCAN :  STD_LOGIC ;
signal ok_packet: std_logic_vector( 109 downto 0):="01010101010001100001010101010101010101010101010101010101010101010101010101010101010101010101010111110111110111";

 constant   clk_period: time:= 100 ps;
begin
    cct: CAN_Controller_Top port map(clk=>clk,rst=>rst,read=>read,write=>write,address=>address,writedata=>writedata,
					readdata=>readdata,TxCAN=>TxCAN,RxCAN=>RxCAN);
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
	write<='1';
	read<='0';
	--data1_2
	address<="100000";
	writedata<="0101010101010101";
	wait for 2*clk_period;
	address<="101000";
	wait for 2*clk_period;	
	address<="110000";
	wait for 2*clk_period;	
	--data7_8
	address<="111000";
	wait for 2*clk_period;
	--id
	address<="001000";
	writedata<="0000001010101010";
	wait for 2*clk_period;
	--rtr, extended, dlc
	address<="011000";
	writedata<=X"0008";
	wait for 2*clk_period;
	--timing register
	address<="000000";
	writedata<="0100100000100010";
	wait for 2*clk_period;
	for i in 0 to 109 loop
		RxCan<=ok_packet(109-i);
		wait for clk_period;
	end loop;
	write<='0';
	read<='1';
	address<="100000";
	wait for 2*clk_period;
    end process;
end architecture;
