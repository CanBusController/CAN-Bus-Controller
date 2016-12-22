
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY CAN_Controller IS
   PORT (
      clk, rest : IN STD_LOGIC;
      read, write : IN STD_LOGIC;
      chipselect : IN STD_LOGIC;
      writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      Tx : IN STD_LOGIC;
      Rx : out STD_LOGIC );
      
END ENTITY CAN_Controller;

ARCHITECTURE RTL OF CAN_Controller IS
  
  component Can_interface is 
    
    
  end component;
  
    component can_registers is 
      PORT ( 
  
    -- OUTPUT FOR WRITE -- 
    
  TXCTRL_out   : out std_logic_vector(7 downto 0 );
  TXSID_out    : out std_logic_vector(10 downto 0 );
  TXDLC_out    : out std_logic_vector(7 downto 0 );
  TXDatah_out   : out std_logic_vector(31 downto 0 );
  TXDatal_out   : out std_logic_vector(31 downto 0 );
  
  
  RXCTRL_out  : out std_logic_vector(7 downto 0 );
  RXFSID_out  : out std_logic_vector(7 downto 0 );
  RXMSID_out   : out std_logic_vector(7 downto 0 );
  RXSID_out    : out std_logic_vector(10 downto 0 );
  RXDLC_out    : out std_logic_vector(7 downto 0 );
  RXDatah_out   : out std_logic_vector(31 downto 0 );
  RXDatal_out   : out std_logic_vector(31 downto 0 );
  
  
  CANCTRL_out  : out std_logic_vector(7 downto 0 );
  CANSTAT_out  : out std_logic_vector(7 downto 0 );
  
  BTC_out : out std_logic_vector(15 downto 0 );
  
  TEC_out : out std_logic_vector(7 downto 0 );
  REC_out : out std_logic_vector(7 downto 0 );
  
  -- INPUT FOR WRITE --
   
  TXCTRL_in   : in std_logic_vector(7 downto 0 );
  TXSID_in    : in std_logic_vector(10 downto 0 );
  TXDLC_in    : in std_logic_vector(7 downto 0 );
  TXDatah_in   : in std_logic_vector(31 downto 0 );
  TXDatal_in   : in std_logic_vector(31 downto 0 );
  
  RXCTRL_in  : in std_logic_vector(7 downto 0 );
  RXFSID_in  : in std_logic_vector(7 downto 0 );
  RXMSID_in   : in std_logic_vector(7 downto 0 );
  RXSID_in    : in std_logic_vector(10 downto 0 );
  RXDLC_in    : in std_logic_vector(7 downto 0 );
  RXDatah_in   : in std_logic_vector(31 downto 0 );
  RXDatal_in   : in std_logic_vector(31 downto 0 );
  
  
  CANCTRL_in  : in std_logic_vector(7 downto 0 );
  CANSTAT_in  : in std_logic_vector(7 downto 0 );
  
  BTC_in : in std_logic_vector(15 downto 0 );
  
  TEC_in : in std_logic_vector(7 downto 0 );
  REC_in : in std_logic_vector(7 downto 0 );
  
  
  -- INPUT FOR Write Enable  --
  
  TXCTRL_we   : in std_logic;
  TXSID_we    : in std_logic;
  TXDLC_we    : in std_logic;
  TXDatah_we   : in std_logic;
  TXDatal_we   : in std_logic;
  
  
  RXCTRL_we    : in std_logic;
  RXFSID_we    : in std_logic;
  RXMSID_we    : in std_logic;
  RXSID_we     : in std_logic;
  RXDLC_we     : in std_logic;
  RXDatah_we   : in std_logic;
  RXDatal_we   : in std_logic;
  
  CANCTRL_we   : in std_logic;
  CANSTAT_we   : in std_logic;
  
  BTC_we : in std_logic;
  
  TEC_we : in std_logic;
  REC_we : in std_logic;
  
  -- INPUT FOR CLK & Rst --
  
  clk : in std_logic ;
  RST : IN STD_LOGIC);
    
  end component;
  
  
  component can_core is 
    
    
    
  end component;



  begin 
    
    
    
  END ARCHITECTURE RTL;


