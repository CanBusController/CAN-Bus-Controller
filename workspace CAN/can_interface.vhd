
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_interface IS
   PORT (
      RxCan            : IN std_logic;   
      TxCan            : out std_logic;
      time_reg         : in std_logic_vector(15 downto 0 ); 
      Clk              : in std_logic;
      bus_drive_tx     : in std_logic;
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
    
BEGIN


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
      bus_drive => bus_drive_tx);   


END ARCHITECTURE RTL;
