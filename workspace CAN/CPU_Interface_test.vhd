LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY cpu_interface_test IS
    END cpu_interface_test ; 

architecture arch_cpu_interface_test of cpu_interface_test is

component cpu_interface 
	PORT (
			-- Avalon bus in/out -- 

		clock_avalon, rst_avalon : IN STD_LOGIC;
		read, write : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		writedata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		readdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);


			-- message reg in/out -- 

		rx_data_id1_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_id2_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		rx_data_conf_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;	

		rx_data_1_2_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_3_4_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_5_6_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_7_8_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_id1_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_id2_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_conf_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_1_2_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_3_4_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_5_6_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_7_8_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_id1_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_id2_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_conf_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_1_2_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_3_4_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_5_6_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_7_8_in	: OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;


		tx_data_id1_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_id2_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_conf_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_1_2_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_3_4_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_5_6_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_7_8_out: IN STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_id1_we	: OUT STD_LOGIC;
		tx_data_id2_we	: OUT STD_LOGIC;

		tx_data_conf_we	: OUT STD_LOGIC;

		tx_data_1_2_we	: OUT STD_LOGIC;
		tx_data_3_4_we	: OUT STD_LOGIC;
		tx_data_5_6_we	: OUT STD_LOGIC;
		tx_data_7_8_we	: OUT STD_LOGIC;

		rx_data_id1_we	: OUT STD_LOGIC;
		rx_data_id2_we	: OUT STD_LOGIC;

		rx_data_conf_we	: OUT STD_LOGIC;

		rx_data_1_2_we	: OUT STD_LOGIC;
		rx_data_3_4_we	: OUT STD_LOGIC;
		rx_data_5_6_we	: OUT STD_LOGIC;
		rx_data_7_8_we	: OUT STD_LOGIC;


			-- timing reg in/out -- 

		time_reg_in	:	OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		time_reg_out:	IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		time_reg_we	:	OUT STD_LOGIC 

	);
end component;
signal		time_reg_in	: STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

signal		time_reg_out: STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

signal		time_reg_we	: STD_LOGIC ;
signal address: std_logic_vector(5 downto 0);
 signal    		 RxCan            :  std_logic;   
signal      		 TxCan            :  std_logic;
signal      		 time_reg         :  std_logic_vector(15 downto 0 ); 
      
			-- message reg in/out -- 
signal readdata:std_logic_vector(15 downto 0);
signal writedata:std_logic_vector(15 downto 0);
signal		rx_data_id1_in	:  STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
signal		rx_data_id2_in	:  STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

signal		rx_data_conf_in	:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;	

signal		rx_data_1_2_in	:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal		rx_data_3_4_in	:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	signal	rx_data_5_6_in	:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	signal	rx_data_7_8_in	:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		signal rx_data_id1_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal	rx_data_id2_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	signal	rx_data_conf_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	signal	rx_data_1_2_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal		rx_data_3_4_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal		rx_data_5_6_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal		rx_data_7_8_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

signal		tx_data_id1_in	:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal		tx_data_id2_in	:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

signal		tx_data_conf_in	:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

signal		tx_data_1_2_in	:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal	tx_data_3_4_in	:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal 		tx_data_5_6_in	:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal		tx_data_7_8_in	:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;


signal		tx_data_id1_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal		tx_data_id2_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

signal		tx_data_conf_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

signal		tx_data_1_2_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal		tx_data_3_4_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal		tx_data_5_6_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
signal		tx_data_7_8_out:  STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

signal		tx_data_id1_we	:  STD_LOGIC;
signal		tx_data_id2_we	:  STD_LOGIC;

signal		tx_data_conf_we	:  STD_LOGIC;

signal		tx_data_1_2_we	:  STD_LOGIC;
signal		tx_data_3_4_we	:  STD_LOGIC;
signal		tx_data_5_6_we	:  STD_LOGIC;
signal		tx_data_7_8_we	:  STD_LOGIC;

signal		rx_data_id1_we	:  STD_LOGIC;
signal		rx_data_id2_we	:  STD_LOGIC;

signal		rx_data_conf_we	:  STD_LOGIC;

signal		rx_data_1_2_we	:  STD_LOGIC;
signal		rx_data_3_4_we	:  STD_LOGIC;
signal		rx_data_5_6_we	:  STD_LOGIC;
signal		rx_data_7_8_we	:  STD_LOGIC;
signal packet: std_logic_vector( 109 downto 0):="01010101010001100001010101010101010101010101010101010101010101010101010101010101010101010101010111110111110111";
		
signal read: std_logic;
signal write:std_logic;	
signal	  	Clk              :  std_logic;
signal  		Reset            :  std_logic ;
constant clk_period: time := 100 ps;
begin
	cpu: CPU_Interface port map(clock_avalon=>clk, rst_avalon=>reset, read=>read, write=>write,address=>address,
			readdata=>readdata, writedata=>writedata,rx_data_7_8_we=>rx_data_7_8_we, rx_data_5_6_we=>rx_data_5_6_we,
		rx_data_3_4_we=>rx_data_3_4_we, rx_data_1_2_we=>rx_data_1_2_we,  rx_data_conf_we=>rx_data_conf_we,
		rx_data_id2_we=>rx_data_id2_we, rx_data_id1_we=>rx_data_id1_we, tx_data_7_8_we=>tx_data_7_8_we,
		tx_data_5_6_we=>tx_data_5_6_we,tx_data_3_4_we=>tx_data_3_4_we, tx_data_1_2_we=>tx_data_1_2_we,
		tx_data_7_8_out=>tx_data_7_8_out, tx_data_5_6_out=>tx_data_5_6_out, tx_data_3_4_out=>tx_data_3_4_out,
		tx_data_1_2_out=>tx_data_1_2_out,tx_data_conf_out=>tx_data_conf_out, tx_data_id2_out=>tx_data_id2_out,
		tx_data_id1_out=>tx_data_id1_out,tx_data_7_8_in=>tx_data_7_8_in,tx_data_5_6_in=>tx_data_5_6_in,
		tx_data_3_4_in=>tx_data_3_4_in,tx_data_1_2_in=>tx_data_1_2_in,rx_data_conf_in=>rx_data_conf_in,
		rx_data_id2_in=>rx_data_id2_in,rx_data_id1_in=>rx_data_id1_in, 
		rx_data_id1_out=>rx_data_id1_out,rx_data_id2_out=>rx_data_id2_out,
		rx_data_1_2_out=>rx_data_1_2_out, rx_data_3_4_out=>rx_data_3_4_out,rx_data_5_6_out=>rx_data_5_6_out,
		rx_data_7_8_out=>rx_data_7_8_out,rx_data_conf_out=>rx_data_conf_out,time_reg_in=>time_reg_in, 
		time_reg_out=>time_reg_out, time_reg_we=>time_reg_we
		);
    testintg_process:process
    begin
	reset<='1';
	wait for 2*clk_period;
	reset<='0';
	tx_data_id1_in<="1000001010101010";
	tx_data_conf_out<=X"0008";
		tx_data_1_2_out<=X"5555";
		tx_data_3_4_out<=X"5555";
		tx_data_5_6_out<=X"5555";
		tx_data_7_8_out<=X"5555";
		time_reg<="0100100000100010";
	wait for 2*clk_period;
	reset<='1';
	wait for clk_period;
	reset<='0';
	wait for clk_period;
    end process;
end architecture;