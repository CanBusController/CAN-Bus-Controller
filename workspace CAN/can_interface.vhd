
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_interface IS
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
    Reset            : in std_logic);
 
END ENTITY can_interface;



ARCHITECTURE RTL OF can_interface IS
  signal bus_drive :std_logic;
  
  
component BSP_INTERFACE is
  PORT (
      -- Avalon bus in/out -- 
		clk: IN STD_LOGIC;
		read, write : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		writedata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		readdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);


			-- message reg in/out -- 

		rx_data_id1_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_id2_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		rx_data_conf_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;	

		rx_data_1_2_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_3_4_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_5_6_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_7_8_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		rx_data_id1_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_id2_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		rx_data_conf_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		rx_data_1_2_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_3_4_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_5_6_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		rx_data_7_8_out: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		tx_data_id1_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;
		tx_data_id2_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

		tx_data_conf_in	: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 ) ;

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
		rx_data_7_8_we	: OUT STD_LOGIC
  );
END component;
  
component can_baudrate_prescaler is
   PORT (
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      baud_r_presc            : IN std_logic_vector(5 DOWNTO 0);    
      clk_eQ                  : OUT std_logic);   
end component; 

component can_bit_timing_logic is
   PORT (
      clk                         : IN std_logic; 
      TQ_clk                      : IN std_logic;
       -- IN CONTROLLER INTERFACE --   
      RESET                       : IN std_logic; 
       -- OUT/IN TRANCEIBVER CAN BUS -- 
      RxCan                       : IN std_logic;   
      TxCan                       : out std_logic;
      -- Bit Timing Conf --
      time_reg                : IN std_logic_vector(15 DOWNTO 0);
      -- OUT/IN BSM -- 
      rx_idle                 : OUT std_logic;
      sample_point            : OUT std_logic;     
      busmon                  : OUT std_logic;
      hard_sync_enable        : in std_logic;   
      bus_drive               : in std_logic);   
         
end component; 



function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end; 

    SIGNAL TQ_clk                            :  std_logic;
    SIGNAL sample_point                      :  std_logic;
    SIGNAL sampled_bit                       :  std_logic;
    SIGNAL rx_idle                           :  std_logic;
    SIGNAL hard_sync_enable                  :  std_logic;
    SIGNAL read                   :  std_logic := '0';
    SIGNAL write                  :  std_logic := '0';
    SIGNAL address                :  STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL writedata              :  STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL readdata               :  STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN


  BSP_INT   : BSP_INTERFACE  port map(
      -- Avalon bus in/out -- 

    clk => clk,
    read => read,
    write => write,
    address => address,
    writedata => writedata,
    readdata => readdata,


      -- message reg in/out -- 

    rx_data_id1_in   => rx_data_id1_in,
    rx_data_id2_in   => rx_data_id2_in,

    rx_data_conf_in  => rx_data_conf_in,

    rx_data_1_2_in   => rx_data_1_2_in,
    rx_data_3_4_in   => rx_data_3_4_in,
    rx_data_5_6_in   => rx_data_5_6_in,
    rx_data_7_8_in   => rx_data_7_8_in,

    rx_data_id1_out  => rx_data_id1_out,
    rx_data_id2_out  => rx_data_id2_out,

    rx_data_conf_out  => rx_data_conf_out,

    rx_data_1_2_out  => rx_data_1_2_out,
    rx_data_3_4_out  => rx_data_3_4_out,
    rx_data_5_6_out => rx_data_5_6_out,
    rx_data_7_8_out => rx_data_7_8_out,

    tx_data_id1_in   => tx_data_id1_in,
    tx_data_id2_in   => tx_data_id2_in,

    tx_data_conf_in  => tx_data_conf_in,

    tx_data_1_2_in   => tx_data_1_2_in,
    tx_data_3_4_in   => tx_data_3_4_in,
    tx_data_5_6_in   => tx_data_5_6_in,
    tx_data_7_8_in   => tx_data_7_8_in,


    tx_data_id1_out  => tx_data_id1_out,
    tx_data_id2_out  => tx_data_id2_out,

    tx_data_conf_out => tx_data_conf_out,

    tx_data_1_2_out => tx_data_1_2_out,
    tx_data_3_4_out => tx_data_3_4_out,
    tx_data_5_6_out => tx_data_5_6_out,
    tx_data_7_8_out => tx_data_7_8_out,

    tx_data_id1_we  => tx_data_id1_we,
    tx_data_id2_we  => tx_data_id2_we,

    tx_data_conf_we => tx_data_conf_we,

    tx_data_1_2_we  => tx_data_1_2_we,
    tx_data_3_4_we  => tx_data_3_4_we,
    tx_data_5_6_we  => tx_data_5_6_we,
    tx_data_7_8_we  => tx_data_7_8_we,

    rx_data_id1_we  => rx_data_id1_we,
    rx_data_id2_we  => rx_data_id2_we,

    rx_data_conf_we => rx_data_conf_we,

    rx_data_1_2_we  => rx_data_1_2_we,
    rx_data_3_4_we  => rx_data_3_4_we,
    rx_data_5_6_we  => rx_data_5_6_we,
    rx_data_7_8_we  => rx_data_7_8_we
  );














  CAN_BRP   : can_baudrate_prescaler  port map(
      clk => Clk,   
      rst => Reset,   
      baud_r_presc => time_reg (13 downto 8), 
      clk_eQ => TQ_clk );

  CAN_BTL    : can_bit_timing_logic  port map(
      clk => Clk , 
      TQ_clk => TQ_clk, 
      RESET => Reset,
      rx_idle => rx_idle, 
      RxCan => RxCan,  
      TxCan => TxCan,
      time_reg => time_reg,
      sample_point => sample_point,    
      busmon => sampled_bit, 
      hard_sync_enable => hard_sync_enable,
      bus_drive => bus_drive);   


END ARCHITECTURE RTL;
