LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY CAN_interface_test IS
    END CAN_interface_test ; 

architecture arch_CAN_interface_test of CAN_interface_test is 
component CAN_interface 
PORT (
      RxCan            : IN std_logic;   
      TxCan            : out std_logic;
      time_reg         : in std_logic_vector(15 downto 0 ); 
      
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
		
		
		Clk              : in std_logic;
    Reset            : in std_logic
	);
end component;
 signal    		 RxCan            :  std_logic;   
signal      		 TxCan            :  std_logic;
signal      		 time_reg         :  std_logic_vector(15 downto 0 ); 
      
			-- message reg in/out -- 

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
		
		
signal	  	Clk              :  std_logic;
signal  		Reset            :  std_logic ;
constant clk_period: time := 100 ps;
begin
 interface: can_interface port map(RxCan=>RxCan, rx_data_7_8_we=>rx_data_7_8_we, rx_data_5_6_we=>rx_data_5_6_we,
		rx_data_3_4_we=>rx_data_3_4_we, rx_data_1_2_we=>rx_data_1_2_we,  rx_data_conf_we=>rx_data_conf_we,
		rx_data_id2_we=>rx_data_id2_we, rx_data_id1_we=>rx_data_id1_we, tx_data_7_8_we=>tx_data_7_8_we,
		tx_data_5_6_we=>tx_data_5_6_we,tx_data_3_4_we=>tx_data_3_4_we, tx_data_1_2_we=>tx_data_1_2_we,
		tx_data_7_8_out=>tx_data_7_8_out, tx_data_5_6_out=>tx_data_5_6_out, tx_data_3_4_out=>tx_data_3_4_out,
		tx_data_1_2_out=>tx_data_1_2_out,tx_data_conf_out=>tx_data_conf_out, tx_data_id2_out=>tx_data_id2_out,
		tx_data_id1_out=>tx_data_id1_out,tx_data_7_8_in=>tx_data_7_8_in,tx_data_5_6_in=>tx_data_5_6_in,
		tx_data_3_4_in=>tx_data_3_4_in,tx_data_1_2_in=>tx_data_1_2_in,rx_data_conf_in=>rx_data_conf_in,
		rx_data_id2_in=>rx_data_id2_in,rx_data_id1_in=>rx_data_id1_in, time_reg=>time_reg, TxCan=>TxCan, 
		Clk=>Clk, Reset=>Reset, rx_data_id1_out=>rx_data_id1_out,rx_data_id2_out=>rx_data_id2_out,
		rx_data_1_2_out=>rx_data_1_2_out, rx_data_3_4_out=>rx_data_3_4_out,rx_data_5_6_out=>rx_data_5_6_out,
		rx_data_7_8_out=>rx_data_7_8_out,rx_data_conf_out=>rx_data_conf_out
		);
	    --generating the clock signal 
    clk_process :process
    begin
	clk <= '0';
	wait for clk_period/2;  
	clk <= '1';
	wait for clk_period/2;
    end process;
    feeding_controller:process
    begin
	for i in 0 to 109 loop
		RxCan<=packet(109-i);
		wait for clk_period;
	end loop;
    end process;
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