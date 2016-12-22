
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_vhdl_registers IS
   PORT (
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      cs                      : IN std_logic;   
      we                      : IN std_logic;   
      addr                    : IN std_logic_vector(7 DOWNTO 0);   
      data_in                 : IN std_logic_vector(7 DOWNTO 0);   
      data_out                : OUT std_logic_vector(7 DOWNTO 0);   
      irq_n                   : OUT std_logic;   
      sample_point            : IN std_logic;   
      transmitting            : IN std_logic;   
      set_reset_mode          : IN std_logic;   
      node_bus_off            : IN std_logic;   
      error_status            : IN std_logic;   
      rx_err_cnt              : IN std_logic_vector(7 DOWNTO 0);   
      tx_err_cnt              : IN std_logic_vector(7 DOWNTO 0);   
      transmit_status         : IN std_logic;   
      receive_status          : IN std_logic;   
      tx_successful           : IN std_logic;   
      need_to_tx              : IN std_logic;   
      overrun                 : IN std_logic;   
      info_empty              : IN std_logic;   
      set_bus_error_irq       : IN std_logic;   
      set_arbitration_lost_irq: IN std_logic;   
      arbitration_lost_capture: IN std_logic_vector(4 DOWNTO 0);   
      node_error_passive      : IN std_logic;   
      node_error_active       : IN std_logic;   
      rx_message_counter      : IN std_logic_vector(6 DOWNTO 0);   
      -- Mode register 
      reset_mode              : OUT std_logic;   
      listen_only_mode        : OUT std_logic;   
      acceptance_filter_mode  : OUT std_logic;   
      self_test_mode          : OUT std_logic;   
      -- Command register 
      clear_data_overrun      : OUT std_logic;   
      release_buffer          : OUT std_logic;   
      abort_tx                : OUT std_logic;   
      tx_request              : OUT std_logic;   
      self_rx_request         : OUT std_logic;   
      single_shot_transmission: OUT std_logic;   
      tx_state                : IN std_logic;   
      tx_state_q              : IN std_logic;   
      overload_request        : OUT std_logic;   
      overload_frame          : IN std_logic;   
      -- Arbitration Lost Capture Register 
      read_arbitration_lost_capture_reg: OUT std_logic;   
      -- Error Code Capture Register 
      read_error_code_capture_reg: OUT std_logic;   
      error_capture_code      : IN std_logic_vector(7 DOWNTO 0);   
      -- Bus Timing 0 register 
      baud_r_presc            : OUT std_logic_vector(5 DOWNTO 0);   
      sync_jump_width         : OUT std_logic_vector(1 DOWNTO 0);   
      -- Bus Timing 1 register 
      time_segment1           : OUT std_logic_vector(3 DOWNTO 0);   
      time_segment2           : OUT std_logic_vector(2 DOWNTO 0);   
      triple_sampling         : OUT std_logic;   
      -- Error Warning Limit register 
      error_warning_limit     : OUT std_logic_vector(7 DOWNTO 0);   
      -- Rx Error Counter register 
      we_rx_err_cnt           : OUT std_logic;   
      -- Tx Error Counter register 
      we_tx_err_cnt           : OUT std_logic;   
      -- Clock Divider register 
      extended_mode           : OUT std_logic;   
      clkout                  : OUT std_logic;   
      -- This section is for BASIC and EXTENDED mode -- Acceptance code register 
      acceptance_code_0       : OUT std_logic_vector(7 DOWNTO 0);   
      -- Acceptance mask register 
      acceptance_mask_0       : OUT std_logic_vector(7 DOWNTO 0);   
      -- End: This section is for BASIC and EXTENDED mode -- This section is for EXTENDED mode -- Acceptance code register 
      acceptance_code_1       : OUT std_logic_vector(7 DOWNTO 0);   
      acceptance_code_2       : OUT std_logic_vector(7 DOWNTO 0);   
      acceptance_code_3       : OUT std_logic_vector(7 DOWNTO 0);   
      -- Acceptance mask register 
      acceptance_mask_1       : OUT std_logic_vector(7 DOWNTO 0);   
      acceptance_mask_2       : OUT std_logic_vector(7 DOWNTO 0);   
      acceptance_mask_3       : OUT std_logic_vector(7 DOWNTO 0);   
      -- End: This section is for EXTENDED mode -- Tx data registers. Holding identifier (basic mode), tx frame information (extended mode) and data 
      tx_data_0               : OUT std_logic_vector(7 DOWNTO 0);   
      tx_data_1               : OUT std_logic_vector(7 DOWNTO 0);   
      tx_data_2               : OUT std_logic_vector(7 DOWNTO 0);   
      tx_data_3               : OUT std_logic_vector(7 DOWNTO 0);   
      tx_data_4               : OUT std_logic_vector(7 DOWNTO 0);   
      tx_data_5               : OUT std_logic_vector(7 DOWNTO 0);   
      tx_data_6               : OUT std_logic_vector(7 DOWNTO 0);   
      tx_data_7               : OUT std_logic_vector(7 DOWNTO 0);   
      tx_data_8               : OUT std_logic_vector(7 DOWNTO 0);   
      tx_data_9               : OUT std_logic_vector(7 DOWNTO 0);   
      tx_data_10              : OUT std_logic_vector(7 DOWNTO 0);   
      tx_data_11              : OUT std_logic_vector(7 DOWNTO 0);   
      tx_data_12              : OUT std_logic_vector(7 DOWNTO 0));   
END ENTITY can_vhdl_registers;

ARCHITECTURE RTL OF can_vhdl_registers IS

function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end;

function andv(d : std_logic_vector) return std_ulogic is
variable tmp : std_ulogic;
begin
  tmp := '1';
  for i in d'range loop tmp := tmp and d(i); end loop;
  return(tmp);
end;

function orv(d : std_logic_vector) return std_ulogic is
variable tmp : std_ulogic;
begin
  tmp := '0';
  for i in d'range loop tmp := tmp or d(i); end loop;
  return(tmp);
end;

   CONSTANT xhdl_timescale         : time := 1 ns;

   COMPONENT can_vhdl_register
      GENERIC (
          WIDTH                          :  integer := 8);    --  default parameter of the register width
      PORT (
         data_in                 : IN  std_logic_vector(WIDTH - 1 DOWNTO 0);
         data_out                : OUT std_logic_vector(WIDTH - 1 DOWNTO 0);
         we                      : IN  std_logic;
         clk                     : IN  std_logic);
   END COMPONENT;

   COMPONENT can_vhdl_register_asyn
      GENERIC (
          WIDTH                          :  integer := 8;    --  default parameter of the register width
          RESET_VALUE                    :  integer := 0);    
      PORT (
         data_in                 : IN  std_logic_vector(WIDTH - 1 DOWNTO 0);
         data_out                : OUT std_logic_vector(WIDTH - 1 DOWNTO 0);
         we                      : IN  std_logic;
         clk                     : IN  std_logic;
         rst                     : IN  std_logic);
   END COMPONENT;

   COMPONENT can_vhdl_register_asyn_syn
      GENERIC (
          WIDTH                          :  integer := 8;    --  default parameter of the register width
          RESET_VALUE                    :  integer := 0);    
      PORT (
         data_in                 : IN  std_logic_vector(WIDTH - 1 DOWNTO 0);
         data_out                : OUT std_logic_vector(WIDTH - 1 DOWNTO 0);
         we                      : IN  std_logic;
         clk                     : IN  std_logic;
         rst                     : IN  std_logic;
         rst_sync                : IN  std_logic);
   END COMPONENT;

   -- End: Tx data registers
   signal read_irq_reg_q           :  std_logic;
   signal reset_irq_reg            :  std_logic;
   SIGNAL tx_successful_q          :  std_logic;   
   SIGNAL overrun_q                :  std_logic;   
   SIGNAL overrun_status           :  std_logic;   
   SIGNAL transmission_complete    :  std_logic;   
   SIGNAL transmit_buffer_status_q :  std_logic;   
   SIGNAL receive_buffer_status    :  std_logic;   
   SIGNAL error_status_q           :  std_logic;   
   SIGNAL node_bus_off_q           :  std_logic;   
   SIGNAL node_error_passive_q     :  std_logic;   
   SIGNAL transmit_buffer_status   :  std_logic;   
   -- Some interrupts exist in basic mode and in extended mode. Since they are in different registers they need to be multiplexed.
   SIGNAL data_overrun_irq_en      :  std_logic;   
   SIGNAL error_warning_irq_en     :  std_logic;   
   SIGNAL transmit_irq_en          :  std_logic;   
   SIGNAL receive_irq_en           :  std_logic;   
   SIGNAL irq_reg                  :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL irq                      :  std_logic;   
   SIGNAL we_mode                  :  std_logic;   
   SIGNAL we_command               :  std_logic;   
   SIGNAL we_bus_timing_0          :  std_logic;   
   SIGNAL we_bus_timing_1          :  std_logic;   
   SIGNAL we_clock_divider_low     :  std_logic;   
   SIGNAL we_clock_divider_hi      :  std_logic;   
   SIGNAL read                     :  std_logic;   
   SIGNAL read_irq_reg             :  std_logic;   
   -- This section is for BASIC and EXTENDED mode 
   SIGNAL we_acceptance_code_0     :  std_logic;   
   SIGNAL we_acceptance_mask_0     :  std_logic;   
   SIGNAL we_tx_data_0             :  std_logic;   
   SIGNAL we_tx_data_1             :  std_logic;   
   SIGNAL we_tx_data_2             :  std_logic;   
   SIGNAL we_tx_data_3             :  std_logic;   
   SIGNAL we_tx_data_4             :  std_logic;   
   SIGNAL we_tx_data_5             :  std_logic;   
   SIGNAL we_tx_data_6             :  std_logic;   
   SIGNAL we_tx_data_7             :  std_logic;   
   SIGNAL we_tx_data_8             :  std_logic;   
   SIGNAL we_tx_data_9             :  std_logic;   
   SIGNAL we_tx_data_10            :  std_logic;   
   SIGNAL we_tx_data_11            :  std_logic;   
   SIGNAL we_tx_data_12            :  std_logic;   
   -- End: This section is for BASIC and EXTENDED mode 
   -- This section is for EXTENDED mode 
   SIGNAL we_interrupt_enable      :  std_logic;   
   SIGNAL we_error_warning_limit   :  std_logic;   
   SIGNAL we_acceptance_code_1     :  std_logic;   
   SIGNAL we_acceptance_code_2     :  std_logic;   
   SIGNAL we_acceptance_code_3     :  std_logic;   
   SIGNAL we_acceptance_mask_1     :  std_logic;   
   SIGNAL we_acceptance_mask_2     :  std_logic;   
   SIGNAL we_acceptance_mask_3     :  std_logic;   
   -- Mode register 
   SIGNAL mode                     :  std_logic;   
   SIGNAL mode_basic               :  std_logic_vector(4 DOWNTO 1);   
   SIGNAL mode_ext                 :  std_logic_vector(3 DOWNTO 1);   
   SIGNAL receive_irq_en_basic     :  std_logic;   
   SIGNAL transmit_irq_en_basic    :  std_logic;   
   SIGNAL error_irq_en_basic       :  std_logic;   
   SIGNAL overrun_irq_en_basic     :  std_logic;   
   SIGNAL port_xhdl52              :  std_logic;   
   SIGNAL xhdl_61                  :  std_logic;   
   -- End Mode register 
   -- Command register 
   SIGNAL command                  :  std_logic_vector(4 DOWNTO 0);   
   SIGNAL xhdl_69                  :  std_logic;   
   SIGNAL port_xhdl70              :  std_logic;   
   SIGNAL port_xhdl71              :  std_logic;   
   SIGNAL xhdl_77                  :  std_logic;   
   SIGNAL port_xhdl78              :  std_logic;   
   SIGNAL port_xhdl79              :  std_logic;   
   SIGNAL xhdl_85                  :  std_logic;   
   SIGNAL xhdl_91                  :  std_logic;   
   SIGNAL port_xhdl92              :  std_logic;   
   SIGNAL port_xhdl93              :  std_logic;   
   -- End Command register 
   -- Status register 
   SIGNAL status                   :  std_logic_vector(7 DOWNTO 0);   
   -- End Status register 
   -- Interrupt Enable register (extended mode) 
   SIGNAL irq_en_ext               :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL bus_error_irq_en         :  std_logic;   
   SIGNAL arbitration_lost_irq_en  :  std_logic;   
   SIGNAL error_passive_irq_en     :  std_logic;   
   SIGNAL data_overrun_irq_en_ext  :  std_logic;   
   SIGNAL error_warning_irq_en_ext :  std_logic;   
   SIGNAL transmit_irq_en_ext      :  std_logic;   
   SIGNAL receive_irq_en_ext       :  std_logic;   
   -- End Bus Timing 0 register 
   -- Bus Timing 0 register 
   SIGNAL bus_timing_0             :  std_logic_vector(7 DOWNTO 0);   
   -- End Bus Timing 0 register 
   -- Bus Timing 1 register 
   SIGNAL bus_timing_1             :  std_logic_vector(7 DOWNTO 0);   
   -- End Error Warning Limit register 
   -- Clock Divider register 
   SIGNAL clock_divider            :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL clock_off                :  std_logic;   
   SIGNAL cd                       :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL clkout_div               :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL clkout_cnt               :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL clkout_tmp               :  std_logic;   
   SIGNAL port_xhdl116             :  std_logic;   
   SIGNAL port_xhdl117             :  std_logic;   
   SIGNAL port_xhdl123             :  std_logic;   
   SIGNAL port_xhdl124             :  std_logic;   
   SIGNAL temp_xhdl131             :  std_logic;   
   SIGNAL temp_xhdl132             :  std_logic;   
   SIGNAL temp_xhdl218             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl219             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl220             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl221             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl222             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl223             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl224             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl225             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl226             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl227             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl228             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl229             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl230             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   SIGNAL temp_xhdl231             :  std_logic_vector(7 DOWNTO 0);   --  basic mode
   -- Some interrupts exist in basic mode and in extended mode. Since they are in different registers they need to be multiplexed.
   SIGNAL temp_xhdl233             :  std_logic;   
   SIGNAL temp_xhdl234             :  std_logic;   
   SIGNAL temp_xhdl235             :  std_logic;   
   SIGNAL temp_xhdl236             :  std_logic;   
   SIGNAL data_overrun_irq         :  std_logic;   
   SIGNAL transmit_irq             :  std_logic;   
   SIGNAL receive_irq              :  std_logic;   
   SIGNAL error_irq                :  std_logic;   
   SIGNAL bus_error_irq            :  std_logic;   
   SIGNAL arbitration_lost_irq     :  std_logic;   
   SIGNAL error_passive_irq        :  std_logic;   
   SIGNAL data_out_xhdl1           :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL irq_n_xhdl2              :  std_logic;   
   SIGNAL reset_mode_xhdl3         :  std_logic;   
   SIGNAL listen_only_mode_xhdl4   :  std_logic;   
   SIGNAL acceptance_filter_mode_xhdl5    :  std_logic;   
   SIGNAL self_test_mode_xhdl6     :  std_logic;   
   SIGNAL clear_data_overrun_xhdl7 :  std_logic;   
   SIGNAL release_buffer_xhdl8     :  std_logic;   
   SIGNAL abort_tx_xhdl9           :  std_logic;   
   SIGNAL tx_request_xhdl10        :  std_logic;   
   SIGNAL self_rx_request_xhdl11   :  std_logic;   
   SIGNAL single_shot_transmission_xhdl12 :  std_logic;   
   SIGNAL overload_request_xhdl13  :  std_logic;   
   SIGNAL read_arbitration_lost_capture_reg_xhdl14:  std_logic;   
   SIGNAL read_error_code_capture_reg_xhdl15:  std_logic;   
   SIGNAL baud_r_presc_xhdl16      :  std_logic_vector(5 DOWNTO 0);   
   SIGNAL sync_jump_width_xhdl17   :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL time_segment1_xhdl18     :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL time_segment2_xhdl19     :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL triple_sampling_xhdl20   :  std_logic;   
   SIGNAL error_warning_limit_xhdl21      :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL we_rx_err_cnt_xhdl22     :  std_logic;   
   SIGNAL we_tx_err_cnt_xhdl23     :  std_logic;   
   SIGNAL extended_mode_xhdl24     :  std_logic;   
   SIGNAL clkout_xhdl25            :  std_logic;   
   SIGNAL acceptance_code_0_xhdl26 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL acceptance_mask_0_xhdl27 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL acceptance_code_1_xhdl28 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL acceptance_code_2_xhdl29 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL acceptance_code_3_xhdl30 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL acceptance_mask_1_xhdl31 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL acceptance_mask_2_xhdl32 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL acceptance_mask_3_xhdl33 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_0_xhdl34         :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_1_xhdl35         :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_2_xhdl36         :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_3_xhdl37         :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_4_xhdl38         :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_5_xhdl39         :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_6_xhdl40         :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_7_xhdl41         :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_8_xhdl42         :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_9_xhdl43         :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_10_xhdl44        :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_11_xhdl45        :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_12_xhdl46        :  std_logic_vector(7 DOWNTO 0);   

BEGIN
   data_out <= data_out_xhdl1;
   irq_n <= irq_n_xhdl2;
   reset_mode <= reset_mode_xhdl3;
   listen_only_mode <= listen_only_mode_xhdl4;
   acceptance_filter_mode <= acceptance_filter_mode_xhdl5;
   self_test_mode <= self_test_mode_xhdl6;
   clear_data_overrun <= clear_data_overrun_xhdl7;
   release_buffer <= release_buffer_xhdl8;
   abort_tx <= abort_tx_xhdl9;
   tx_request <= tx_request_xhdl10;
   self_rx_request <= self_rx_request_xhdl11;
   single_shot_transmission <= single_shot_transmission_xhdl12;
   overload_request <= overload_request_xhdl13;
   read_arbitration_lost_capture_reg <= read_arbitration_lost_capture_reg_xhdl14;
   read_error_code_capture_reg <= read_error_code_capture_reg_xhdl15;
   baud_r_presc <= baud_r_presc_xhdl16;
   sync_jump_width <= sync_jump_width_xhdl17;
   time_segment1 <= time_segment1_xhdl18;
   time_segment2 <= time_segment2_xhdl19;
   triple_sampling <= triple_sampling_xhdl20;
   error_warning_limit <= error_warning_limit_xhdl21;
   we_rx_err_cnt <= we_rx_err_cnt_xhdl22;
   we_tx_err_cnt <= we_tx_err_cnt_xhdl23;
   extended_mode <= extended_mode_xhdl24;
   clkout <= clkout_xhdl25;
   acceptance_code_0 <= acceptance_code_0_xhdl26;
   acceptance_mask_0 <= acceptance_mask_0_xhdl27;
   acceptance_code_1 <= acceptance_code_1_xhdl28;
   acceptance_code_2 <= acceptance_code_2_xhdl29;
   acceptance_code_3 <= acceptance_code_3_xhdl30;
   acceptance_mask_1 <= acceptance_mask_1_xhdl31;
   acceptance_mask_2 <= acceptance_mask_2_xhdl32;
   acceptance_mask_3 <= acceptance_mask_3_xhdl33;
   tx_data_0 <= tx_data_0_xhdl34;
   tx_data_1 <= tx_data_1_xhdl35;
   tx_data_2 <= tx_data_2_xhdl36;
   tx_data_3 <= tx_data_3_xhdl37;
   tx_data_4 <= tx_data_4_xhdl38;
   tx_data_5 <= tx_data_5_xhdl39;
   tx_data_6 <= tx_data_6_xhdl40;
   tx_data_7 <= tx_data_7_xhdl41;
   tx_data_8 <= tx_data_8_xhdl42;
   tx_data_9 <= tx_data_9_xhdl43;
   tx_data_10 <= tx_data_10_xhdl44;
   tx_data_11 <= tx_data_11_xhdl45;
   tx_data_12 <= tx_data_12_xhdl46;
   we_mode <= (cs AND we) AND CONV_STD_LOGIC(addr = "00000000") ;
   we_command <= (cs AND we) AND CONV_STD_LOGIC(addr = "00000001") ;
   we_bus_timing_0 <= ((cs AND we) AND CONV_STD_LOGIC(addr = "00000110")) AND reset_mode_xhdl3 ;
   we_bus_timing_1 <= ((cs AND we) AND CONV_STD_LOGIC(addr = "00000111")) AND reset_mode_xhdl3 ;
   we_clock_divider_low <= (cs AND we) AND CONV_STD_LOGIC(addr = "00011111") ;
   we_clock_divider_hi <= we_clock_divider_low AND reset_mode_xhdl3 ;
   read <= cs AND (NOT we) ;
   read_irq_reg <= read AND CONV_STD_LOGIC(addr = "00000011") ;
   
   reset_irq_reg <= read_irq_reg_q and not read_irq_reg;
   
   read_arbitration_lost_capture_reg_xhdl14 <= (read AND extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00001011") ;
   read_error_code_capture_reg_xhdl15 <= (read AND extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00001100") ;
   we_acceptance_code_0 <= ((cs AND we) AND reset_mode_xhdl3) AND (((NOT extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00000100")) OR (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00010000"))) ;
   we_acceptance_mask_0 <= ((cs AND we) AND reset_mode_xhdl3) AND (((NOT extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00000101")) OR (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00010100"))) ;
   we_tx_data_0 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (((NOT extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00001010")) OR (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00010000")))) AND transmit_buffer_status ;
   we_tx_data_1 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (((NOT extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00001011")) OR (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00010001")))) AND transmit_buffer_status ;
   we_tx_data_2 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (((NOT extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00001100")) OR (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00010010")))) AND transmit_buffer_status ;
   we_tx_data_3 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (((NOT extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00001101")) OR (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00010011")))) AND transmit_buffer_status ;
   we_tx_data_4 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (((NOT extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00001110")) OR (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00010100")))) AND transmit_buffer_status ;
   we_tx_data_5 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (((NOT extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00001111")) OR (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00010101")))) AND transmit_buffer_status ;
   we_tx_data_6 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (((NOT extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00010000")) OR (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00010110")))) AND transmit_buffer_status ;
   we_tx_data_7 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (((NOT extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00010001")) OR (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00010111")))) AND transmit_buffer_status ;
   we_tx_data_8 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (((NOT extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00010010")) OR (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00011000")))) AND transmit_buffer_status ;
   we_tx_data_9 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (((NOT extended_mode_xhdl24) AND CONV_STD_LOGIC(addr = "00010011")) OR (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00011001")))) AND transmit_buffer_status ;
   we_tx_data_10 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00011010"))) AND transmit_buffer_status ;
   we_tx_data_11 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00011011"))) AND transmit_buffer_status ;
   we_tx_data_12 <= (((cs AND we) AND (NOT reset_mode_xhdl3)) AND (extended_mode_xhdl24 AND CONV_STD_LOGIC(addr = "00011100"))) AND transmit_buffer_status ;
   we_interrupt_enable <= ((cs AND we) AND CONV_STD_LOGIC(addr = "00000100")) AND extended_mode_xhdl24 ;
   we_error_warning_limit <= (((cs AND we) AND CONV_STD_LOGIC(addr = "00001101")) AND reset_mode_xhdl3) AND extended_mode_xhdl24 ;
   we_rx_err_cnt_xhdl22 <= (((cs AND we) AND CONV_STD_LOGIC(addr = "00001110")) AND reset_mode_xhdl3) AND extended_mode_xhdl24 ;
   we_tx_err_cnt_xhdl23 <= (((cs AND we) AND CONV_STD_LOGIC(addr = "00001111")) AND reset_mode_xhdl3) AND extended_mode_xhdl24 ;
   we_acceptance_code_1 <= (((cs AND we) AND CONV_STD_LOGIC(addr = "00010001")) AND reset_mode_xhdl3) AND extended_mode_xhdl24 ;
   we_acceptance_code_2 <= (((cs AND we) AND CONV_STD_LOGIC(addr = "00010010")) AND reset_mode_xhdl3) AND extended_mode_xhdl24 ;
   we_acceptance_code_3 <= (((cs AND we) AND CONV_STD_LOGIC(addr = "00010011")) AND reset_mode_xhdl3) AND extended_mode_xhdl24 ;
   we_acceptance_mask_1 <= (((cs AND we) AND CONV_STD_LOGIC(addr = "00010101")) AND reset_mode_xhdl3) AND extended_mode_xhdl24 ;
   we_acceptance_mask_2 <= (((cs AND we) AND CONV_STD_LOGIC(addr = "00010110")) AND reset_mode_xhdl3) AND extended_mode_xhdl24 ;
   we_acceptance_mask_3 <= (((cs AND we) AND CONV_STD_LOGIC(addr = "00010111")) AND reset_mode_xhdl3) AND extended_mode_xhdl24 ;

   -- End: This section is for EXTENDED mode 
   PROCESS (clk)
   BEGIN
      IF (clk'EVENT AND clk = '1') THEN
         read_irq_reg_q <= read_irq_reg;
         tx_successful_q <= tx_successful ;    
         overrun_q <= overrun ;    
         transmit_buffer_status_q <= transmit_buffer_status ;    
         error_status_q <= error_status ;    
         node_bus_off_q <= node_bus_off ;    
         node_error_passive_q <= node_error_passive ;    
      END IF;
   END PROCESS;
   port_xhdl52 <= data_in(0);
   MODE_REG0 : can_vhdl_register_asyn_syn 
      GENERIC MAP (1, 1)
         PORT MAP (
            data_in(0) => port_xhdl52,
            data_out(0) => mode,
            we => we_mode,
            clk => clk,
            rst => rst,
            rst_sync => set_reset_mode);   
      
      MODE_REG_BASIC : can_vhdl_register_asyn 
         GENERIC MAP (4, 0)
            PORT MAP (
               data_in => data_in(4 DOWNTO 1),
               data_out => mode_basic(4 DOWNTO 1),
               we => we_mode,
               clk => clk,
               rst => rst);   
         
         xhdl_61 <= (we_mode AND reset_mode_xhdl3);
         MODE_REG_EXT : can_vhdl_register_asyn 
            GENERIC MAP (3, 0)
               PORT MAP (
                  data_in => data_in(3 DOWNTO 1),
                  data_out => mode_ext(3 DOWNTO 1),
                  we => xhdl_61,
                  clk => clk,
                  rst => rst);   
            
            reset_mode_xhdl3 <= mode ;
            listen_only_mode_xhdl4 <= extended_mode_xhdl24 AND mode_ext(1) ;
            self_test_mode_xhdl6 <= extended_mode_xhdl24 AND mode_ext(2) ;
            acceptance_filter_mode_xhdl5 <= extended_mode_xhdl24 AND mode_ext(3) ;
            receive_irq_en_basic <= mode_basic(1) ;
            transmit_irq_en_basic <= mode_basic(2) ;
            error_irq_en_basic <= mode_basic(3) ;
            overrun_irq_en_basic <= mode_basic(4) ;
            xhdl_69 <= (command(0) AND sample_point) OR reset_mode_xhdl3;
            port_xhdl70 <= data_in(0);
            command(0) <= port_xhdl71;
            COMMAND_REG0 : can_vhdl_register_asyn_syn 
               GENERIC MAP (1, 0)
                  PORT MAP (
                     data_in(0) => port_xhdl70,
                     data_out(0) => port_xhdl71,
                     we => we_command,
                     clk => clk,
                     rst => rst,
                     rst_sync => xhdl_69);   
               
               xhdl_77 <= (sample_point AND (tx_request_xhdl10 OR (abort_tx_xhdl9 AND NOT transmitting))) OR reset_mode_xhdl3;
               port_xhdl78 <= data_in(1);
               command(1) <= port_xhdl79;
               COMMAND_REG1 : can_vhdl_register_asyn_syn 
                  GENERIC MAP (1, 0)
                     PORT MAP (
                        data_in(0) => port_xhdl78,
                        data_out(0) => port_xhdl79,
                        we => we_command,
                        clk => clk,
                        rst => rst,
                        rst_sync => xhdl_77);   
                  
                  xhdl_85 <= orv(command(3 DOWNTO 2)) OR reset_mode_xhdl3;
                  COMMAND_REG : can_vhdl_register_asyn_syn 
                     GENERIC MAP (2, 0)
                        PORT MAP (
                           data_in => data_in(3 DOWNTO 2),
                           data_out => command(3 DOWNTO 2),
                           we => we_command,
                           clk => clk,
                           rst => rst,
                           rst_sync => xhdl_85);   
                     
                     xhdl_91 <= (command(4) AND sample_point) OR reset_mode_xhdl3;
                     port_xhdl92 <= data_in(4);
                     command(4) <= port_xhdl93;
                     COMMAND_REG4 : can_vhdl_register_asyn_syn 
                        GENERIC MAP (1, 0)
                           PORT MAP (
                              data_in(0) => port_xhdl92,
                              data_out(0) => port_xhdl93,
                              we => we_command,
                              clk => clk,
                              rst => rst,
                              rst_sync => xhdl_91);   
                        

                        PROCESS (clk, rst)
                        BEGIN
                           IF (rst = '1') THEN
                              self_rx_request_xhdl11 <= '0';    
                           ELSif clk'event and clk = '1' then
                              IF ((command(4) AND (NOT command(0))) = '1') THEN
                                 self_rx_request_xhdl11 <= '1' ;    
                              ELSE
                                 IF (((NOT tx_state) AND tx_state_q) = '1') THEN
                                    self_rx_request_xhdl11 <= '0' ;    
                                 END IF;
                              END IF;
                           END IF;
                        END PROCESS;
                        clear_data_overrun_xhdl7 <= command(3) ;
                        release_buffer_xhdl8 <= command(2) ;
                        tx_request_xhdl10 <= command(0) OR command(4) ;
                        abort_tx_xhdl9 <= command(1) AND (NOT tx_request_xhdl10) ;

                        PROCESS (clk, rst)
                        BEGIN
                           IF (rst = '1') THEN
                              single_shot_transmission_xhdl12 <= '0';    
                           ELSif clk'event and clk = '1' then
                              IF (((tx_request_xhdl10 AND command(1)) AND sample_point) = '1') THEN
                                 single_shot_transmission_xhdl12 <= '1' ;    
                              ELSE
                                 IF (((NOT tx_state) AND tx_state_q) = '1') THEN
                                    single_shot_transmission_xhdl12 <= '0' ;    
                                 END IF;
                              END IF;
                           END IF;
                        END PROCESS;
                        --
                        -- can_register_asyn_syn #(1, 1'h0) COMMAND_REG_OVERLOAD  // Uncomment this to enable overload requests !!!
                        -- ( .data_in(data_in[5]),
                        --   .data_out(overload_request),
                        --   .we(we_command),
                        --   .clk(clk),
                        --   .rst(rst),
                        --   .rst_sync(overload_frame & ~overload_frame_q)
                        -- );
                        -- reg           overload_frame_q;
                        -- always @ (posedge clk or posedge rst)
                        -- begin
                        --   if (rst)
                        --     overload_frame_q <= 1'b0;
                        --   else
                        --     overload_frame_q <=#Tp overload_frame;
                        -- end
                        -- 
                        overload_request_xhdl13 <= '0' ;
                        status(7) <= node_bus_off ;
                        status(6) <= error_status ;
                        status(5) <= transmit_status ;
                        status(4) <= receive_status ;
                        status(3) <= transmission_complete ;
                        status(2) <= transmit_buffer_status ;
                        status(1) <= overrun_status ;
                        status(0) <= receive_buffer_status ;

                        PROCESS (clk, rst)
                        BEGIN
                           IF (rst = '1') THEN
                              transmission_complete <= '1';    
                           ELSif clk'event and clk = '1' then
                              IF ((tx_successful AND ((NOT tx_successful_q) OR abort_tx_xhdl9)) = '1') THEN
--                              transmission_complete was always set when abort_tx=1
--                              Original code:                                
--                              IF (((tx_successful AND (NOT tx_successful_q)) OR abort_tx_xhdl9) = '1') THEN                                
                                 transmission_complete <= '1' ;    
                              ELSE
                                 IF (tx_request_xhdl10 = '1') THEN
                                    transmission_complete <= '0' ;    
                                 END IF;
                              END IF;
                           END IF;
                        END PROCESS;

                        PROCESS (clk, rst)
                        BEGIN
                           IF (rst = '1') THEN
                              transmit_buffer_status <= '1';    
                           ELSif clk'event and clk = '1' then
                              IF (tx_request_xhdl10 = '1') THEN
                                 transmit_buffer_status <= '0' ;    
                              ELSE
                                 IF ((reset_mode_xhdl3 OR NOT need_to_tx) = '1') THEN
                                    transmit_buffer_status <= '1' ;    
                                 END IF;
                              END IF;
                           END IF;
                        END PROCESS;

                        PROCESS (clk, rst)
                        BEGIN
                           IF (rst = '1') THEN
                              overrun_status <= '0';    
                           ELSif clk'event and clk = '1' then
                              IF ((overrun AND (NOT overrun_q)) = '1') THEN
                                 overrun_status <= '1' ;    
                              ELSE
                                 IF ((reset_mode_xhdl3 OR clear_data_overrun_xhdl7) = '1') THEN
                                    overrun_status <= '0' ;    
                                 END IF;
                              END IF;
                           END IF;
                        END PROCESS;

                        PROCESS (clk, rst)
                        BEGIN
                           IF (rst = '1') THEN
                              receive_buffer_status <= '0';    
                           ELSif clk'event and clk = '1' then
                              IF ((reset_mode_xhdl3 OR release_buffer_xhdl8) = '1') THEN
                                 receive_buffer_status <= '0' ;    
                              ELSE
                                 IF (NOT info_empty = '1') THEN
                                    receive_buffer_status <= '1' ;    
                                 END IF;
                              END IF;
                           END IF;
                        END PROCESS;
                        IRQ_EN_REG : can_vhdl_register 
                           GENERIC MAP (8)
                              PORT MAP (
                                 data_in => data_in,
                                 data_out => irq_en_ext,
                                 we => we_interrupt_enable,
                                 clk => clk);   
                           
                           bus_error_irq_en <= irq_en_ext(7) ;
                           arbitration_lost_irq_en <= irq_en_ext(6) ;
                           error_passive_irq_en <= irq_en_ext(5) ;
                           data_overrun_irq_en_ext <= irq_en_ext(3) ;
                           error_warning_irq_en_ext <= irq_en_ext(2) ;
                           transmit_irq_en_ext <= irq_en_ext(1) ;
                           receive_irq_en_ext <= irq_en_ext(0) ;
                           BUS_TIMING_0_REG : can_vhdl_register 
                              GENERIC MAP (8)
                                 PORT MAP (
                                    data_in => data_in,
                                    data_out => bus_timing_0,
                                    we => we_bus_timing_0,
                                    clk => clk);   
                              
                              baud_r_presc_xhdl16 <= bus_timing_0(5 DOWNTO 0) ;
                              sync_jump_width_xhdl17 <= bus_timing_0(7 DOWNTO 6) ;
                              BUS_TIMING_1_REG : can_vhdl_register 
                                 GENERIC MAP (8)
                                    PORT MAP (
                                       data_in => data_in,
                                       data_out => bus_timing_1,
                                       we => we_bus_timing_1,
                                       clk => clk);   
                                 
                                 time_segment1_xhdl18 <= bus_timing_1(3 DOWNTO 0) ;
                                 time_segment2_xhdl19 <= bus_timing_1(6 DOWNTO 4) ;
                                 triple_sampling_xhdl20 <= bus_timing_1(7) ;
                                 
                                 -- End Bus Timing 1 register -- Error Warning Limit register 
                                 ERROR_WARNING_REG : can_vhdl_register_asyn 
                                    GENERIC MAP (8, 96)
                                       PORT MAP (
                                          data_in => data_in,
                                          data_out => error_warning_limit_xhdl21,
                                          we => we_error_warning_limit,
                                          clk => clk,
                                          rst => rst);   
                                    
                                    port_xhdl116 <= data_in(7);
                                    clock_divider(7) <= port_xhdl117;
                                    CLOCK_DIVIDER_REG_7 : can_vhdl_register_asyn 
                                       GENERIC MAP (1, 0)
                                          PORT MAP (
                                             data_in(0) => port_xhdl116,
                                             data_out(0) => port_xhdl117,
                                             we => we_clock_divider_hi,
                                             clk => clk,
                                             rst => rst);   
                                       
                                       clock_divider(6 DOWNTO 4) <= "000" ;
                                       port_xhdl123 <= data_in(3);
                                       clock_divider(3) <= port_xhdl124;
                                       CLOCK_DIVIDER_REG_3 : can_vhdl_register_asyn 
                                          GENERIC MAP (1, 0)
                                             PORT MAP (
                                                data_in(0) => port_xhdl123,
                                                data_out(0) => port_xhdl124,
                                                we => we_clock_divider_hi,
                                                clk => clk,
                                                rst => rst);   
                                          
                                          CLOCK_DIVIDER_REG_LOW : can_vhdl_register_asyn 
                                             GENERIC MAP (3, 0)
                                                PORT MAP (
                                                   data_in => data_in(2 DOWNTO 0),
                                                   data_out => clock_divider(2 DOWNTO 0),
                                                   we => we_clock_divider_low,
                                                   clk => clk,
                                                   rst => rst);   
                                             
                                             extended_mode_xhdl24 <= clock_divider(7) ;
                                             clock_off <= clock_divider(3) ;
                                             cd(2 DOWNTO 0) <= clock_divider(2 DOWNTO 0) ;

                                             PROCESS (cd)
                                                VARIABLE clkout_div_xhdl130  : std_logic_vector(2 DOWNTO 0);
                                             BEGIN
                                                CASE cd IS
                                                   -- synthesis full_case parallel_case 
                                                   WHEN "000" =>
                                                            clkout_div_xhdl130 := "000";    
                                                   WHEN "001" =>
                                                            clkout_div_xhdl130 := "001";    
                                                   WHEN "010" =>
                                                            clkout_div_xhdl130 := "010";    
                                                   WHEN "011" =>
                                                            clkout_div_xhdl130 := "011";    
                                                   WHEN "100" =>
                                                            clkout_div_xhdl130 := "100";    
                                                   WHEN "101" =>
                                                            clkout_div_xhdl130 := "101";    
                                                   WHEN "110" =>
                                                            clkout_div_xhdl130 := "110";    
                                                   WHEN "111" =>
                                                            clkout_div_xhdl130 := "000";    
                                                   WHEN OTHERS =>
                                                            NULL;
                                                   
                                                END CASE;
                                                clkout_div <= clkout_div_xhdl130;
                                             END PROCESS;

                                             PROCESS (clk, rst)
                                             BEGIN
                                                IF (rst = '1') THEN
                                                   clkout_cnt <= "000";    
                                                ELSif clk'event and clk = '1' then
                                                   IF (clkout_cnt = clkout_div) THEN
                                                      clkout_cnt <= "000" ;    
                                                   ELSE
                                                      clkout_cnt <= clkout_cnt + "001";    
                                                   END IF;
                                                END IF;
                                             END PROCESS;

                                             PROCESS (clk, rst)
                                             BEGIN
                                                IF (rst = '1') THEN
                                                   clkout_tmp <= '0';    
                                                ELSif clk'event and clk = '1' then
                                                   IF (clkout_cnt = clkout_div) THEN
                                                      clkout_tmp <= NOT clkout_tmp ;    
                                                   END IF;
                                                END IF;
                                             END PROCESS;
                                             temp_xhdl131 <= clk WHEN (andv(cd)) = '1' ELSE clkout_tmp;
                                             temp_xhdl132 <= '1' WHEN clock_off = '1' ELSE (temp_xhdl131);
                                             clkout_xhdl25 <= temp_xhdl132 ;
                                             
                                             -- End Clock Divider register -- This section is for BASIC and EXTENDED mode -- Acceptance code register 
                                             ACCEPTANCE_CODE_REG0 : can_vhdl_register 
                                                GENERIC MAP (8)
                                                   PORT MAP (
                                                      data_in => data_in,
                                                      data_out => acceptance_code_0_xhdl26,
                                                      we => we_acceptance_code_0,
                                                      clk => clk);   
                                                
                                                
                                                -- End: Acceptance code register -- Acceptance mask register 
                                                ACCEPTANCE_MASK_REG0 : can_vhdl_register 
                                                   GENERIC MAP (8)
                                                      PORT MAP (
                                                         data_in => data_in,
                                                         data_out => acceptance_mask_0_xhdl27,
                                                         we => we_acceptance_mask_0,
                                                         clk => clk);   
                                                   
                                                   
                                                   -- End: Acceptance mask register -- End: This section is for BASIC and EXTENDED mode -- Tx data 0 register. 
                                                   TX_DATA_REG0 : can_vhdl_register 
                                                      GENERIC MAP (8)
                                                         PORT MAP (
                                                            data_in => data_in,
                                                            data_out => tx_data_0_xhdl34,
                                                            we => we_tx_data_0,
                                                            clk => clk);   
                                                      
                                                      
                                                      -- End: Tx data 0 register. -- Tx data 1 register. 
                                                      TX_DATA_REG1 : can_vhdl_register 
                                                         GENERIC MAP (8)
                                                            PORT MAP (
                                                               data_in => data_in,
                                                               data_out => tx_data_1_xhdl35,
                                                               we => we_tx_data_1,
                                                               clk => clk);   
                                                         
                                                         
                                                         -- End: Tx data 1 register. -- Tx data 2 register. 
                                                         TX_DATA_REG2 : can_vhdl_register 
                                                            GENERIC MAP (8)
                                                               PORT MAP (
                                                                  data_in => data_in,
                                                                  data_out => tx_data_2_xhdl36,
                                                                  we => we_tx_data_2,
                                                                  clk => clk);   
                                                            
                                                            
                                                            -- End: Tx data 2 register. -- Tx data 3 register. 
                                                            TX_DATA_REG3 : can_vhdl_register 
                                                               GENERIC MAP (8)
                                                                  PORT MAP (
                                                                     data_in => data_in,
                                                                     data_out => tx_data_3_xhdl37,
                                                                     we => we_tx_data_3,
                                                                     clk => clk);   
                                                               
                                                               
                                                               -- End: Tx data 3 register. -- Tx data 4 register. 
                                                               TX_DATA_REG4 : can_vhdl_register 
                                                                  GENERIC MAP (8)
                                                                     PORT MAP (
                                                                        data_in => data_in,
                                                                        data_out => tx_data_4_xhdl38,
                                                                        we => we_tx_data_4,
                                                                        clk => clk);   
                                                                  
                                                                  
                                                                  -- End: Tx data 4 register. -- Tx data 5 register. 
                                                                  TX_DATA_REG5 : can_vhdl_register 
                                                                     GENERIC MAP (8)
                                                                        PORT MAP (
                                                                           data_in => data_in,
                                                                           data_out => tx_data_5_xhdl39,
                                                                           we => we_tx_data_5,
                                                                           clk => clk);   
                                                                     
                                                                     
                                                                     -- End: Tx data 5 register. -- Tx data 6 register. 
                                                                     TX_DATA_REG6 : can_vhdl_register 
                                                                        GENERIC MAP (8)
                                                                           PORT MAP (
                                                                              data_in => data_in,
                                                                              data_out => tx_data_6_xhdl40,
                                                                              we => we_tx_data_6,
                                                                              clk => clk);   
                                                                        
                                                                        
                                                                        -- End: Tx data 6 register. -- Tx data 7 register. 
                                                                        TX_DATA_REG7 : can_vhdl_register 
                                                                           GENERIC MAP (8)
                                                                              PORT MAP (
                                                                                 data_in => data_in,
                                                                                 data_out => tx_data_7_xhdl41,
                                                                                 we => we_tx_data_7,
                                                                                 clk => clk);   
                                                                           
                                                                           
                                                                           -- End: Tx data 7 register. -- Tx data 8 register. 
                                                                           TX_DATA_REG8 : can_vhdl_register 
                                                                              GENERIC MAP (8)
                                                                                 PORT MAP (
                                                                                    data_in => data_in,
                                                                                    data_out => tx_data_8_xhdl42,
                                                                                    we => we_tx_data_8,
                                                                                    clk => clk);   
                                                                              
                                                                              
                                                                              -- End: Tx data 8 register. -- Tx data 9 register. 
                                                                              TX_DATA_REG9 : can_vhdl_register 
                                                                                 GENERIC MAP (8)
                                                                                    PORT MAP (
                                                                                       data_in => data_in,
                                                                                       data_out => tx_data_9_xhdl43,
                                                                                       we => we_tx_data_9,
                                                                                       clk => clk);   
                                                                                 
                                                                                 
                                                                                 -- End: Tx data 9 register. -- Tx data 10 register. 
                                                                                 TX_DATA_REG10 : can_vhdl_register 
                                                                                    GENERIC MAP (8)
                                                                                       PORT MAP (
                                                                                          data_in => data_in,
                                                                                          data_out => tx_data_10_xhdl44,
                                                                                          we => we_tx_data_10,
                                                                                          clk => clk);   
                                                                                    
                                                                                    
                                                                                    -- End: Tx data 10 register. -- Tx data 11 register. 
                                                                                    TX_DATA_REG11 : can_vhdl_register 
                                                                                       GENERIC MAP (8)
                                                                                          PORT MAP (
                                                                                             data_in => data_in,
                                                                                             data_out => tx_data_11_xhdl45,
                                                                                             we => we_tx_data_11,
                                                                                             clk => clk);   
                                                                                       
                                                                                       
                                                                                       -- End: Tx data 11 register. -- Tx data 12 register. 
                                                                                       TX_DATA_REG12 : can_vhdl_register 
                                                                                          GENERIC MAP (8)
                                                                                             PORT MAP (
                                                                                                data_in => data_in,
                                                                                                data_out => tx_data_12_xhdl46,
                                                                                                we => we_tx_data_12,
                                                                                                clk => clk);   
                                                                                          
                                                                                          
                                                                                          -- End: Tx data 12 register. -- This section is for EXTENDED mode -- Acceptance code register 1 
                                                                                          ACCEPTANCE_CODE_REG1 : can_vhdl_register 
                                                                                             GENERIC MAP (8)
                                                                                                PORT MAP (
                                                                                                   data_in => data_in,
                                                                                                   data_out => acceptance_code_1_xhdl28,
                                                                                                   we => we_acceptance_code_1,
                                                                                                   clk => clk);   
                                                                                             
                                                                                             
                                                                                             -- End: Acceptance code register -- Acceptance code register 2 
                                                                                             ACCEPTANCE_CODE_REG2 : can_vhdl_register 
                                                                                                GENERIC MAP (8)
                                                                                                   PORT MAP (
                                                                                                      data_in => data_in,
                                                                                                      data_out => acceptance_code_2_xhdl29,
                                                                                                      we => we_acceptance_code_2,
                                                                                                      clk => clk);   
                                                                                                
                                                                                                
                                                                                                -- End: Acceptance code register -- Acceptance code register 3 
                                                                                                ACCEPTANCE_CODE_REG3 : can_vhdl_register 
                                                                                                   GENERIC MAP (8)
                                                                                                      PORT MAP (
                                                                                                         data_in => data_in,
                                                                                                         data_out => acceptance_code_3_xhdl30,
                                                                                                         we => we_acceptance_code_3,
                                                                                                         clk => clk);   
                                                                                                   
                                                                                                   
                                                                                                   -- End: Acceptance code register -- Acceptance mask register 1 
                                                                                                   ACCEPTANCE_MASK_REG1 : can_vhdl_register 
                                                                                                      GENERIC MAP (8)
                                                                                                         PORT MAP (
                                                                                                            data_in => data_in,
                                                                                                            data_out => acceptance_mask_1_xhdl31,
                                                                                                            we => we_acceptance_mask_1,
                                                                                                            clk => clk);   
                                                                                                      
                                                                                                      
                                                                                                      -- End: Acceptance code register -- Acceptance mask register 2 
                                                                                                      ACCEPTANCE_MASK_REG2 : can_vhdl_register 
                                                                                                         GENERIC MAP (8)
                                                                                                            PORT MAP (
                                                                                                               data_in => data_in,
                                                                                                               data_out => acceptance_mask_2_xhdl32,
                                                                                                               we => we_acceptance_mask_2,
                                                                                                               clk => clk);   
                                                                                                         
                                                                                                         
                                                                                                         -- End: Acceptance code register -- Acceptance mask register 3 
                                                                                                         ACCEPTANCE_MASK_REG3 : can_vhdl_register 
                                                                                                            GENERIC MAP (8)
                                                                                                               PORT MAP (
                                                                                                                  data_in => data_in,
                                                                                                                  data_out => acceptance_mask_3_xhdl33,
                                                                                                                  we => we_acceptance_mask_3,
                                                                                                                  clk => clk);   
                                                                                                            
                                                                                                            temp_xhdl218 <= acceptance_code_0_xhdl26 WHEN reset_mode_xhdl3 = '1' ELSE "11111111";
                                                                                                            temp_xhdl219 <= acceptance_mask_0_xhdl27 WHEN reset_mode_xhdl3 = '1' ELSE "11111111";
                                                                                                            temp_xhdl220 <= bus_timing_0 WHEN reset_mode_xhdl3 = '1' ELSE "11111111";
                                                                                                            temp_xhdl221 <= bus_timing_1 WHEN reset_mode_xhdl3 = '1' ELSE "11111111";
                                                                                                            temp_xhdl222 <= "11111111" WHEN reset_mode_xhdl3 = '1' ELSE tx_data_0_xhdl34;
                                                                                                            temp_xhdl223 <= "11111111" WHEN reset_mode_xhdl3 = '1' ELSE tx_data_1_xhdl35;
                                                                                                            temp_xhdl224 <= "11111111" WHEN reset_mode_xhdl3 = '1' ELSE tx_data_2_xhdl36;
                                                                                                            temp_xhdl225 <= "11111111" WHEN reset_mode_xhdl3 = '1' ELSE tx_data_3_xhdl37;
                                                                                                            temp_xhdl226 <= "11111111" WHEN reset_mode_xhdl3 = '1' ELSE tx_data_4_xhdl38;
                                                                                                            temp_xhdl227 <= "11111111" WHEN reset_mode_xhdl3 = '1' ELSE tx_data_5_xhdl39;
                                                                                                            temp_xhdl228 <= "11111111" WHEN reset_mode_xhdl3 = '1' ELSE tx_data_6_xhdl40;
                                                                                                            temp_xhdl229 <= "11111111" WHEN reset_mode_xhdl3 = '1' ELSE tx_data_7_xhdl41;
                                                                                                            temp_xhdl230 <= "11111111" WHEN reset_mode_xhdl3 = '1' ELSE tx_data_8_xhdl42;
                                                                                                            temp_xhdl231 <= "11111111" WHEN reset_mode_xhdl3 = '1' ELSE tx_data_9_xhdl43;

                                                                                                            -- End: Acceptance code register -- End: This section is for EXTENDED mode -- Reading data from registers
                                                                                                            
                                                                                                            PROCESS (addr, extended_mode_xhdl24, mode, bus_timing_0, bus_timing_1, clock_divider, 
															acceptance_code_0_xhdl26, acceptance_code_1_xhdl28, acceptance_code_2_xhdl29, 
															acceptance_code_3_xhdl30, acceptance_mask_0_xhdl27, acceptance_mask_1_xhdl31, 
															acceptance_mask_2_xhdl32, acceptance_mask_3_xhdl33, status, 
															error_warning_limit_xhdl21, rx_err_cnt, tx_err_cnt, irq_en_ext, irq_reg, mode_ext, 
															arbitration_lost_capture, rx_message_counter, mode_basic, error_capture_code,
															temp_xhdl218, temp_xhdl219, temp_xhdl220, temp_xhdl221, temp_xhdl222, temp_xhdl223,
															temp_xhdl224, temp_xhdl225, temp_xhdl226, temp_xhdl227, temp_xhdl228, temp_xhdl229,
															temp_xhdl230, temp_xhdl231
														       )
                                                                                                               VARIABLE data_out_xhdl1_xhdl217  : std_logic_vector(7 DOWNTO 0);
                                                                                                               VARIABLE temp_xhdl232  : std_logic_vector(5 DOWNTO 0);
                                                                                                            BEGIN
                                                                                                               temp_xhdl232 := extended_mode_xhdl24 & addr(4 DOWNTO 0);
                                                                                                               CASE temp_xhdl232 IS
                                                                                                                  WHEN "100000" =>
                                                                                                                           data_out_xhdl1_xhdl217 := "0000" & mode_ext(3 DOWNTO 1) & mode;    --  extended mode
                                                                                                                  WHEN "100001" =>
                                                                                                                           data_out_xhdl1_xhdl217 := "00000000";    --  extended mode
                                                                                                                  WHEN "100010" =>
                                                                                                                           data_out_xhdl1_xhdl217 := status;    --  extended mode
                                                                                                                  WHEN "100011" =>
                                                                                                                           data_out_xhdl1_xhdl217 := irq_reg;    --  extended mode
                                                                                                                  WHEN "100100" =>
                                                                                                                           data_out_xhdl1_xhdl217 := irq_en_ext;    --  extended mode
                                                                                                                  WHEN "100110" =>
                                                                                                                           data_out_xhdl1_xhdl217 := bus_timing_0;    --  extended mode
                                                                                                                  WHEN "100111" =>
                                                                                                                           data_out_xhdl1_xhdl217 := bus_timing_1;    --  extended mode
                                                                                                                  WHEN "101011" =>
                                                                                                                           data_out_xhdl1_xhdl217 := "000" & arbitration_lost_capture(4 DOWNTO 0);    --  extended mode
                                                                                                                  WHEN "101100" =>
                                                                                                                           data_out_xhdl1_xhdl217 := error_capture_code;    --  extended mode
                                                                                                                  WHEN "101101" =>
                                                                                                                           data_out_xhdl1_xhdl217 := error_warning_limit_xhdl21;    --  extended mode
                                                                                                                  WHEN "101110" =>
                                                                                                                           data_out_xhdl1_xhdl217 := rx_err_cnt;    --  extended mode
                                                                                                                  WHEN "101111" =>
                                                                                                                           data_out_xhdl1_xhdl217 := tx_err_cnt;    --  extended mode
                                                                                                                  WHEN "110000" =>
                                                                                                                           data_out_xhdl1_xhdl217 := acceptance_code_0_xhdl26;    --  extended mode
                                                                                                                  WHEN "110001" =>
                                                                                                                           data_out_xhdl1_xhdl217 := acceptance_code_1_xhdl28;    --  extended mode
                                                                                                                  WHEN "110010" =>
                                                                                                                           data_out_xhdl1_xhdl217 := acceptance_code_2_xhdl29;    --  extended mode
                                                                                                                  WHEN "110011" =>
                                                                                                                           data_out_xhdl1_xhdl217 := acceptance_code_3_xhdl30;    --  extended mode
                                                                                                                  WHEN "110100" =>
                                                                                                                           data_out_xhdl1_xhdl217 := acceptance_mask_0_xhdl27;    --  extended mode
                                                                                                                  WHEN "110101" =>
                                                                                                                           data_out_xhdl1_xhdl217 := acceptance_mask_1_xhdl31;    --  extended mode
                                                                                                                  WHEN "110110" =>
                                                                                                                           data_out_xhdl1_xhdl217 := acceptance_mask_2_xhdl32;    --  extended mode
                                                                                                                  WHEN "110111" =>
                                                                                                                           data_out_xhdl1_xhdl217 := acceptance_mask_3_xhdl33;    --  extended mode
                                                                                                                  WHEN "111000" =>
                                                                                                                           data_out_xhdl1_xhdl217 := "00000000";    --  extended mode
                                                                                                                  WHEN "111001" =>
                                                                                                                           data_out_xhdl1_xhdl217 := "00000000";    --  extended mode
                                                                                                                  WHEN "111010" =>
                                                                                                                           data_out_xhdl1_xhdl217 := "00000000";    --  extended mode
                                                                                                                  WHEN "111011" =>
                                                                                                                           data_out_xhdl1_xhdl217 := "00000000";    --  extended mode
                                                                                                                  WHEN "111100" =>
                                                                                                                           data_out_xhdl1_xhdl217 := "00000000";    --  extended mode
                                                                                                                  WHEN "111101" =>
                                                                                                                           data_out_xhdl1_xhdl217 := '0' & rx_message_counter;    --  extended mode
                                                                                                                  WHEN "111111" =>
                                                                                                                           data_out_xhdl1_xhdl217 := clock_divider;    --  extended mode
                                                                                                                  WHEN "000000" =>
                                                                                                                           data_out_xhdl1_xhdl217 := "001" & mode_basic(4 DOWNTO 1) & mode;    --  basic mode
                                                                                                                  WHEN "000001" =>
                                                                                                                           data_out_xhdl1_xhdl217 := "11111111";    --  basic mode
                                                                                                                  WHEN "000010" =>
                                                                                                                           data_out_xhdl1_xhdl217 := status;    --  basic mode
                                                                                                                  WHEN "000011" =>
                                                                                                                           data_out_xhdl1_xhdl217 := "1110" & irq_reg(3 DOWNTO 0);    --  basic mode
                                                                                                                  WHEN "000100" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl218;    
                                                                                                                  WHEN "000101" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl219;    
                                                                                                                  WHEN "000110" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl220;    
                                                                                                                  WHEN "000111" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl221;    
                                                                                                                  WHEN "001010" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl222;    
                                                                                                                  WHEN "001011" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl223;    
                                                                                                                  WHEN "001100" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl224;    
                                                                                                                  WHEN "001101" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl225;    
                                                                                                                  WHEN "001110" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl226;    
                                                                                                                  WHEN "001111" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl227;    
                                                                                                                  WHEN "010000" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl228;    
                                                                                                                  WHEN "010001" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl229;    
                                                                                                                  WHEN "010010" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl230;    
                                                                                                                  WHEN "010011" =>
                                                                                                                           data_out_xhdl1_xhdl217 := temp_xhdl231;    
                                                                                                                  WHEN "011111" =>
                                                                                                                           data_out_xhdl1_xhdl217 := clock_divider;    --  basic mode
                                                                                                                  WHEN OTHERS  =>
                                                                                                                           data_out_xhdl1_xhdl217 := "00000000";    --  the rest is read as 0
                                                                                                                  
                                                                                                               END CASE;
                                                                                                               data_out_xhdl1 <= data_out_xhdl1_xhdl217;
                                                                                                            END PROCESS;
                                                                                                            temp_xhdl233 <= data_overrun_irq_en_ext WHEN extended_mode_xhdl24 = '1' ELSE overrun_irq_en_basic;
                                                                                                            data_overrun_irq_en <= temp_xhdl233 ;
                                                                                                            temp_xhdl234 <= error_warning_irq_en_ext WHEN extended_mode_xhdl24 = '1' ELSE error_irq_en_basic;
                                                                                                            error_warning_irq_en <= temp_xhdl234 ;
                                                                                                            temp_xhdl235 <= transmit_irq_en_ext WHEN extended_mode_xhdl24 = '1' ELSE transmit_irq_en_basic;
                                                                                                            transmit_irq_en <= temp_xhdl235 ;
                                                                                                            temp_xhdl236 <= receive_irq_en_ext WHEN extended_mode_xhdl24 = '1' ELSE receive_irq_en_basic;
                                                                                                            receive_irq_en <= temp_xhdl236 ;

                                                                                                            PROCESS (clk, rst)
                                                                                                            BEGIN
                                                                                                               IF (rst = '1') THEN
                                                                                                                  data_overrun_irq <= '0';    
                                                                                                               ELSif clk'event and clk = '1' then
                                                                                                                  IF (((overrun AND (NOT overrun_q)) AND data_overrun_irq_en) = '1') THEN
                                                                                                                     data_overrun_irq <= '1' ;    
                                                                                                                  ELSE
                                                                                                                     IF ((reset_mode_xhdl3 OR reset_irq_reg) = '1') THEN
                                                                                                                        data_overrun_irq <= '0' ;    
                                                                                                                     END IF;
                                                                                                                  END IF;
                                                                                                               END IF;
                                                                                                            END PROCESS;

                                                                                                            PROCESS (clk, rst)
                                                                                                            BEGIN
                                                                                                               IF (rst = '1') THEN
                                                                                                                  transmit_irq <= '0';    
                                                                                                               ELSif clk'event and clk = '1' then
                                                                                                                  IF ((reset_mode_xhdl3 OR reset_irq_reg) = '1') THEN
                                                                                                                     transmit_irq <= '0' ;    
                                                                                                                  ELSE
                                                                                                                     IF (((transmit_buffer_status AND (NOT transmit_buffer_status_q)) AND transmit_irq_en) = '1') THEN
                                                                                                                        transmit_irq <= '1' ;    
                                                                                                                     END IF;
                                                                                                                  END IF;
                                                                                                               END IF;
                                                                                                            END PROCESS;

                                                                                                            PROCESS (clk, rst)
                                                                                                            BEGIN
                                                                                                               IF (rst = '1') THEN
                                                                                                                  receive_irq <= '0';    
                                                                                                               ELSif clk'event and clk = '1' then
                                                                                                                  IF ((((NOT info_empty) AND (NOT receive_irq)) AND receive_irq_en) = '1') THEN
                                                                                                                     receive_irq <= '1' ;    
                                                                                                                  ELSE
                                                                                                                     IF ((reset_mode_xhdl3 OR release_buffer_xhdl8) = '1') THEN
                                                                                                                        receive_irq <= '0' ;    
                                                                                                                     END IF;
                                                                                                                  END IF;
                                                                                                               END IF;
                                                                                                            END PROCESS;

                                                                                                            PROCESS (clk, rst)
                                                                                                            BEGIN
                                                                                                               IF (rst = '1') THEN
                                                                                                                  error_irq <= '0';    
                                                                                                               ELSif clk'event and clk = '1' then
                                                                                                                  IF ((((error_status XOR error_status_q) OR (node_bus_off XOR node_bus_off_q)) AND error_warning_irq_en) = '1') THEN
                                                                                                                     error_irq <= '1' ;    
                                                                                                                  ELSE
                                                                                                                     IF (reset_irq_reg = '1') THEN
                                                                                                                        error_irq <= '0' ;    
                                                                                                                     END IF;
                                                                                                                  END IF;
                                                                                                               END IF;
                                                                                                            END PROCESS;

                                                                                                            PROCESS (clk, rst)
                                                                                                            BEGIN
                                                                                                               IF (rst = '1') THEN
                                                                                                                  bus_error_irq <= '0';    
                                                                                                               ELSif clk'event and clk = '1' then
                                                                                                                  IF ((set_bus_error_irq AND bus_error_irq_en) = '1') THEN
                                                                                                                     bus_error_irq <= '1' ;    
                                                                                                                  ELSE
                                                                                                                     IF ((reset_mode_xhdl3 OR reset_irq_reg) = '1') THEN
                                                                                                                        bus_error_irq <= '0' ;    
                                                                                                                     END IF;
                                                                                                                  END IF;
                                                                                                               END IF;
                                                                                                            END PROCESS;

                                                                                                            PROCESS (clk, rst)
                                                                                                            BEGIN
                                                                                                               IF (rst = '1') THEN
                                                                                                                  arbitration_lost_irq <= '0';    
                                                                                                               ELSif clk'event and clk = '1' then
                                                                                                                  IF ((set_arbitration_lost_irq AND arbitration_lost_irq_en) = '1') THEN
                                                                                                                     arbitration_lost_irq <= '1' ;    
                                                                                                                  ELSE
                                                                                                                     IF ((reset_mode_xhdl3 OR reset_irq_reg) = '1') THEN
                                                                                                                        arbitration_lost_irq <= '0' ;    
                                                                                                                     END IF;
                                                                                                                  END IF;
                                                                                                               END IF;
                                                                                                            END PROCESS;

                                                                                                            PROCESS (clk, rst)
                                                                                                            BEGIN
                                                                                                               IF (rst = '1') THEN
                                                                                                                  error_passive_irq <= '0';    
                                                                                                               ELSif clk'event and clk = '1' then
                                                                                                                  IF ((((node_error_passive AND (NOT node_error_passive_q)) OR (((NOT node_error_passive) AND node_error_passive_q) AND node_error_active)) AND error_passive_irq_en) = '1') THEN
                                                                                                                     error_passive_irq <= '1' ;    
                                                                                                                  ELSE
                                                                                                                     IF ((reset_mode_xhdl3 OR reset_irq_reg) = '1') THEN
                                                                                                                        error_passive_irq <= '0' ;    
                                                                                                                     END IF;
                                                                                                                  END IF;
                                                                                                               END IF;
                                                                                                            END PROCESS;
                                                                                                            irq_reg <= bus_error_irq & arbitration_lost_irq & error_passive_irq & '0' & data_overrun_irq & error_irq & transmit_irq & receive_irq ;
                                                                                                            irq <= data_overrun_irq OR transmit_irq OR receive_irq OR error_irq OR bus_error_irq OR arbitration_lost_irq OR error_passive_irq ;

--   irq_o reset change /Kristoffer 2006-02-23                                                                 PROCESS (clk, rst)
--                                                                                                             BEGIN
--                                                                                                                IF (rst = '1') THEN
--                                                                                                                   irq_n_xhdl2 <= '1';    
--                                                                                                                ELSif clk'event and clk = '1' then
--                                                                                                                   IF (reset_irq_reg = '1' or release_buffer_xhdl8='1') THEN
--                                                                                                                      irq_n_xhdl2 <= '1';    
--                                                                                                                   ELSE
--                                                                                                                      IF (irq = '1') THEN
--                                                                                                                         irq_n_xhdl2 <= '0' ;    
--                                                                                                                      END IF;
--                                                                                                                   END IF;
--                                                                                                                END IF;
--                                                                                                             END PROCESS;

                                                                                                            PROCESS (clk, rst)
                                                                                                            BEGIN
                                                                                                               IF (rst = '1' or release_buffer_xhdl8 = '1') THEN
                                                                                                                  irq_n_xhdl2 <= '1';    
                                                                                                               ELSif clk'event and clk = '1' then

                                                                                                                   irq_n_xhdl2 <= not irq;    
                                                                                                                
                                                                                                               END IF;
                                                                                                            END PROCESS;


END ARCHITECTURE RTL;