
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_core IS
   PORT (
 
 
-- Write signal to registers --
    
    -- TX CONTROL
    
  TXCTRL_out   : out std_logic_vector(7 downto 0 );
  
    -- RX CONTROL
  RXCTRL_out   : out std_logic_vector(7 downto 0 );
  RXSID_out    : out std_logic_vector(10 downto 0 );
  RXDLC_out    : out std_logic_vector(7 downto 0 );
  RXDatah_out   : out std_logic_vector(31 downto 0 );
  RXDatal_out   : out std_logic_vector(31 downto 0 );
    
    -- CAN STATUT 
  CANSTAT_out  : out std_logic_vector(7 downto 0 );

    -- Errors Counter 
  TEC_out : out std_logic_vector(7 downto 0 );
  REC_out : out std_logic_vector(7 downto 0 );
  
  
  
  
  -- Read signal from registers --
   
  TXCTRL_in   : in std_logic_vector(7 downto 0 );
  TXSID_in    : in std_logic_vector(10 downto 0 );
  TXDLC_in    : in std_logic_vector(7 downto 0 );
  TXDatah_in   : in std_logic_vector(31 downto 0 );
  TXDatal_in   : in std_logic_vector(31 downto 0 );
  
  RXCTRL_in  : in std_logic_vector(7 downto 0 );
  
  RXFSID_in  : in std_logic_vector(7 downto 0 );
  RXMSID_in   : in std_logic_vector(7 downto 0 );

  CANCTRL_in  : in std_logic_vector(7 downto 0 );
  CANSTAT_in  : in std_logic_vector(7 downto 0 );
  
  BTC_in : in std_logic_vector(15 downto 0 );
  
  TEC_in : in std_logic_vector(7 downto 0 );
  REC_in : in std_logic_vector(7 downto 0 );
  
  
  -- output FOR Write Enable  --
  
  TXCTRL_we   : out std_logic;
  
  RXCTRL_we    : out std_logic;
  RXSID_we     : out std_logic;
  RXDLC_we     : out std_logic;
  RXDatah_we   : out std_logic;
  RXDatal_we   : out std_logic;
  
  
  CANSTAT_we   : out std_logic;
  
  
  TEC_we : out std_logic;
  REC_we : out std_logic;
  
  -- INPUT FOR CLK & Rst --
  
  clk : in std_logic ;
  RST : IN STD_LOGIC;
  
  RxCAN : IN STD_LOGIC;
  TxCAN : out STD_LOGIC);
  
  
END ENTITY can_core;


ARCHITECTURE RTL OF can_core IS


function Compare(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end;

      
   --CLK_Q--   
   SIGNAL clk_en                   :  std_logic;   
   SIGNAL clk_en_q                 :  std_logic;   
   
   --MAB--
   Constant size_79 : integer:=79; 
   SIGNAL MAB_in                   :  std_logic_vector(78 DOWNTO 0);   
   SIGNAL MAB_out                  :  std_logic_vector(78 DOWNTO 0); 
   SIGNAL MAB_we                   :  std_logic;
    
  
  COMPONENT can_baudrate_prescaler IS
   PORT (
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      baud_r_presc            : IN std_logic_vector(5 DOWNTO 0);   
      clk_e                   : OUT std_logic;     
      clk_eQ                  : OUT std_logic);   
  END COMPONENT;
  
component can_register is
   GENERIC (
      WIDTH                          :  integer := 8);    --  default parameter of the register width
   PORT (
      data_in                 : IN std_logic_vector(WIDTH - 1 DOWNTO 0);   
      data_out                : OUT std_logic_vector(WIDTH - 1 DOWNTO 0);   
      we                      : IN std_logic;  
      clk                     : IN std_logic;
      rst_async               : IN std_logic);
         
end component; 

component CAN_SiPo_Reg is  
  port(
  clk : in STD_LOGIC;
  reset : in  std_logic;
  load : in STD_LOGIC;
  din : in std_logic; 
  dout : out std_logic_vector(7 downto 0)); 
end component;

component can_acceptance_filter IS
   PORT (
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      id                      : IN std_logic_vector(10 DOWNTO 0);
      acceptance_code_0       : IN std_logic_vector(7 DOWNTO 0);   
      acceptance_mask_0       : IN std_logic_vector(7 DOWNTO 0);   
      rx_Buffer_full          : IN std_logic;   
      rx_id_lim               : IN std_logic;
      id_ok                   : OUT std_logic);   
END component;

component CAN_PiSo_Reg is
  port(
  clk : in STD_LOGIC;
  reset : in STD_LOGIC;
  load : in STD_LOGIC;
  din : in STD_LOGIC_VECTOR(7 downto 0);
  dout : out STD_LOGIC
);
end component;

component can_crc_comparator IS
  
     PORT (
      crc_valid                    : IN std_logic_vector(15 downto 0);   
      crc_rx                       : IN std_logic_vector(15 downto 0);
      crc_ok                       : out std_logic);
         
      
END component ;

component can_crcgen IS
   PORT (
      clk                     : IN std_logic;   
      data                    : IN std_logic;   
      enable                  : IN std_logic;   
      initialize              : IN std_logic;   
      crc                     : OUT std_logic_vector(14 DOWNTO 0));   
END component ;

   --Acceptance Signals--   
   SIGNAL MAB_in                :  std_logic;   
   SIGNAL MAB_out               :  std_logic;   
   SIGNAL MAB_we                :  std_logic;
   SIGNAL MAB_RST               :  std_logic;
   
   --Acceptance Signals--   
   SIGNAL id_ok                 :  std_logic;   
   SIGNAL rx_id_lim             :  std_logic;   
   SIGNAL id_rcv                :  std_logic;
   
   --CRC Signals--  
   SIGNAL crc_out               :  std_logic_vector(14 DOWNTO 0);      
   SIGNAL crc_in                :  std_logic;    
   SIGNAL crc_enable            :  std_logic;    
   SIGNAL crc_init              :  std_logic;
   
   SIGNAL     crc_valid                    : std_logic_vector(15 downto 0);   
   SIGNAL     crc_rx                       : std_logic_vector(15 downto 0);
   SIGNAL     crc_ok                       : std_logic;
         
  -- FSM --
type TX_State is (
TX_IDLE,
TX_CLEAR,
TX_TRANS,
TX_ERROR,
TX_WAIT_ACK);

type RX_State is (
RX_IDLE,
RX_RECV,
RX_VALID,
RX_ERROR_SEND,
TX_BUFFER_INSERT);

type RXing_State is (
RX_SOF,RX_ARBIT,RX_CMD,RX_DATA,RX_CRC,RX_CRC_DELIM,RX_ACK,RX_END,RX_INTER);

type TXing_State is (
TX_SOF,TX_ARBIT,TX_CMD,TX_DATA,TX_CRC,TX_CRC_DELIM,TX_ACK,TX_END,TX_INTER);
  
signal TXstate, TXnextstate : TX_State; 

signal TXingstate, TXingnextstate : TXing_State;

signal RXstate, RXnextstate : RX_State;

signal RXingstate, RXingnextstate : RXing_State;



BEGIN 
  
  CAN_MAB : can_register
  generic map(WIDTH => size_79 ) 
  port map(
  data_in=>MAB_in,
  data_out=>MAB_out,
  we =>MAB_we,
  clk=> clk,
  rst_async=> MAB_RST);
  
  CAN_BPRSC : can_baudrate_prescaler 
  port map( 
  clk=>clk,
  rst=>rst,
  baud_r_presc =>BTC_in(13 DOWNTO 8),
  clk_e=> clk_en,
  clk_eQ=> clk_en_q);
  
  CAN_acceptance_filter : can_acceptance_filter 
  port map(
  clk=>clk,
  rst=>RST,
  id =>id_rcv,
  acceptance_code_0=> RXFSID_in ,
  acceptance_mask_0 => RXMSID_in,
  rx_id_lim=> rx_id_lim,
  id_ok => id_ok,
  rx_Buffer_full=> RXCTRL_in(6));
  
  CAN_crcgen : can_crcgen
  port map(
  clk=>clk,
  data => crc_in,
  enable=> crc_enable,
  intialise=>crc_init,
  crc => crc_out);

  CAN_comp : can_crc_comparator
  port map(
      crc_valid=>crc_valid,                 
      crc_rx=>crc_rx,                       
    crc_ok=>crc_ok);                      
    
    
    
    
    
  
     
  END ARCHITECTURE RTL;    
    




