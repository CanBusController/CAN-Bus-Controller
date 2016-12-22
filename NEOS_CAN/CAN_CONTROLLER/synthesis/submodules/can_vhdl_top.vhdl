
LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY can_vhdl_top IS
   PORT (

      av_rst_i                : IN std_logic;   
      av_dat_i                : IN std_logic_vector(7 DOWNTO 0);   
      av_dat_o                : OUT std_logic_vector(7 DOWNTO 0);   
      av_we_i                 : IN std_logic;   
      av_adr_i                : IN std_logic_vector(7 DOWNTO 0);
   
      av_cs_i                      : IN std_logic;  
     
      clk_i                   : IN std_logic;   
      rx_i                    : IN std_logic;   
      tx_o                    : OUT std_logic;   
      bus_off_on              : OUT std_logic;   
      irq_on                  : OUT std_logic;   
      clkout_o                : OUT std_logic);   
END ENTITY can_vhdl_top;

ARCHITECTURE RTL OF can_vhdl_top IS

function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end;

   COMPONENT can_vhdl_bsp
      PORT (
         clk                     : IN  std_logic;
         rst                     : IN  std_logic;
         sample_point            : IN  std_logic;
         sampled_bit             : IN  std_logic;
         sampled_bit_q           : IN  std_logic;
         tx_point                : IN  std_logic;
         hard_sync               : IN  std_logic;
         addr                    : IN  std_logic_vector(7 DOWNTO 0);
         data_in                 : IN  std_logic_vector(7 DOWNTO 0);
         data_out                : OUT std_logic_vector(7 DOWNTO 0);
         fifo_selected           : IN  std_logic;
         reset_mode              : IN  std_logic;
         listen_only_mode        : IN  std_logic;
         acceptance_filter_mode  : IN  std_logic;
         self_test_mode          : IN  std_logic;
         release_buffer          : IN  std_logic;
         tx_request              : IN  std_logic;
         abort_tx                : IN  std_logic;
         self_rx_request         : IN  std_logic;
         single_shot_transmission: IN  std_logic;
         tx_state                : OUT std_logic;
         tx_state_q              : OUT std_logic;
         overload_request        : IN  std_logic;
         overload_frame          : OUT std_logic;
         read_arbitration_lost_capture_reg: IN  std_logic;
         read_error_code_capture_reg: IN  std_logic;
         error_capture_code      : OUT std_logic_vector(7 DOWNTO 0);
         error_warning_limit     : IN  std_logic_vector(7 DOWNTO 0);
         we_rx_err_cnt           : IN  std_logic;
         we_tx_err_cnt           : IN  std_logic;
         extended_mode           : IN  std_logic;
         rx_idle                 : OUT std_logic;
         transmitting            : OUT std_logic;
         transmitter             : OUT std_logic;
         go_rx_inter             : OUT std_logic;
         not_first_bit_of_inter  : OUT std_logic;
         rx_inter                : OUT std_logic;
         set_reset_mode          : OUT std_logic;
         node_bus_off            : OUT std_logic;
         error_status            : OUT std_logic;
         rx_err_cnt              : OUT std_logic_vector(8 DOWNTO 0);
         tx_err_cnt              : OUT std_logic_vector(8 DOWNTO 0);
         transmit_status         : OUT std_logic;
         receive_status          : OUT std_logic;
         tx_successful           : OUT std_logic;
         need_to_tx              : OUT std_logic;
         overrun                 : OUT std_logic;
         info_empty              : OUT std_logic;
         set_bus_error_irq       : OUT std_logic;
         set_arbitration_lost_irq: OUT std_logic;
         arbitration_lost_capture: OUT std_logic_vector(4 DOWNTO 0);
         node_error_passive      : OUT std_logic;
         node_error_active       : OUT std_logic;
         rx_message_counter      : OUT std_logic_vector(6 DOWNTO 0);
         acceptance_code_0       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_mask_0       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_code_1       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_code_2       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_code_3       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_mask_1       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_mask_2       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_mask_3       : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_0               : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_1               : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_2               : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_3               : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_4               : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_5               : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_6               : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_7               : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_8               : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_9               : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_10              : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_11              : IN  std_logic_vector(7 DOWNTO 0);
         tx_data_12              : IN  std_logic_vector(7 DOWNTO 0);
         tx                      : OUT std_logic;
         tx_next                 : OUT std_logic;
         bus_off_on              : OUT std_logic;
         go_overload_frame       : OUT std_logic;
         go_error_frame          : OUT std_logic;
         go_tx                   : OUT std_logic;
         send_ack                : OUT std_logic);
   END COMPONENT;

   COMPONENT can_vhdl_btl
      PORT (
         clk                     : IN  std_logic;
         rst                     : IN  std_logic;
         rx                      : IN  std_logic;
         tx                      : IN  std_logic;
         baud_r_presc            : IN  std_logic_vector(5 DOWNTO 0);
         sync_jump_width         : IN  std_logic_vector(1 DOWNTO 0);
         time_segment1           : IN  std_logic_vector(3 DOWNTO 0);
         time_segment2           : IN  std_logic_vector(2 DOWNTO 0);
         triple_sampling         : IN  std_logic;
         sample_point            : OUT std_logic;
         sampled_bit             : OUT std_logic;
         sampled_bit_q           : OUT std_logic;
         tx_point                : OUT std_logic;
         hard_sync               : OUT std_logic;
         rx_idle                 : IN  std_logic;
         rx_inter                : IN  std_logic;
         transmitting            : IN  std_logic;
         transmitter             : IN  std_logic;
         go_rx_inter             : IN  std_logic;
         tx_next                 : IN  std_logic;
         go_overload_frame       : IN  std_logic;
         go_error_frame          : IN  std_logic;
         go_tx                   : IN  std_logic;
         send_ack                : IN  std_logic;
         node_error_passive      : IN  std_logic);
   END COMPONENT;

   COMPONENT can_vhdl_registers
      PORT (
         clk                     : IN  std_logic;
         rst                     : IN  std_logic;
         cs                      : IN  std_logic;
         we                      : IN  std_logic;
         addr                    : IN  std_logic_vector(7 DOWNTO 0);
         data_in                 : IN  std_logic_vector(7 DOWNTO 0);
         data_out                : OUT std_logic_vector(7 DOWNTO 0);
         irq_n                   : OUT std_logic;
         sample_point            : IN  std_logic;
         transmitting            : IN  std_logic;
         set_reset_mode          : IN  std_logic;
         node_bus_off            : IN  std_logic;
         error_status            : IN  std_logic;
         rx_err_cnt              : IN  std_logic_vector(7 DOWNTO 0);
         tx_err_cnt              : IN  std_logic_vector(7 DOWNTO 0);
         transmit_status         : IN  std_logic;
         receive_status          : IN  std_logic;
         tx_successful           : IN  std_logic;
         need_to_tx              : IN  std_logic;
         overrun                 : IN  std_logic;
         info_empty              : IN  std_logic;
         set_bus_error_irq       : IN  std_logic;
         set_arbitration_lost_irq: IN  std_logic;
         arbitration_lost_capture: IN  std_logic_vector(4 DOWNTO 0);
         node_error_passive      : IN  std_logic;
         node_error_active       : IN  std_logic;
         rx_message_counter      : IN  std_logic_vector(6 DOWNTO 0);
         reset_mode              : OUT std_logic;
         listen_only_mode        : OUT std_logic;
         acceptance_filter_mode  : OUT std_logic;
         self_test_mode          : OUT std_logic;
         clear_data_overrun      : OUT std_logic;
         release_buffer          : OUT std_logic;
         abort_tx                : OUT std_logic;
         tx_request              : OUT std_logic;
         self_rx_request         : OUT std_logic;
         single_shot_transmission: OUT std_logic;
         tx_state                : IN  std_logic;
         tx_state_q              : IN  std_logic;
         overload_request        : OUT std_logic;
         overload_frame          : IN  std_logic;
         read_arbitration_lost_capture_reg: OUT std_logic;
         read_error_code_capture_reg: OUT std_logic;
         error_capture_code      : IN  std_logic_vector(7 DOWNTO 0);
         baud_r_presc            : OUT std_logic_vector(5 DOWNTO 0);
         sync_jump_width         : OUT std_logic_vector(1 DOWNTO 0);
         time_segment1           : OUT std_logic_vector(3 DOWNTO 0);
         time_segment2           : OUT std_logic_vector(2 DOWNTO 0);
         triple_sampling         : OUT std_logic;
         error_warning_limit     : OUT std_logic_vector(7 DOWNTO 0);
         we_rx_err_cnt           : OUT std_logic;
         we_tx_err_cnt           : OUT std_logic;
         extended_mode           : OUT std_logic;
         clkout                  : OUT std_logic;
         acceptance_code_0       : OUT std_logic_vector(7 DOWNTO 0);
         acceptance_mask_0       : OUT std_logic_vector(7 DOWNTO 0);
         acceptance_code_1       : OUT std_logic_vector(7 DOWNTO 0);
         acceptance_code_2       : OUT std_logic_vector(7 DOWNTO 0);
         acceptance_code_3       : OUT std_logic_vector(7 DOWNTO 0);
         acceptance_mask_1       : OUT std_logic_vector(7 DOWNTO 0);
         acceptance_mask_2       : OUT std_logic_vector(7 DOWNTO 0);
         acceptance_mask_3       : OUT std_logic_vector(7 DOWNTO 0);
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
   END COMPONENT;


   SIGNAL cs_sync1                 :  std_logic;   
   SIGNAL cs_sync2                 :  std_logic;   
   SIGNAL cs_sync3                 :  std_logic;   
   SIGNAL cs_ack1                  :  std_logic;   
   SIGNAL cs_ack2                  :  std_logic;   
   SIGNAL cs_ack3                  :  std_logic;   
   SIGNAL cs_sync_rst1             :  std_logic;   
   SIGNAL cs_sync_rst2             :  std_logic;   
   SIGNAL cs_can_i                 :  std_logic;
   SIGNAL cs                       :  std_logic; 
   ---------------------------------
   SIGNAL data_out_fifo_selected   :  std_logic;   
   SIGNAL data_out_fifo            :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL data_out_regs            :  std_logic_vector(7 DOWNTO 0);   
   -- Mode register 
   SIGNAL reset_mode               :  std_logic;   
   SIGNAL listen_only_mode         :  std_logic;   
   SIGNAL acceptance_filter_mode   :  std_logic;   
   SIGNAL self_test_mode           :  std_logic;   
   -- Command register 
   SIGNAL release_buffer           :  std_logic;   
   SIGNAL tx_request               :  std_logic;   
   SIGNAL abort_tx                 :  std_logic;   
   SIGNAL self_rx_request          :  std_logic;   
   SIGNAL single_shot_transmission :  std_logic;   
   SIGNAL tx_state                 :  std_logic;   
   SIGNAL tx_state_q               :  std_logic;   
   SIGNAL overload_request         :  std_logic;   
   SIGNAL overload_frame           :  std_logic;   
   -- Arbitration Lost Capture Register 
   SIGNAL read_arbitration_lost_capture_reg:  std_logic;   
   -- Error Code Capture Register 
   SIGNAL read_error_code_capture_reg     :  std_logic;   
   SIGNAL error_capture_code       :  std_logic_vector(7 DOWNTO 0);   
   -- Bus Timing 0 register 
   SIGNAL baud_r_presc             :  std_logic_vector(5 DOWNTO 0);   
   SIGNAL sync_jump_width          :  std_logic_vector(1 DOWNTO 0);   
   -- Bus Timing 1 register 
   SIGNAL time_segment1            :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL time_segment2            :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL triple_sampling          :  std_logic;   
   -- Error Warning Limit register 
   SIGNAL error_warning_limit      :  std_logic_vector(7 DOWNTO 0);   
   -- Rx Error Counter register 
   SIGNAL we_rx_err_cnt            :  std_logic;   
   -- Tx Error Counter register 
   SIGNAL we_tx_err_cnt            :  std_logic;   
   -- Clock Divider register 
   SIGNAL extended_mode            :  std_logic;   
   -- This section is for BASIC and EXTENDED mode 
   -- Acceptance code register 
   SIGNAL acceptance_code_0        :  std_logic_vector(7 DOWNTO 0);   
   -- Acceptance mask register 
   SIGNAL acceptance_mask_0        :  std_logic_vector(7 DOWNTO 0);   
   -- End: This section is for BASIC and EXTENDED mode 
   -- This section is for EXTENDED mode 
   -- Acceptance code register 
   SIGNAL acceptance_code_1        :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL acceptance_code_2        :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL acceptance_code_3        :  std_logic_vector(7 DOWNTO 0);   
   -- Acceptance mask register 
   SIGNAL acceptance_mask_1        :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL acceptance_mask_2        :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL acceptance_mask_3        :  std_logic_vector(7 DOWNTO 0);   
   -- End: This section is for EXTENDED mode 
   -- Tx data registers. Holding identifier (basic mode), tx frame information (extended mode) and data 
   SIGNAL tx_data_0                :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_1                :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_2                :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_3                :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_4                :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_5                :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_6                :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_7                :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_8                :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_9                :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_10               :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_11               :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_data_12               :  std_logic_vector(7 DOWNTO 0);   
   -- End: Tx data registers 
  
   -- Output signals from can_btl module 
   SIGNAL sample_point             :  std_logic;   
   SIGNAL sampled_bit              :  std_logic;   
   SIGNAL sampled_bit_q            :  std_logic;   
   SIGNAL tx_point                 :  std_logic;   
   SIGNAL hard_sync                :  std_logic;   
   -- output from can_bsp module 
   SIGNAL rx_idle                  :  std_logic;   
   SIGNAL transmitting             :  std_logic;   
   SIGNAL transmitter              :  std_logic;   
   SIGNAL go_rx_inter              :  std_logic;   
   SIGNAL not_first_bit_of_inter   :  std_logic;   
   SIGNAL set_reset_mode           :  std_logic;   
   SIGNAL node_bus_off             :  std_logic;   
   SIGNAL error_status             :  std_logic;   
   SIGNAL rx_err_cnt               :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_err_cnt               :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL rx_err_cnt_dummy         :  std_logic;   --  The MSB is not displayed. It is just used for easier calculation (no counter overflow).
   SIGNAL tx_err_cnt_dummy         :  std_logic;   --  The MSB is not displayed. It is just used for easier calculation (no counter overflow).
   SIGNAL transmit_status          :  std_logic;   
   SIGNAL receive_status           :  std_logic;   
   SIGNAL tx_successful            :  std_logic;   
   SIGNAL need_to_tx               :  std_logic;   
   SIGNAL overrun                  :  std_logic;   
   SIGNAL info_empty               :  std_logic;   
   SIGNAL set_bus_error_irq        :  std_logic;   
   SIGNAL set_arbitration_lost_irq :  std_logic;   
   SIGNAL arbitration_lost_capture :  std_logic_vector(4 DOWNTO 0);   
   SIGNAL node_error_passive       :  std_logic;   
   SIGNAL node_error_active        :  std_logic;   
   SIGNAL rx_message_counter       :  std_logic_vector(6 DOWNTO 0);   
   SIGNAL tx_next                  :  std_logic;   
   SIGNAL go_overload_frame        :  std_logic;   
   SIGNAL go_error_frame           :  std_logic;   
   SIGNAL go_tx                    :  std_logic;   
   SIGNAL send_ack                 :  std_logic;   
   SIGNAL rst                      :  std_logic;   
   SIGNAL we                       :  std_logic;   
   SIGNAL addr                     :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL data_in                  :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL data_out                 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL rx_sync_tmp              :  std_logic;   
   SIGNAL rx_sync                  :  std_logic;  
   
   -- From btl module 
   -- Mode register 
   -- Command register 
   -- Arbitration Lost Capture Register 
   -- Error Code Capture Register 
   -- Error Warning Limit register 
   -- Rx Error Counter register 
   -- Tx Error Counter register 
   -- Clock Divider register 
   -- output from can_bsp module 
   SIGNAL xhdl_148                 :  std_logic_vector(8 DOWNTO 0);   
   -- The MSB is not displayed. It is just used for easier calculation (no counter overflow).
   SIGNAL xhdl_150                 :  std_logic_vector(8 DOWNTO 0);   
   SIGNAL av_dat_o_xhdl1           :  std_logic_vector(7 DOWNTO 0);   

   SIGNAL tx_o_xhdl3               :  std_logic;   
   SIGNAL bus_off_on_xhdl4         :  std_logic;   
   SIGNAL irq_on_xhdl5             :  std_logic;   
   SIGNAL clkout_o_xhdl6           :  std_logic;   
   SIGNAL rx_inter                 :  std_logic;   

BEGIN
   av_dat_o <= av_dat_o_xhdl1;
   tx_o <= tx_o_xhdl3;
   bus_off_on <= bus_off_on_xhdl4;
   irq_on <= irq_on_xhdl5;
   clkout_o <= clkout_o_xhdl6;   
   
   -- Connecting can_registers module -- Mode register -- Command register -- Arbitration Lost Capture Register -- Error Code Capture Register -- Bus Timing 0 register -- Bus Timing 1 register -- Error Warning Limit register -- Rx Error Counter register -- Tx Error Counter register -- Clock Divider register -- This section is for BASIC and EXTENDED mode -- Acceptance code register -- Acceptance mask register -- End: This section is for BASIC and EXTENDED mode -- This section is for EXTENDED mode -- Acceptance code register -- Acceptance mask register -- End: This section is for EXTENDED mode -- Tx data registers. Holding identifier (basic mode), tx frame information (extended mode) and data -- End: Tx data registers 
   i_can_registers : can_vhdl_registers 
      PORT MAP (
         clk => clk_i,
         rst => rst,
         cs => cs,
         we => we,
         addr => addr,
         data_in => data_in,
         data_out => data_out_regs,
         irq_n => irq_on_xhdl5,
         sample_point => sample_point,
         transmitting => transmitting,
         set_reset_mode => set_reset_mode,
         node_bus_off => node_bus_off,
         error_status => error_status,
         rx_err_cnt => rx_err_cnt,
         tx_err_cnt => tx_err_cnt,
         transmit_status => transmit_status,
         receive_status => receive_status,
         tx_successful => tx_successful,
         need_to_tx => need_to_tx,
         overrun => overrun,
         info_empty => info_empty,
         set_bus_error_irq => set_bus_error_irq,
         set_arbitration_lost_irq => set_arbitration_lost_irq,
         arbitration_lost_capture => arbitration_lost_capture,
         node_error_passive => node_error_passive,
         node_error_active => node_error_active,
         rx_message_counter => rx_message_counter,
         reset_mode => reset_mode,
         listen_only_mode => listen_only_mode,
         acceptance_filter_mode => acceptance_filter_mode,
         self_test_mode => self_test_mode,
         clear_data_overrun => open,
         release_buffer => release_buffer,
         abort_tx => abort_tx,
         tx_request => tx_request,
         self_rx_request => self_rx_request,
         single_shot_transmission => single_shot_transmission,
         tx_state => tx_state,
         tx_state_q => tx_state_q,
         overload_request => overload_request,
         overload_frame => overload_frame,
         read_arbitration_lost_capture_reg => read_arbitration_lost_capture_reg,
         read_error_code_capture_reg => read_error_code_capture_reg,
         error_capture_code => error_capture_code,
         baud_r_presc => baud_r_presc,
         sync_jump_width => sync_jump_width,
         time_segment1 => time_segment1,
         time_segment2 => time_segment2,
         triple_sampling => triple_sampling,
         error_warning_limit => error_warning_limit,
         we_rx_err_cnt => we_rx_err_cnt,
         we_tx_err_cnt => we_tx_err_cnt,
         extended_mode => extended_mode,
         clkout => clkout_o_xhdl6,
         acceptance_code_0 => acceptance_code_0,
         acceptance_mask_0 => acceptance_mask_0,
         acceptance_code_1 => acceptance_code_1,
         acceptance_code_2 => acceptance_code_2,
         acceptance_code_3 => acceptance_code_3,
         acceptance_mask_1 => acceptance_mask_1,
         acceptance_mask_2 => acceptance_mask_2,
         acceptance_mask_3 => acceptance_mask_3,
         tx_data_0 => tx_data_0,
         tx_data_1 => tx_data_1,
         tx_data_2 => tx_data_2,
         tx_data_3 => tx_data_3,
         tx_data_4 => tx_data_4,
         tx_data_5 => tx_data_5,
         tx_data_6 => tx_data_6,
         tx_data_7 => tx_data_7,
         tx_data_8 => tx_data_8,
         tx_data_9 => tx_data_9,
         tx_data_10 => tx_data_10,
         tx_data_11 => tx_data_11,
         tx_data_12 => tx_data_12);   
   
   
   -- Connecting can_btl module -- Bus Timing 0 register -- Bus Timing 1 register -- Output signals from this module -- output from can_bsp module 
   i_can_btl : can_vhdl_btl 
      PORT MAP (
         clk => clk_i,
         rst => rst,
         rx => rx_sync,
         tx => tx_o_xhdl3,
         baud_r_presc => baud_r_presc,
         sync_jump_width => sync_jump_width,
         time_segment1 => time_segment1,
         time_segment2 => time_segment2,
         triple_sampling => triple_sampling,
         sample_point => sample_point,
         sampled_bit => sampled_bit,
         sampled_bit_q => sampled_bit_q,
         tx_point => tx_point,
         hard_sync => hard_sync,
         rx_idle => rx_idle,
         rx_inter => rx_inter,
         transmitting => transmitting,
         transmitter => transmitter,
         go_rx_inter => go_rx_inter,
         tx_next => tx_next,
         go_overload_frame => go_overload_frame,
         go_error_frame => go_error_frame,
         go_tx => go_tx,
         send_ack => send_ack,
         node_error_passive => node_error_passive);   
   
   --xhdl_148 <= rx_err_cnt_dummy & rx_err_cnt(7 DOWNTO 0);
   --rx_err_cnt_dummy <= xhdl_148(8);
   --rx_err_cnt(7 DOWNTO 0) <= xhdl_148(7 DOWNTO 0);
   --xhdl_150 <= tx_err_cnt_dummy & tx_err_cnt(7 DOWNTO 0);
   --tx_err_cnt_dummy <= xhdl_150(8);
   --tx_err_cnt(7 DOWNTO 0) <= xhdl_150(7 DOWNTO 0);
   
   i_can_bsp : can_vhdl_bsp 
   
      PORT MAP (
         clk => clk_i,
         rst => rst,
         sample_point => sample_point,
         sampled_bit => sampled_bit,
         sampled_bit_q => sampled_bit_q,
         tx_point => tx_point,
         hard_sync => hard_sync,
         addr => addr,
         data_in => data_in,
         data_out => data_out_fifo,
         fifo_selected => data_out_fifo_selected,
         reset_mode => reset_mode,
         listen_only_mode => listen_only_mode,
         acceptance_filter_mode => acceptance_filter_mode,
         self_test_mode => self_test_mode,
         release_buffer => release_buffer,
         tx_request => tx_request,
         abort_tx => abort_tx,
         self_rx_request => self_rx_request,
         single_shot_transmission => single_shot_transmission,
         tx_state => tx_state,
         tx_state_q => tx_state_q,
         overload_request => overload_request,
         overload_frame => overload_frame,
         read_arbitration_lost_capture_reg => read_arbitration_lost_capture_reg,
         read_error_code_capture_reg => read_error_code_capture_reg,
         error_capture_code => error_capture_code,
         error_warning_limit => error_warning_limit,
         we_rx_err_cnt => we_rx_err_cnt,
         we_tx_err_cnt => we_tx_err_cnt,
         extended_mode => extended_mode,
         rx_idle => rx_idle,
         transmitting => transmitting,
         transmitter => transmitter,
         go_rx_inter => go_rx_inter,
         not_first_bit_of_inter => not_first_bit_of_inter,
         rx_inter => rx_inter,
         set_reset_mode => set_reset_mode,
         node_bus_off => node_bus_off,
         error_status => error_status,
         rx_err_cnt => xhdl_148,
         tx_err_cnt => xhdl_150,
         transmit_status => transmit_status,
         receive_status => receive_status,
         tx_successful => tx_successful,
         need_to_tx => need_to_tx,
         overrun => overrun,
         info_empty => info_empty,
         set_bus_error_irq => set_bus_error_irq,
         set_arbitration_lost_irq => set_arbitration_lost_irq,
         arbitration_lost_capture => arbitration_lost_capture,
         node_error_passive => node_error_passive,
         node_error_active => node_error_active,
         rx_message_counter => rx_message_counter,
         acceptance_code_0 => acceptance_code_0,
         acceptance_mask_0 => acceptance_mask_0,
         acceptance_code_1 => acceptance_code_1,
         acceptance_code_2 => acceptance_code_2,
         acceptance_code_3 => acceptance_code_3,
         acceptance_mask_1 => acceptance_mask_1,
         acceptance_mask_2 => acceptance_mask_2,
         acceptance_mask_3 => acceptance_mask_3,
         tx_data_0 => tx_data_0,
         tx_data_1 => tx_data_1,
         tx_data_2 => tx_data_2,
         tx_data_3 => tx_data_3,
         tx_data_4 => tx_data_4,
         tx_data_5 => tx_data_5,
         tx_data_6 => tx_data_6,
         tx_data_7 => tx_data_7,
         tx_data_8 => tx_data_8,
         tx_data_9 => tx_data_9,
         tx_data_10 => tx_data_10,
         tx_data_11 => tx_data_11,
         tx_data_12 => tx_data_12,
         tx => tx_o_xhdl3,
         tx_next => tx_next,
         bus_off_on => bus_off_on_xhdl4,
         go_overload_frame => go_overload_frame,
         go_error_frame => go_error_frame,
         go_tx => go_tx,
         send_ack => send_ack);

   -- Multiplexing av_dat_o from registers and rx fifo
   
   PROCESS (extended_mode, addr, reset_mode)
      VARIABLE data_out_fifo_selected_xhdl203  : std_logic;
   BEGIN
      IF ((((extended_mode AND (NOT reset_mode)) AND CONV_STD_LOGIC((addr >= "00010000") AND (addr<="00011100"))) OR ((NOT extended_mode) AND CONV_STD_LOGIC((addr >= "00010100") AND (addr<="00011101")))) = '1') THEN
         data_out_fifo_selected_xhdl203 := '1';    
      ELSE
         data_out_fifo_selected_xhdl203 := '0';    
      END IF;
      data_out_fifo_selected <= data_out_fifo_selected_xhdl203;
   END PROCESS;

   PROCESS (clk_i)
   BEGIN
      IF (rising_edge(clk_i)) THEN
         IF ((cs AND (NOT we)) = '1') THEN
            IF (data_out_fifo_selected = '1') THEN
               data_out <= data_out_fifo ;    
            ELSE
               data_out <= data_out_regs ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk_i, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_sync_tmp <= '1';    
         rx_sync <= '1';    
      ELSIF (rising_edge(clk_i)) THEN
         rx_sync_tmp <= rx_i ;    
         rx_sync <= rx_sync_tmp ;    
      END IF;
   END PROCESS;
   cs_can_i <= '1' ;

   rst <= av_rst_i ;
   we <= av_we_i ;
   addr <= av_adr_i(5 downto 0) & "00" ;
   data_in <= av_dat_i ;
   av_dat_o_xhdl1 <= data_out ;
   cs <= av_cs_i;

END ARCHITECTURE RTL;


