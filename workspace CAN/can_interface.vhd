
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
      bit_err                 : out std_logic;    
      bus_drive               : in std_logic);   
         
end component; 

component can_bsp is
   PORT (
            clk :        in std_logic;
            rst :        in std_logic;
            process_bit: in std_logic;
            rcv_bit:     in std_logic;
            bit_err:     in std_logic;

            --tx
            tx_rqst:     in std_logic;
            tx_id:       in std_logic_vector(10 downto 0);
            tx_rtr:      in std_logic;
            tx_data:     in std_logic_vector(63 downto 0);
            tx_dlc:      in std_logic_vector(3 downto 0);
            tx_done:     out std_logic;

            --rx
            rx_id:       out std_logic_vector(10 downto 0);
            rx_data:     out std_logic_vector(63 downto 0);
            rx_dlc:      out std_logic_vector(3 downto 0);
            rx_rtr:      out std_logic;
            rx_valid:    out std_logic;

            hard_sync_en:out std_logic;
            bus_drive:   out std_logic

        );
end component; 

function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end; 

    SIGNAL  bus_drive   :std_logic;
    SIGNAL  bit_err     :std_logic;
    SIGNAL  tx_rqst     : std_logic;
    SIGNAL  tx_id       : std_logic_vector(10 downto 0);
    SIGNAL  tx_rtr      : std_logic;
    SIGNAL  tx_data     : std_logic_vector(63 downto 0);
    SIGNAL  tx_dlc      : std_logic_vector(3 downto 0);
    SIGNAL  tx_done     : std_logic;

            --rx
    SIGNAL  rx_id       : std_logic_vector(10 downto 0);
    SIGNAL  rx_data     : std_logic_vector(63 downto 0);
    SIGNAL  rx_dlc      : std_logic_vector(3 downto 0);
    SIGNAL  rx_rtr      : std_logic;
    SIGNAL  rx_valid    : std_logic;
    
    SIGNAL TQ_clk                 :  std_logic;
    SIGNAL sample_point           :  std_logic;
    SIGNAL sampled_bit            :  std_logic;
    SIGNAL rx_idle                :  std_logic;
    SIGNAL hard_sync_enable       :  std_logic;
    
    SIGNAL read                   :  std_logic := '0';
    SIGNAL write                  :  std_logic := '0';
    SIGNAL address                :  STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL writedata              :  STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL readdata               :  STD_LOGIC_VECTOR(15 DOWNTO 0);
    
BEGIN

tx_data_conf_in <=  tx_data_conf_out;
tx_data_1_2_in <= tx_data_1_2_out;
tx_data_3_4_in <= tx_data_3_4_out;
tx_data_5_6_in <= tx_data_5_6_out;
tx_data_7_8_in <= tx_data_7_8_out;
rx_data_id2_in <= rx_data_id2_out;
tx_data_id2_in <= tx_data_id2_out;

		tx_data_id2_we	<= '0';

		tx_data_conf_we	<= '0';

		tx_data_1_2_we	<= '0';
		tx_data_3_4_we	<= '0';
		tx_data_5_6_we	<= '0';
		tx_data_7_8_we	<= '0';
		
		rx_data_id2_we	<= '0';


tx_rqst <= tx_data_id1_out(14) or tx_data_id1_out(15) ;
tx_id <= tx_data_id1_out(10 downto 0 )  ;
tx_rtr <= tx_data_conf_out(14) ;
tx_data <= tx_data_7_8_out & tx_data_5_6_out & tx_data_3_4_out & tx_data_1_2_out;
tx_dlc <=  tx_data_conf_out(3 downto 0);

tx_data_id1_we <= '1' when tx_done='1' else '0';
tx_data_id1_in <= "000" & tx_data_id1_out(12 downto 0) when tx_done='1';
                
--    rx_data_id1_we	<= '1' when rx_valid='1' or bit_err='1' else '0' ;
--   rx_data_id1_in <= "10000" & rx_id(10 downto 0) when rx_valid='1' else
--                      "01000" & rx_data_id1_out(10 downto 0) when bit_err='1';


rx_data_id1_we	<= '1' when rx_valid='1' else '0' ;
rx_data_id1_in <= "10000" & rx_id(10 downto 0) when rx_valid='1';
                 
rx_data_1_2_we	<= '1' when rx_valid='1' else '0';
rx_data_1_2_in <= rx_data( 15 downto 0) when rx_valid='1';

rx_data_3_4_we	<= '1' when rx_valid='1' else '0';
rx_data_3_4_in <= rx_data( 31 downto 16) when rx_valid='1';

rx_data_5_6_we	<= '1' when rx_valid='1' else '0';
rx_data_5_6_in <= rx_data( 47 downto 32) when rx_valid='1';

rx_data_7_8_we	<= '1' when rx_valid='1' else '0';
rx_data_7_8_in <= rx_data( 63 downto 48) when rx_valid='1';
   
rx_data_conf_we	<= '1' when rx_valid='1' else '0';
rx_data_conf_in <= "0" & rx_rtr & "0000000000" & rx_dlc when rx_valid='1';

CAN_bit_stream_processor     : can_bsp  port map(
            clk  =>     Clk,
            rst  =>     Reset,
            process_bit => sample_point,
            rcv_bit =>     sampled_bit,
            bit_err =>    bit_err,

            --tx
            tx_rqst =>    tx_rqst,
            tx_id =>      tx_id,
            tx_rtr =>     tx_rtr,
            tx_data =>    tx_data,
            tx_dlc =>     tx_dlc,
            tx_done =>    tx_done,

            --rx
            rx_id =>      rx_id,
            rx_data =>    rx_data,
            rx_dlc =>     rx_dlc,
            rx_rtr =>     rx_rtr,
            rx_valid =>   rx_valid,

            hard_sync_en => hard_sync_enable,
            bus_drive =>  bus_drive);
            
            
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
      bit_err => bit_err,
      hard_sync_enable => hard_sync_enable,
      bus_drive => bus_drive
      );   




END ARCHITECTURE RTL;
