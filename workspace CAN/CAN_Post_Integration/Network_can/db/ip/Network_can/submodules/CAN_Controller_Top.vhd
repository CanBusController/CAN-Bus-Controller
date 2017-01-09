
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY CAN_Controller_top IS
   PORT (
      clk, rst : IN STD_LOGIC;
      read, write : IN STD_LOGIC;
      address : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      writedata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      readdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      TxCAN : OUT STD_LOGIC;
      RxCAN : IN STD_LOGIC );      
END ENTITY CAN_Controller_top;

ARCHITECTURE RTL OF CAN_Controller_top IS

	SIGNAL time_reg_in_sig : STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
	SIGNAL time_reg_out_sig : STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
	SIGNAL time_reg_we_sig : STD_LOGIC ;
	
	SIGNAL rx_data_id1_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_id2_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL rx_data_conf_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;	

	SIGNAL rx_data_1_2_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_3_4_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_5_6_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_7_8_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;


	SIGNAL tx_data_id1_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_id2_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL tx_data_conf_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL tx_data_1_2_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_3_4_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_5_6_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_7_8_in_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;


	SIGNAL rx_data_id1_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_id2_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL rx_data_conf_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;	

	SIGNAL rx_data_1_2_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_3_4_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_5_6_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_7_8_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;


	SIGNAL tx_data_id1_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_id2_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL tx_data_conf_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL tx_data_1_2_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_3_4_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_5_6_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_7_8_out_sig	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL tx_data_id1_we_sig	:   STD_LOGIC := '0';
	SIGNAL tx_data_id2_we_sig	:   STD_LOGIC := '0';

	SIGNAL tx_data_conf_we_sig	:   STD_LOGIC := '0';

	SIGNAL tx_data_1_2_we_sig	:   STD_LOGIC := '0';
	SIGNAL tx_data_3_4_we_sig	:   STD_LOGIC := '0';
	SIGNAL tx_data_5_6_we_sig	:   STD_LOGIC := '0';
	SIGNAL tx_data_7_8_we_sig	:   STD_LOGIC := '0';

	SIGNAL rx_data_id1_we_sig	:   STD_LOGIC := '0' ;
	SIGNAL rx_data_id2_we_sig	:   STD_LOGIC := '0';

	SIGNAL rx_data_conf_we_sig	:   STD_LOGIC := '0';

	SIGNAL rx_data_1_2_we_sig	:   STD_LOGIC := '0';
	SIGNAL rx_data_3_4_we_sig	:   STD_LOGIC := '0';
	SIGNAL rx_data_5_6_we_sig	:   STD_LOGIC := '0';
	SIGNAL rx_data_7_8_we_sig	:   STD_LOGIC := '0';
	
	
	
		 ------ CAN INTERFACE SIGNAL ------
	SIGNAL rx_data_id1_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_id2_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 )  ;

	SIGNAL rx_data_conf_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;	

	SIGNAL rx_data_1_2_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_3_4_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_5_6_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_7_8_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;


	SIGNAL tx_data_id1_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_id2_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL tx_data_conf_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL tx_data_1_2_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_3_4_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_5_6_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_7_8_in_sig_CAN	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;




	SIGNAL tx_data_id1_we_sig_CAN	:   STD_LOGIC := '0';
	SIGNAL tx_data_id2_we_sig_CAN	:   STD_LOGIC := '0';

	SIGNAL tx_data_conf_we_sig_CAN	:   STD_LOGIC := '0';

	SIGNAL tx_data_1_2_we_sig_CAN	:   STD_LOGIC := '0';
	SIGNAL tx_data_3_4_we_sig_CAN	:   STD_LOGIC := '0';
	SIGNAL tx_data_5_6_we_sig_CAN	:   STD_LOGIC := '0';
	SIGNAL tx_data_7_8_we_sig_CAN	:   STD_LOGIC := '0';

	SIGNAL rx_data_id1_we_sig_CAN	:   STD_LOGIC := '0' ;
	SIGNAL rx_data_id2_we_sig_CAN	:   STD_LOGIC := '0';

	SIGNAL rx_data_conf_we_sig_CAN	:   STD_LOGIC := '0';

	SIGNAL rx_data_1_2_we_sig_CAN	:   STD_LOGIC := '0';
	SIGNAL rx_data_3_4_we_sig_CAN	:   STD_LOGIC := '0';
	SIGNAL rx_data_5_6_we_sig_CAN	:   STD_LOGIC := '0';
	SIGNAL rx_data_7_8_we_sig_CAN	:   STD_LOGIC := '0';
	
	
	
	
	 ------ CPU INTERFACE SIGNAL ------
	SIGNAL rx_data_id1_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_id2_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL rx_data_conf_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;	

	SIGNAL rx_data_1_2_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_3_4_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_5_6_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL rx_data_7_8_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;


	SIGNAL tx_data_id1_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_id2_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL tx_data_conf_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

	SIGNAL tx_data_1_2_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_3_4_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_5_6_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
	SIGNAL tx_data_7_8_in_sig_CPU	: STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;




	SIGNAL tx_data_id1_we_sig_CPU	:   STD_LOGIC := '0';
	SIGNAL tx_data_id2_we_sig_CPU	:   STD_LOGIC := '0';

	SIGNAL tx_data_conf_we_sig_CPU	:   STD_LOGIC := '0';

	SIGNAL tx_data_1_2_we_sig_CPU	:   STD_LOGIC := '0';
	SIGNAL tx_data_3_4_we_sig_CPU	:   STD_LOGIC := '0';
	SIGNAL tx_data_5_6_we_sig_CPU	:   STD_LOGIC := '0';
	SIGNAL tx_data_7_8_we_sig_CPU	:   STD_LOGIC := '0';

	SIGNAL rx_data_id1_we_sig_CPU	:   STD_LOGIC := '0' ;
	SIGNAL rx_data_id2_we_sig_CPU	:   STD_LOGIC := '0';

	SIGNAL rx_data_conf_we_sig_CPU	:   STD_LOGIC := '0';

	SIGNAL rx_data_1_2_we_sig_CPU	:   STD_LOGIC := '0';
	SIGNAL rx_data_3_4_we_sig_CPU	:   STD_LOGIC := '0';
	SIGNAL rx_data_5_6_we_sig_CPU	:   STD_LOGIC := '0';
	SIGNAL rx_data_7_8_we_sig_CPU	:   STD_LOGIC := '0';
  
  
  
  component SWITCH_CTRL_CPU 	IS 
	PORT (	
	  we_ctrl : IN STD_LOGIC ;
		we_cpu	: IN STD_LOGIC ;

		cpu_data_in	:	IN STD_LOGIC_VECTOR ;
		ctrl_data_in:	IN STD_LOGIC_VECTOR (15 DOWNTO 0) ;

		data_out	:	OUT STD_LOGIC_VECTOR (15 DOWNTO 0) ;
		we_OUT		: 	out STD_LOGIC 

		) ;
END component;
  
  
  component Can_interface is
     PORT (
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

     -- OTHERS--
      
      RxCan            : IN std_logic;   
      TxCan            : out std_logic;
      time_reg         : in std_logic_vector(15 downto 0 ); 
      Clk              : in std_logic;
      Reset            : in std_logic); 
  end component;
  
  component CPU_INTERFACE is
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
		time_reg_we	:	OUT STD_LOGIC);
end component;
  
  
  component CAN_CONTROL is
	   PORT (
		  time_reg_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		  time_reg_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		  time_reg_we	:	IN STD_LOGIC ;
      clk			:	IN STD_LOGIC ;
		  RST 		:	IN STD_LOGIC 
		);
end component;
  
    
  component CAN_MESSAGE is
	   PORT (
		rx_data_id1_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_id2_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_conf_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;	

		rx_data_1_2_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_3_4_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_5_6_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_7_8_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_id1_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_id2_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_conf_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		rx_data_1_2_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_3_4_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_5_6_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		rx_data_7_8_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_id1_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_id2_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_conf_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_1_2_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_3_4_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_5_6_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_7_8_in	:	IN 	STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;


		tx_data_id1_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_id2_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_conf_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_1_2_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_3_4_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_5_6_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;
		tx_data_7_8_out:	OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) ;

		tx_data_id1_we	:	IN STD_LOGIC;
		tx_data_id2_we	:	IN STD_LOGIC;

		tx_data_conf_we	:	IN STD_LOGIC;

		tx_data_1_2_we	:	IN STD_LOGIC;
		tx_data_3_4_we	:	IN STD_LOGIC;
		tx_data_5_6_we	:	IN STD_LOGIC;
		tx_data_7_8_we	:	IN STD_LOGIC;

		rx_data_id1_we	:	IN STD_LOGIC;
		rx_data_id2_we	:	IN STD_LOGIC;

		rx_data_conf_we	:	IN STD_LOGIC;

		rx_data_1_2_we	:	IN STD_LOGIC;
		rx_data_3_4_we	:	IN STD_LOGIC;
		rx_data_5_6_we	:	IN STD_LOGIC;
		rx_data_7_8_we	:	IN STD_LOGIC;
		
		tx_data_id1_we_async:	IN STD_LOGIC;
		tx_data_id2_we_async:	IN STD_LOGIC;

		tx_data_conf_we_async:	IN STD_LOGIC;

		tx_data_1_2_we_async:	IN STD_LOGIC;
		tx_data_3_4_we_async:	IN STD_LOGIC;
		tx_data_5_6_we_async:	IN STD_LOGIC;
		tx_data_7_8_we_async:	IN STD_LOGIC;

		rx_data_id1_we_async:	IN STD_LOGIC;
		rx_data_id2_we_async:	IN STD_LOGIC;

		rx_data_conf_we_async:	IN STD_LOGIC;

		rx_data_1_2_we_async:	IN STD_LOGIC;
		rx_data_3_4_we_async:	IN STD_LOGIC;
		rx_data_5_6_we_async:	IN STD_LOGIC;
		rx_data_7_8_we_async:	IN STD_LOGIC;

		clk 			:	IN STD_LOGIC;
		reset 			: 	IN STD_LOGIC
		);
 end component;

  Begin 
    
CAN_Msg :  CAN_MESSAGE PORT MAP (
		rx_data_id1_in	=> rx_data_id1_in_sig,
		rx_data_id2_in	=> rx_data_id2_in_sig,

		rx_data_conf_in	=> rx_data_conf_in_sig,	

		rx_data_1_2_in	=> rx_data_1_2_in_sig,
		rx_data_3_4_in	=> rx_data_3_4_in_sig,
		rx_data_5_6_in	=> rx_data_5_6_in_sig,
		rx_data_7_8_in	=> rx_data_7_8_in_sig,

		rx_data_id1_out => rx_data_id1_out_sig,
		rx_data_id2_out => rx_data_id2_out_sig,

		rx_data_conf_out => rx_data_conf_out_sig,

		rx_data_1_2_out => rx_data_1_2_out_sig,
		rx_data_3_4_out => rx_data_3_4_out_sig,
		rx_data_5_6_out => rx_data_5_6_out_sig,
		rx_data_7_8_out => rx_data_7_8_out_sig,

		tx_data_id1_in	=> tx_data_id1_in_sig,
		tx_data_id2_in	=> tx_data_id2_in_sig,

		tx_data_conf_in	=> tx_data_conf_in_sig,

		tx_data_1_2_in	=> tx_data_1_2_in_sig,
		tx_data_3_4_in	=> tx_data_3_4_in_sig,
		tx_data_5_6_in	=> tx_data_5_6_in_sig,
		tx_data_7_8_in	=> tx_data_7_8_in_sig,


		tx_data_id1_out => tx_data_id1_out_sig,
		tx_data_id2_out => tx_data_id2_out_sig,

		tx_data_conf_out => tx_data_conf_out_sig,

		tx_data_1_2_out => tx_data_1_2_out_sig,
		tx_data_3_4_out => tx_data_3_4_out_sig,
		tx_data_5_6_out => tx_data_5_6_out_sig,
		tx_data_7_8_out => tx_data_7_8_out_sig,		
		
		tx_data_id1_we	 => tx_data_id1_we_sig,
		tx_data_id2_we	 => tx_data_id2_we_sig,

		tx_data_conf_we	 => tx_data_conf_we_sig,

		tx_data_1_2_we	 => tx_data_1_2_we_sig,
		tx_data_3_4_we	 => tx_data_3_4_we_sig,
		tx_data_5_6_we	 => tx_data_5_6_we_sig,
		tx_data_7_8_we	 => tx_data_7_8_we_sig,

		rx_data_id1_we	 => rx_data_id1_we_sig,
		rx_data_id2_we	 => rx_data_id2_we_sig,

		rx_data_conf_we	 => rx_data_conf_we_sig,

		rx_data_1_2_we	 => rx_data_1_2_we_sig,
		rx_data_3_4_we	 => rx_data_3_4_we_sig,
		rx_data_5_6_we	 => rx_data_5_6_we_sig,
		rx_data_7_8_we	 => rx_data_7_8_we_sig,
		
		tx_data_id1_we_async	 => tx_data_id1_we_sig_CAN,
		tx_data_id2_we_async	 => tx_data_id2_we_sig_CAN,

		tx_data_conf_we_async	 => tx_data_conf_we_sig_CAN,

		tx_data_1_2_we_async	 => tx_data_1_2_we_sig_CAN,
		tx_data_3_4_we_async	 => tx_data_3_4_we_sig_CAN,
		tx_data_5_6_we_async	 => tx_data_5_6_we_sig_CAN,
		tx_data_7_8_we_async	 => tx_data_7_8_we_sig_CAN,

		rx_data_id1_we_async	 => rx_data_id1_we_sig_CAN,
		rx_data_id2_we_async	 => rx_data_id2_we_sig_CAN,

		rx_data_conf_we_async	 => rx_data_conf_we_sig_CAN,

		rx_data_1_2_we_async	 => rx_data_1_2_we_sig_CAN,
		rx_data_3_4_we_async	 => rx_data_3_4_we_sig_CAN,
		rx_data_5_6_we_async	 => rx_data_5_6_we_sig_CAN,
		rx_data_7_8_we_async	 => rx_data_7_8_we_sig_CAN,
		
		clk 			 => clk,
		reset 	 => rst
		);
  
    
Can_int :  Can_interface PORT MAP (
      RxCan           	 => RxCan,
      TxCan             => TxCan,
      time_reg          => time_reg_out_sig,
      
      --input from reg  to read --
      
  		rx_data_id1_out => rx_data_id1_out_sig,
		rx_data_id2_out => rx_data_id2_out_sig,

		rx_data_conf_out => rx_data_conf_out_sig,

		rx_data_1_2_out => rx_data_1_2_out_sig,
		rx_data_3_4_out => rx_data_3_4_out_sig,
		rx_data_5_6_out => rx_data_5_6_out_sig,
		rx_data_7_8_out => rx_data_7_8_out_sig,  
      
		tx_data_id1_out => tx_data_id1_out_sig,
		tx_data_id2_out => tx_data_id2_out_sig,

		tx_data_conf_out => tx_data_conf_out_sig,

		tx_data_1_2_out => tx_data_1_2_out_sig,
		tx_data_3_4_out => tx_data_3_4_out_sig,
		tx_data_5_6_out => tx_data_5_6_out_sig,
		tx_data_7_8_out => tx_data_7_8_out_sig,	
		
		--output from reg  to read --
    
  		rx_data_id1_in	=> rx_data_id1_in_sig_CAN,
		--rx_data_id2_in	=> rx_data_id2_in_sig_CAN,

		rx_data_conf_in	=> rx_data_conf_in_sig_CAN,	

		rx_data_1_2_in	=> rx_data_1_2_in_sig_CAN,
		rx_data_3_4_in	=> rx_data_3_4_in_sig_CAN,
		rx_data_5_6_in	=> rx_data_5_6_in_sig_CAN,
		rx_data_7_8_in	=> rx_data_7_8_in_sig_CAN,
      
    tx_data_id1_in	=> tx_data_id1_in_sig_CAN,
		tx_data_id2_in	=> tx_data_id2_in_sig_CAN,

		tx_data_conf_in	=> tx_data_conf_in_sig_CAN,

		tx_data_1_2_in	=> tx_data_1_2_in_sig_CAN,
		tx_data_3_4_in	=> tx_data_3_4_in_sig_CAN,
		tx_data_5_6_in	=> tx_data_5_6_in_sig_CAN,
		tx_data_7_8_in	=> tx_data_7_8_in_sig_CAN,
		
		
		tx_data_id1_we	 => tx_data_id1_we_sig_CAN,
		tx_data_id2_we	 => tx_data_id2_we_sig_CAN,

		tx_data_conf_we	 => tx_data_conf_we_sig_CAN,

		tx_data_1_2_we	 => tx_data_1_2_we_sig_CAN,
		tx_data_3_4_we	 => tx_data_3_4_we_sig_CAN,
		tx_data_5_6_we	 => tx_data_5_6_we_sig_CAN,
		tx_data_7_8_we	 => tx_data_7_8_we_sig_CAN,

		rx_data_id1_we	 => rx_data_id1_we_sig_CAN,
		rx_data_id2_we	 => rx_data_id2_we_sig_CAN,

		rx_data_conf_we	 => rx_data_conf_we_sig_CAN,

		rx_data_1_2_we	 => rx_data_1_2_we_sig_CAN,
		rx_data_3_4_we	 => rx_data_3_4_we_sig_CAN,
		rx_data_5_6_we	 => rx_data_5_6_we_sig_CAN,
		rx_data_7_8_we	 => rx_data_7_8_we_sig_CAN,
   
      Clk               => clk,
      Reset             => rst
      ); 



CPU_INT : CPU_INTERFACE PORT MAP (  
			-- Avalon bus in/out -- 

		clock_avalon => clk,
		rst_avalon => rst,
		read => read,
		write => write,
		address => address,
		writedata => writedata,
		readdata => readdata,

     
      --input from reg to read --
      
  		rx_data_id1_out => rx_data_id1_out_sig,
		rx_data_id2_out => rx_data_id2_out_sig,

		rx_data_conf_out => rx_data_conf_out_sig,

		rx_data_1_2_out => rx_data_1_2_out_sig,
		rx_data_3_4_out => rx_data_3_4_out_sig,
		rx_data_5_6_out => rx_data_5_6_out_sig,
		rx_data_7_8_out => rx_data_7_8_out_sig,  
      
		tx_data_id1_out => tx_data_id1_out_sig,
		tx_data_id2_out => tx_data_id2_out_sig,

		tx_data_conf_out => tx_data_conf_out_sig,

		tx_data_1_2_out => tx_data_1_2_out_sig,
		tx_data_3_4_out => tx_data_3_4_out_sig,
		tx_data_5_6_out => tx_data_5_6_out_sig,
		tx_data_7_8_out => tx_data_7_8_out_sig,	
		
		--output to reg to write --
    
  		rx_data_id1_in	=> rx_data_id1_in_sig_CPU,
		rx_data_id2_in	=> rx_data_id2_in_sig_CPU,

		rx_data_conf_in	=> rx_data_conf_in_sig_CPU,	

		rx_data_1_2_in	=> rx_data_1_2_in_sig_CPU,
		rx_data_3_4_in	=> rx_data_3_4_in_sig_CPU,
		rx_data_5_6_in	=> rx_data_5_6_in_sig_CPU,
		rx_data_7_8_in	=> rx_data_7_8_in_sig_CPU,
      
    tx_data_id1_in	=> tx_data_id1_in_sig_CPU,
		tx_data_id2_in	=> tx_data_id2_in_sig_CPU,

		tx_data_conf_in	=> tx_data_conf_in_sig_CPU,

		tx_data_1_2_in	=> tx_data_1_2_in_sig_CPU,
		tx_data_3_4_in	=> tx_data_3_4_in_sig_CPU,
		tx_data_5_6_in	=> tx_data_5_6_in_sig_CPU,
		tx_data_7_8_in	=> tx_data_7_8_in_sig_CPU,
		
		
		tx_data_id1_we	 => tx_data_id1_we_sig_CPU,
		tx_data_id2_we	 => tx_data_id2_we_sig_CPU,

		tx_data_conf_we	 => tx_data_conf_we_sig_CPU,

		tx_data_1_2_we	 => tx_data_1_2_we_sig_CPU,
		tx_data_3_4_we	 => tx_data_3_4_we_sig_CPU,
		tx_data_5_6_we	 => tx_data_5_6_we_sig_CPU,
		tx_data_7_8_we	 => tx_data_7_8_we_sig_CPU,

		rx_data_id1_we	 => rx_data_id1_we_sig_CPU,
		rx_data_id2_we	 => rx_data_id2_we_sig_CPU,

		rx_data_conf_we	 => rx_data_conf_we_sig_CPU,

		rx_data_1_2_we	 => rx_data_1_2_we_sig_CPU,
		rx_data_3_4_we	 => rx_data_3_4_we_sig_CPU,
		rx_data_5_6_we	 => rx_data_5_6_we_sig_CPU,
		rx_data_7_8_we	 => rx_data_7_8_we_sig_CPU,


			-- timing reg in/out -- 

		time_reg_in	=> time_reg_in_sig,
		time_reg_out => time_reg_out_sig,
		time_reg_we	=> time_reg_we_sig
		);

  
CAN_CONT : CAN_CONTROL PORT MAP (   

			-- timing reg in/out -- 

		time_reg_in	=> time_reg_in_sig,
		time_reg_out => time_reg_out_sig,
		time_reg_we	=> time_reg_we_sig,


      clk				=> clk,
		  RST 			=> rst
		);







sw0: SWITCH_CTRL_CPU  PORT map(
  
 	 	we_ctrl => rx_data_id1_we_sig_CAN,
		we_cpu	=> rx_data_id1_we_sig_CPU,

		cpu_data_in	=> rx_data_id1_in_sig_CPU,
		ctrl_data_in => rx_data_id1_in_sig_CAN,

		data_out	=> rx_data_id1_in_sig,
		we_OUT		=> rx_data_id1_we_sig

		) ;
 

sw1: SWITCH_CTRL_CPU  PORT map(
  
 	 	we_ctrl => rx_data_id2_we_sig_CAN,
		we_cpu	=> rx_data_id2_we_sig_CPU,

		cpu_data_in	=> rx_data_id2_in_sig_CPU,
		ctrl_data_in => rx_data_id2_in_sig_CAN,

		data_out	=> rx_data_id2_in_sig,
		we_OUT		=> rx_data_id2_we_sig

		) ;
 

sw2: SWITCH_CTRL_CPU  PORT map(
  
  	 	we_ctrl => rx_data_conf_we_sig_CAN,
		we_cpu	=> rx_data_conf_we_sig_CPU,

		cpu_data_in	=> rx_data_conf_in_sig_CPU,
		ctrl_data_in => rx_data_conf_in_sig_CAN,

		data_out	=> rx_data_conf_in_sig,
		we_OUT		=> rx_data_conf_we_sig

		) ;
 

sw3: SWITCH_CTRL_CPU  PORT map(
  
  	 	we_ctrl => rx_data_1_2_we_sig_CAN,
		we_cpu	=> rx_data_1_2_we_sig_CPU,

		cpu_data_in	=> rx_data_1_2_in_sig_CPU,
		ctrl_data_in => rx_data_1_2_in_sig_CAN,

		data_out	=> rx_data_1_2_in_sig,
		we_OUT		=> rx_data_1_2_we_sig

		) ;
 

sw4: SWITCH_CTRL_CPU  PORT map(
  
  	 	we_ctrl => rx_data_3_4_we_sig_CAN,
		we_cpu	=> rx_data_3_4_we_sig_CPU,

		cpu_data_in	=> rx_data_3_4_in_sig_CPU,
		ctrl_data_in => rx_data_3_4_in_sig_CAN,

		data_out	=> rx_data_3_4_in_sig,
		we_OUT		=> rx_data_3_4_we_sig

		) ;
 

sw5: SWITCH_CTRL_CPU  PORT map(
  
  	 	we_ctrl => rx_data_5_6_we_sig_CAN,
		we_cpu	=> rx_data_5_6_we_sig_CPU,

		cpu_data_in	=> rx_data_5_6_in_sig_CPU,
		ctrl_data_in => rx_data_5_6_in_sig_CAN,

		data_out	=> rx_data_5_6_in_sig,
		we_OUT		=> rx_data_5_6_we_sig

		) ;
 

sw6: SWITCH_CTRL_CPU  PORT map(
  
  	 	we_ctrl => rx_data_7_8_we_sig_CAN,
		we_cpu	=> rx_data_7_8_we_sig_CPU,

		cpu_data_in	=> rx_data_7_8_in_sig_CPU,
		ctrl_data_in => rx_data_7_8_in_sig_CAN,

		data_out	=> rx_data_7_8_in_sig,
		we_OUT		=> rx_data_7_8_we_sig

		) ;
 



sw7: SWITCH_CTRL_CPU  PORT map(
  
 	 	we_ctrl => tx_data_id1_we_sig_CAN,
		we_cpu	=> tx_data_id1_we_sig_CPU,

		cpu_data_in	=> tx_data_id1_in_sig_CPU,
		ctrl_data_in => tx_data_id1_in_sig_CAN,

		data_out	=> tx_data_id1_in_sig,
		we_OUT		=> tx_data_id1_we_sig

		) ;
 

sw8: SWITCH_CTRL_CPU  PORT map(
  
  	 	we_ctrl => tx_data_id2_we_sig_CAN,
		we_cpu	=> tx_data_id2_we_sig_CPU,

		cpu_data_in	=> tx_data_id2_in_sig_CPU,
		ctrl_data_in => tx_data_id2_in_sig_CAN,

		data_out	=> tx_data_id2_in_sig,
		we_OUT		=> tx_data_id2_we_sig

		) ;
 

sw9: SWITCH_CTRL_CPU  PORT map(
  
  	 	we_ctrl => tx_data_conf_we_sig_CAN,
		we_cpu	=> tx_data_conf_we_sig_CPU,

		cpu_data_in	=> tx_data_conf_in_sig_CPU,
		ctrl_data_in => tx_data_conf_in_sig_CAN,

		data_out	=> tx_data_conf_in_sig,
		we_OUT		=> tx_data_conf_we_sig

		) ;
 

sw10: SWITCH_CTRL_CPU  PORT map(
  
 	 	we_ctrl => tx_data_1_2_we_sig_CAN,
		we_cpu	=> tx_data_1_2_we_sig_CPU,

		cpu_data_in	=> tx_data_1_2_in_sig_CPU,
		ctrl_data_in => tx_data_1_2_in_sig_CAN,

		data_out	=> tx_data_1_2_in_sig,
		we_OUT		=> tx_data_1_2_we_sig

		) ;
 

sw11: SWITCH_CTRL_CPU  PORT map(
  
  	 	we_ctrl => tx_data_3_4_we_sig_CAN,
		we_cpu	=> tx_data_3_4_we_sig_CPU,

		cpu_data_in	=> tx_data_3_4_in_sig_CPU,
		ctrl_data_in => tx_data_3_4_in_sig_CAN,

		data_out	=> tx_data_3_4_in_sig,
		we_OUT		=> tx_data_3_4_we_sig

		) ;
 

sw12: SWITCH_CTRL_CPU  PORT map(
  
  	 	we_ctrl => tx_data_5_6_we_sig_CAN,
		we_cpu	=> tx_data_5_6_we_sig_CPU,

		cpu_data_in	=> tx_data_5_6_in_sig_CPU,
		ctrl_data_in => tx_data_5_6_in_sig_CAN,

		data_out	=> tx_data_5_6_in_sig,
		we_OUT		=> tx_data_5_6_we_sig

		) ;
 

sw13: SWITCH_CTRL_CPU  PORT map(
  
  	 	we_ctrl => tx_data_7_8_we_sig_CAN,
		we_cpu	=> tx_data_7_8_we_sig_CPU,

		cpu_data_in	=> tx_data_7_8_in_sig_CPU,
		ctrl_data_in => tx_data_7_8_in_sig_CAN,

		data_out	=> tx_data_7_8_in_sig,
		we_OUT		=> tx_data_7_8_we_sig

		) ;
 


    
  END ARCHITECTURE RTL;



