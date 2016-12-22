LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY can_vhdl_bsp IS
   PORT (
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      sample_point            : IN std_logic;   
      sampled_bit             : IN std_logic;   
      sampled_bit_q           : IN std_logic;   
      tx_point                : IN std_logic;   
      hard_sync               : IN std_logic;   
      addr                    : IN std_logic_vector(7 DOWNTO 0);   
      data_in                 : IN std_logic_vector(7 DOWNTO 0);   
      data_out                : OUT std_logic_vector(7 DOWNTO 0);   
      fifo_selected           : IN std_logic;   
      reset_mode              : IN std_logic;   
      listen_only_mode        : IN std_logic;   
      acceptance_filter_mode  : IN std_logic;   
      self_test_mode          : IN std_logic;   
      -- Command register 
      release_buffer          : IN std_logic;   
      tx_request              : IN std_logic;   
      abort_tx                : IN std_logic;   
      self_rx_request         : IN std_logic;   
      single_shot_transmission: IN std_logic;   
      tx_state                : OUT std_logic;   
      tx_state_q              : OUT std_logic;   
      overload_request        : IN std_logic;   --  When receiver is busy, it needs to send overload frame. Only 2 overload frames are allowed to
      overload_frame          : OUT std_logic;   --  be send in a row. This is not implemented, yet,  because host can not send an overload request.
      -- Arbitration Lost Capture Register 
      read_arbitration_lost_capture_reg: IN std_logic;   
      -- Error Code Capture Register 
      read_error_code_capture_reg: IN std_logic;   
      error_capture_code      : OUT std_logic_vector(7 DOWNTO 0);   
      -- Error Warning Limit register 
      error_warning_limit     : IN std_logic_vector(7 DOWNTO 0);   
      -- Rx Error Counter register 
      we_rx_err_cnt           : IN std_logic;   
      -- Tx Error Counter register 
      we_tx_err_cnt           : IN std_logic;   
      extended_mode           : IN std_logic;   
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
      -- This section is for BASIC and EXTENDED mode -- Acceptance code register 
      acceptance_code_0       : IN std_logic_vector(7 DOWNTO 0);   
      -- Acceptance mask register 
      acceptance_mask_0       : IN std_logic_vector(7 DOWNTO 0);   
      -- End: This section is for BASIC and EXTENDED mode -- This section is for EXTENDED mode -- Acceptance code register 
      acceptance_code_1       : IN std_logic_vector(7 DOWNTO 0);   
      acceptance_code_2       : IN std_logic_vector(7 DOWNTO 0);   
      acceptance_code_3       : IN std_logic_vector(7 DOWNTO 0);   
      -- Acceptance mask register 
      acceptance_mask_1       : IN std_logic_vector(7 DOWNTO 0);   
      acceptance_mask_2       : IN std_logic_vector(7 DOWNTO 0);   
      acceptance_mask_3       : IN std_logic_vector(7 DOWNTO 0);   
      -- End: This section is for EXTENDED mode -- Tx data registers. Holding identifier (basic mode), tx frame information (extended mode) and data 
      tx_data_0               : IN std_logic_vector(7 DOWNTO 0);   
      tx_data_1               : IN std_logic_vector(7 DOWNTO 0);   
      tx_data_2               : IN std_logic_vector(7 DOWNTO 0);   
      tx_data_3               : IN std_logic_vector(7 DOWNTO 0);   
      tx_data_4               : IN std_logic_vector(7 DOWNTO 0);   
      tx_data_5               : IN std_logic_vector(7 DOWNTO 0);   
      tx_data_6               : IN std_logic_vector(7 DOWNTO 0);   
      tx_data_7               : IN std_logic_vector(7 DOWNTO 0);   
      tx_data_8               : IN std_logic_vector(7 DOWNTO 0);   
      tx_data_9               : IN std_logic_vector(7 DOWNTO 0);   
      tx_data_10              : IN std_logic_vector(7 DOWNTO 0);   
      tx_data_11              : IN std_logic_vector(7 DOWNTO 0);   
      tx_data_12              : IN std_logic_vector(7 DOWNTO 0);   
      -- End: Tx data registers -- Tx signal 
      tx                      : OUT std_logic;   
      tx_next                 : OUT std_logic;   
      bus_off_on              : OUT std_logic;   
      go_overload_frame       : OUT std_logic;   
      go_error_frame          : OUT std_logic;   
      go_tx                   : OUT std_logic;   
      send_ack                : OUT std_logic);   
END ENTITY can_vhdl_bsp;

ARCHITECTURE RTL OF can_vhdl_bsp IS

function conv_std_logic(b : boolean) return std_ulogic is
begin
  if b then return('1'); else return('0'); end if;
end;

function orv(d : std_logic_vector) return std_ulogic is
variable tmp : std_ulogic;
begin
  tmp := '0';
  for i in d'range loop tmp := tmp or d(i); end loop;
  return(tmp);
end;

function andv(d : std_logic_vector) return std_ulogic is
variable tmp : std_ulogic;
begin
  tmp := '1';
  for i in d'range loop tmp := tmp and d(i); end loop;
  return(tmp);
end;

   COMPONENT can_vhdl_acf
      PORT (
         clk                     : IN  std_logic;
         rst                     : IN  std_logic;
         id                      : IN  std_logic_vector(28 DOWNTO 0);
         reset_mode              : IN  std_logic;
         acceptance_filter_mode  : IN  std_logic;
         extended_mode           : IN  std_logic;
         acceptance_code_0       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_code_1       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_code_2       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_code_3       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_mask_0       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_mask_1       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_mask_2       : IN  std_logic_vector(7 DOWNTO 0);
         acceptance_mask_3       : IN  std_logic_vector(7 DOWNTO 0);
         go_rx_crc_lim           : IN  std_logic;
         go_rx_inter             : IN  std_logic;
         go_error_frame          : IN  std_logic;
         data0                   : IN  std_logic_vector(7 DOWNTO 0);
         data1                   : IN  std_logic_vector(7 DOWNTO 0);
         rtr1                    : IN  std_logic;
         rtr2                    : IN  std_logic;
         ide                     : IN  std_logic;
         no_byte0                : IN  std_logic;
         no_byte1                : IN  std_logic;
         id_ok                   : OUT std_logic);
   END COMPONENT;

   COMPONENT can_vhdl_crc
      PORT (
         clk                     : IN  std_logic;
         data                    : IN  std_logic;
         enable                  : IN  std_logic;
         initialize              : IN  std_logic;
         crc                     : OUT std_logic_vector(14 DOWNTO 0));
   END COMPONENT;

   COMPONENT can_vhdl_fifo
      PORT (
         clk                     : IN  std_logic;
         rst                     : IN  std_logic;
         wr                      : IN  std_logic;
         data_in                 : IN  std_logic_vector(7 DOWNTO 0);
         addr                    : IN  std_logic_vector(5 DOWNTO 0);
         data_out                : OUT std_logic_vector(7 DOWNTO 0);
         fifo_selected           : IN  std_logic;
         reset_mode              : IN  std_logic;
         release_buffer          : IN  std_logic;
         extended_mode           : IN  std_logic;
         overrun                 : OUT std_logic;
         info_empty              : OUT std_logic;
         info_cnt                : OUT std_logic_vector(6 DOWNTO 0));
   END COMPONENT;

   COMPONENT can_vhdl_ibo
      PORT (
         di                      : IN  std_logic_vector(7 DOWNTO 0);
         do                      : OUT std_logic_vector(7 DOWNTO 0));
   END COMPONENT;

   TYPE xhdl_46 IS ARRAY (0 TO 7) OF std_logic_vector(7 DOWNTO 0);

   ------------------------------
   SIGNAL reset_mode_q             :  std_logic;   
   SIGNAL bit_cnt                  :  std_logic_vector(5 DOWNTO 0);   
   SIGNAL data_len                 :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL id                       :  std_logic_vector(28 DOWNTO 0);   
   SIGNAL bit_stuff_cnt            :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL bit_stuff_cnt_tx         :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL tx_point_q               :  std_logic;   
   SIGNAL rx_id1                   :  std_logic;   
   SIGNAL rx_rtr1                  :  std_logic;   
   SIGNAL rx_ide                   :  std_logic;   
   SIGNAL rx_id2                   :  std_logic;   
   SIGNAL rx_rtr2                  :  std_logic;   
   SIGNAL rx_r1                    :  std_logic;   
   SIGNAL rx_r0                    :  std_logic;   
   SIGNAL rx_dlc                   :  std_logic;   
   SIGNAL rx_data                  :  std_logic;   
   SIGNAL rx_crc                   :  std_logic;   
   SIGNAL rx_crc_lim               :  std_logic;   
   SIGNAL rx_ack                   :  std_logic;   
   SIGNAL rx_ack_lim               :  std_logic;   
   SIGNAL rx_eof                   :  std_logic;   
   SIGNAL go_early_tx_latched      :  std_logic;   
   SIGNAL rtr1                     :  std_logic;   
   SIGNAL ide                      :  std_logic;   
   SIGNAL rtr2                     :  std_logic;   
   SIGNAL crc_in                   :  std_logic_vector(14 DOWNTO 0);   
   SIGNAL tmp_data                 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tmp_fifo                 :  xhdl_46;   
   SIGNAL write_data_to_tmp_fifo   :  std_logic;   
   SIGNAL byte_cnt                 :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL bit_stuff_cnt_en         :  std_logic;   
   SIGNAL crc_enable               :  std_logic;   
   SIGNAL eof_cnt                  :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL passive_cnt              :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL error_frame              :  std_logic;   
   SIGNAL enable_error_cnt2        :  std_logic;   
   SIGNAL error_cnt1               :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL error_cnt2               :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL delayed_dominant_cnt     :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL enable_overload_cnt2     :  std_logic;   
   SIGNAL overload_frame_blocked   :  std_logic;   
   SIGNAL overload_request_cnt     :  std_logic_vector(1 DOWNTO 0);   
   SIGNAL overload_cnt1            :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL overload_cnt2            :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL crc_err                  :  std_logic;   
   SIGNAL arbitration_lost         :  std_logic;   
   SIGNAL arbitration_lost_q       :  std_logic;   
   SIGNAL arbitration_field_d      :  std_logic;
   signal read_error_code_capture_reg_q : std_logic;
   signal reset_error_code_capture_reg : std_logic;
   SIGNAL arbitration_cnt          :  std_logic_vector(4 downto 0);   
   SIGNAL arbitration_blocked      :  std_logic;   
   SIGNAL tx_q                     :  std_logic;   
   SIGNAL data_cnt                 :  std_logic_vector(3 DOWNTO 0);   --  Counting the data bytes that are written to FIFO
   SIGNAL header_cnt               :  std_logic_vector(2 DOWNTO 0);   --  Counting header length
   SIGNAL wr_fifo                  :  std_logic;   --  Write data and header to 64-byte fifo
   SIGNAL data_for_fifo            :  std_logic_vector(7 DOWNTO 0);   --  Multiplexed data that is stored to 64-byte fifo
   SIGNAL tx_pointer               :  std_logic_vector(5 DOWNTO 0);   
   SIGNAL tx_bit                   :  std_logic;   
   SIGNAL finish_msg               :  std_logic;   
   SIGNAL bus_free_cnt             :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL bus_free_cnt_en          :  std_logic;   
   SIGNAL bus_free                 :  std_logic;   
   SIGNAL waiting_for_bus_free     :  std_logic;   
   SIGNAL node_bus_off_q           :  std_logic;   
   SIGNAL ack_err_latched          :  std_logic;   
   SIGNAL bit_err_latched          :  std_logic;   
   SIGNAL stuff_err_latched        :  std_logic;   
   SIGNAL form_err_latched         :  std_logic;   
   SIGNAL rule3_exc1_1             :  std_logic;   
   SIGNAL rule3_exc1_2             :  std_logic;   
   SIGNAL suspend                  :  std_logic;   
   SIGNAL susp_cnt_en              :  std_logic;   
   SIGNAL susp_cnt                 :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL error_flag_over_latched  :  std_logic;   
   SIGNAL error_capture_code_type  :  std_logic_vector(7 DOWNTO 6);   
   SIGNAL error_capture_code_blocked      :  std_logic;   
   SIGNAL first_compare_bit        :  std_logic;   
   SIGNAL error_capture_code_segment      :  std_logic_vector(4 DOWNTO 0);   
   SIGNAL error_capture_code_direction    :  std_logic;   
   SIGNAL bit_de_stuff             :  std_logic;   
   SIGNAL bit_de_stuff_tx          :  std_logic;   
   SIGNAL rule5                    :  std_logic;   
   -- Rx state machine 
   SIGNAL go_rx_idle               :  std_logic;   
   SIGNAL go_rx_id1                :  std_logic;   
   SIGNAL go_rx_rtr1               :  std_logic;   
   SIGNAL go_rx_ide                :  std_logic;   
   SIGNAL go_rx_id2                :  std_logic;   
   SIGNAL go_rx_rtr2               :  std_logic;   
   SIGNAL go_rx_r1                 :  std_logic;   
   SIGNAL go_rx_r0                 :  std_logic;   
   SIGNAL go_rx_dlc                :  std_logic;   
   SIGNAL go_rx_data               :  std_logic;   
   SIGNAL go_rx_crc                :  std_logic;   
   SIGNAL go_rx_crc_lim            :  std_logic;   
   SIGNAL go_rx_ack                :  std_logic;   
   SIGNAL go_rx_ack_lim            :  std_logic;   
   SIGNAL go_rx_eof                :  std_logic;   
   SIGNAL last_bit_of_inter        :  std_logic;   
   SIGNAL go_crc_enable            :  std_logic;   
   SIGNAL rst_crc_enable           :  std_logic;   
   SIGNAL bit_de_stuff_set         :  std_logic;   
   SIGNAL bit_de_stuff_reset       :  std_logic;   
   SIGNAL go_early_tx              :  std_logic;   
   SIGNAL calculated_crc           :  std_logic_vector(14 DOWNTO 0);   
   SIGNAL r_calculated_crc         :  std_logic_vector(15 DOWNTO 0);   
   SIGNAL remote_rq                :  std_logic;   
   SIGNAL limited_data_len         :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL form_err                 :  std_logic;   
   SIGNAL error_frame_ended        :  std_logic;   
   SIGNAL overload_frame_ended     :  std_logic;   
   SIGNAL bit_err                  :  std_logic;   
   SIGNAL ack_err                  :  std_logic;   
   SIGNAL stuff_err                :  std_logic;   
   SIGNAL id_ok                    :  std_logic;   --  If received ID matches ID set in registers
   SIGNAL no_byte0                 :  std_logic;   --  There is no byte 0 (RTR bit set to 1 or DLC field equal to 0). Signal used for acceptance filter.
   SIGNAL no_byte1                 :  std_logic;   --  There is no byte 1 (RTR bit set to 1 or DLC field equal to 1). Signal used for acceptance filter.
   SIGNAL header_len               :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL storing_header           :  std_logic;   
   SIGNAL limited_data_len_minus1  :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL reset_wr_fifo            :  std_logic;   
   SIGNAL err                      :  std_logic;   
   SIGNAL arbitration_field        :  std_logic;   
   SIGNAL basic_chain              :  std_logic_vector(18 DOWNTO 0);   
   SIGNAL basic_chain_data         :  std_logic_vector(63 DOWNTO 0);   
   SIGNAL extended_chain_std       :  std_logic_vector(18 DOWNTO 0);   
   SIGNAL extended_chain_ext       :  std_logic_vector(38 DOWNTO 0);   
   SIGNAL extended_chain_data_std  :  std_logic_vector(63 DOWNTO 0);   
   SIGNAL extended_chain_data_ext  :  std_logic_vector(63 DOWNTO 0);   
   SIGNAL rst_tx_pointer           :  std_logic;   
   SIGNAL r_tx_data_0              :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL r_tx_data_1              :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL r_tx_data_2              :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL r_tx_data_3              :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL r_tx_data_4              :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL r_tx_data_5              :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL r_tx_data_6              :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL r_tx_data_7              :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL r_tx_data_8              :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL r_tx_data_9              :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL r_tx_data_10             :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL r_tx_data_11             :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL r_tx_data_12             :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL bit_err_exc1             :  std_logic;   
   SIGNAL bit_err_exc2             :  std_logic;   
   SIGNAL bit_err_exc3             :  std_logic;   
   SIGNAL bit_err_exc4             :  std_logic;   
   SIGNAL bit_err_exc5             :  std_logic;   
   SIGNAL bit_err_exc6             :  std_logic;   
   SIGNAL error_flag_over          :  std_logic;   
   SIGNAL overload_flag_over       :  std_logic;   
   SIGNAL limited_tx_cnt_ext       :  std_logic_vector(5 DOWNTO 0);   
   SIGNAL limited_tx_cnt_std       :  std_logic_vector(5 DOWNTO 0);   

   SIGNAL temp_xhdl47              :  std_logic_vector(3 DOWNTO 0);   
-- Instantiation of the RX CRC module
   SIGNAL xhdl_49                  :  std_logic;   
   -- Mode register 
   -- Clock Divider register
   -- This section is for BASIC and EXTENDED mode 
   -- Acceptance code register 
   -- Acceptance mask register 
   -- End: This section is for BASIC and EXTENDED mode 
   -- This section is for EXTENDED mode 
   -- Acceptance code register 
   -- Acceptance mask register 
   -- End: This section is for EXTENDED mode 
   SIGNAL port_xhdl73              :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL port_xhdl74              :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL temp_xhdl75              :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL temp_xhdl76              :  std_logic_vector(2 DOWNTO 0);   
   SIGNAL temp_xhdl77              :  std_logic_vector(3 DOWNTO 0);   
   SIGNAL temp_xhdl78              :  std_logic_vector(3 DOWNTO 0);   --  - 1 because counter counts from 0
   SIGNAL xhdl_106                 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL temp_xhdl108             :  std_logic_vector(5 DOWNTO 0);   
   SIGNAL temp_xhdl109             :  std_logic_vector(5 DOWNTO 0);   
   SIGNAL temp_xhdl110             :  boolean;   
   SIGNAL temp_xhdl111             :  std_logic;   
   SIGNAL data_out_xhdl1           :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL tx_state_xhdl2           :  std_logic;   
   SIGNAL tx_state_q_xhdl3         :  std_logic;   
   SIGNAL overload_frame_xhdl4     :  std_logic;   
   SIGNAL error_capture_code_xhdl5 :  std_logic_vector(7 DOWNTO 0);   
   SIGNAL rx_idle_xhdl6            :  std_logic;   
   SIGNAL transmitting_xhdl7       :  std_logic;   
   SIGNAL transmitter_xhdl8        :  std_logic;   
   SIGNAL go_rx_inter_xhdl9        :  std_logic;   
   SIGNAL not_first_bit_of_inter_xhdl10   :  std_logic;   
   SIGNAL rx_inter_xhdl11          :  std_logic;   
   SIGNAL set_reset_mode_xhdl12    :  std_logic;   
   SIGNAL node_bus_off_xhdl13      :  std_logic;   
   SIGNAL error_status_xhdl14      :  std_logic;   
   SIGNAL rx_err_cnt_xhdl15        :  std_logic_vector(8 DOWNTO 0);   
   SIGNAL tx_err_cnt_xhdl16        :  std_logic_vector(8 DOWNTO 0);   
   SIGNAL transmit_status_xhdl17   :  std_logic;   
   SIGNAL receive_status_xhdl18    :  std_logic;   
   SIGNAL tx_successful_xhdl19     :  std_logic;   
   SIGNAL need_to_tx_xhdl20        :  std_logic;   
   SIGNAL overrun_xhdl21           :  std_logic;   
   SIGNAL info_empty_xhdl22        :  std_logic;   
   SIGNAL set_bus_error_irq_xhdl23 :  std_logic;   
   SIGNAL set_arbitration_lost_irq_xhdl24 :  std_logic;   
   SIGNAL arbitration_lost_capture_xhdl25 :  std_logic_vector(4 DOWNTO 0);   
   SIGNAL node_error_passive_xhdl26:  std_logic;   
   SIGNAL node_error_active_xhdl27 :  std_logic;   
   SIGNAL rx_message_counter_xhdl28:  std_logic_vector(6 DOWNTO 0);   
   SIGNAL tx_xhdl29                :  std_logic;   
   SIGNAL tx_next_xhdl30           :  std_logic;   
   SIGNAL bus_off_on_xhdl31        :  std_logic;   
   SIGNAL go_overload_frame_xhdl32 :  std_logic;   
   SIGNAL go_error_frame_xhdl33    :  std_logic;   
   SIGNAL go_tx_xhdl34             :  std_logic;   
   SIGNAL send_ack_xhdl35          :  std_logic;   
 

BEGIN
   data_out <= data_out_xhdl1;
   tx_state <= tx_state_xhdl2;
   tx_state_q <= tx_state_q_xhdl3;
   overload_frame <= overload_frame_xhdl4;
   error_capture_code <= error_capture_code_xhdl5;
   rx_idle <= rx_idle_xhdl6;
   transmitting <= transmitting_xhdl7;
   transmitter <= transmitter_xhdl8;
   go_rx_inter <= go_rx_inter_xhdl9;
   not_first_bit_of_inter <= not_first_bit_of_inter_xhdl10;
   rx_inter <= rx_inter_xhdl11;
   set_reset_mode <= set_reset_mode_xhdl12;
   node_bus_off <= node_bus_off_xhdl13;
   error_status <= error_status_xhdl14;
   rx_err_cnt <= rx_err_cnt_xhdl15;
   tx_err_cnt <= tx_err_cnt_xhdl16;
   transmit_status <= transmit_status_xhdl17;
   receive_status <= receive_status_xhdl18;
   tx_successful <= tx_successful_xhdl19;
   need_to_tx <= need_to_tx_xhdl20;
   overrun <= overrun_xhdl21;
   info_empty <= info_empty_xhdl22;
   set_bus_error_irq <= set_bus_error_irq_xhdl23;
   set_arbitration_lost_irq <= set_arbitration_lost_irq_xhdl24;
   arbitration_lost_capture <= arbitration_lost_capture_xhdl25;
   node_error_passive <= node_error_passive_xhdl26;
   node_error_active <= node_error_active_xhdl27;
   rx_message_counter <= rx_message_counter_xhdl28;
   tx <= tx_xhdl29;
   tx_next <= tx_next_xhdl30;
   bus_off_on <= bus_off_on_xhdl31;
   go_overload_frame <= go_overload_frame_xhdl32;
   go_error_frame <= go_error_frame_xhdl33;
   go_tx <= go_tx_xhdl34;
   send_ack <= send_ack_xhdl35;	
   
   -- ----------------------
   go_rx_idle <= ((sample_point AND sampled_bit) AND last_bit_of_inter) OR (bus_free AND (NOT node_bus_off_xhdl13)) ;
   go_rx_id1 <= (sample_point AND (NOT sampled_bit)) AND (rx_idle_xhdl6 OR last_bit_of_inter) ;
   go_rx_rtr1 <= (((NOT bit_de_stuff) AND sample_point) AND rx_id1) AND CONV_STD_LOGIC(bit_cnt(3 DOWNTO 0) = "1010") ;
   go_rx_ide <= ((NOT bit_de_stuff) AND sample_point) AND rx_rtr1 ;
   go_rx_id2 <= (((NOT bit_de_stuff) AND sample_point) AND rx_ide) AND sampled_bit ;
   go_rx_rtr2 <= (((NOT bit_de_stuff) AND sample_point) AND rx_id2) AND CONV_STD_LOGIC(bit_cnt(4 DOWNTO 0) = "10001") ;
   go_rx_r1 <= ((NOT bit_de_stuff) AND sample_point) AND rx_rtr2 ;
   go_rx_r0 <= ((NOT bit_de_stuff) AND sample_point) AND ((rx_ide AND (NOT sampled_bit)) OR rx_r1) ;
   go_rx_dlc <= ((NOT bit_de_stuff) AND sample_point) AND rx_r0 ;
   go_rx_data <= (((((NOT bit_de_stuff) AND sample_point) AND rx_dlc) AND CONV_STD_LOGIC(bit_cnt(1 DOWNTO 0) = "11")) AND (sampled_bit OR (orv(data_len(2 DOWNTO 0))))) AND (NOT remote_rq) ;
   go_rx_crc <= ((NOT bit_de_stuff) AND sample_point) AND (((rx_dlc AND CONV_STD_LOGIC(bit_cnt(1 DOWNTO 0) = "11")) AND (((NOT sampled_bit) AND (NOT (orv(data_len(2 DOWNTO 0))))) OR remote_rq)) OR (rx_data AND CONV_STD_LOGIC('0' & bit_cnt(5 DOWNTO 0) = ((limited_data_len & "000") - 1)))) ;
   go_rx_crc_lim <= (((NOT bit_de_stuff) AND sample_point) AND rx_crc) AND CONV_STD_LOGIC(bit_cnt(3 DOWNTO 0) = "1110") ;
   go_rx_ack <= ((NOT bit_de_stuff) AND sample_point) AND rx_crc_lim ;
   go_rx_ack_lim <= sample_point AND rx_ack ;
   go_rx_eof <= sample_point AND rx_ack_lim ;
   go_rx_inter_xhdl9 <= (((sample_point AND rx_eof) AND CONV_STD_LOGIC(eof_cnt = "110")) OR error_frame_ended OR overload_frame_ended) AND (NOT overload_request) ;
   go_error_frame_xhdl33 <= form_err OR stuff_err OR bit_err OR ack_err OR (crc_err AND go_rx_eof) ;
   error_frame_ended <= CONV_STD_LOGIC(error_cnt2 = "111") AND tx_point ;
   overload_frame_ended <= CONV_STD_LOGIC(overload_cnt2 = "111") AND tx_point ;
   go_overload_frame_xhdl32 <= (((sample_point AND ((NOT sampled_bit) OR overload_request)) AND (((rx_eof AND (NOT transmitter_xhdl8)) AND CONV_STD_LOGIC(eof_cnt = "110")) OR error_frame_ended OR overload_frame_ended)) OR (((sample_point AND (NOT sampled_bit)) AND rx_inter_xhdl11) AND CONV_STD_LOGIC(bit_cnt(1 DOWNTO 0) < "10")) OR ((sample_point AND (NOT sampled_bit)) AND CONV_STD_LOGIC((error_cnt2 = "111") OR (overload_cnt2 = "111")))) AND (NOT overload_frame_blocked) ;
   go_crc_enable <= hard_sync OR go_tx_xhdl34 ;
   rst_crc_enable <= go_rx_crc ;
   bit_de_stuff_set <= go_rx_id1 AND (NOT go_error_frame_xhdl33) ;
   bit_de_stuff_reset <= go_rx_ack OR go_error_frame_xhdl33 OR go_overload_frame_xhdl32 ;
   remote_rq <= ((NOT ide) AND rtr1) OR (ide AND rtr2) ;
   temp_xhdl47 <= data_len WHEN (data_len < "1000") ELSE "1000";
   limited_data_len <= temp_xhdl47 ;
   ack_err <= (((rx_ack AND sample_point) AND sampled_bit) AND tx_state_xhdl2) AND (NOT self_test_mode) ;
   bit_err <= ((((((((tx_state_xhdl2 OR error_frame OR overload_frame_xhdl4 OR rx_ack) AND sample_point) AND CONV_STD_LOGIC(tx_xhdl29 /= sampled_bit)) AND (NOT bit_err_exc1)) AND (NOT bit_err_exc2)) AND (NOT bit_err_exc3)) AND (NOT bit_err_exc4)) AND (NOT bit_err_exc5)) AND (NOT bit_err_exc6) AND (NOT reset_mode);
   bit_err_exc1 <= (tx_state_xhdl2 AND arbitration_field) AND tx_xhdl29 ;
   bit_err_exc2 <= rx_ack AND tx_xhdl29 ;
   bit_err_exc3 <= (error_frame AND node_error_passive_xhdl26) AND CONV_STD_LOGIC(error_cnt1 < "111") ;
   bit_err_exc4 <= ((error_frame AND CONV_STD_LOGIC(error_cnt1 = "111")) AND (NOT enable_error_cnt2)) OR ((overload_frame_xhdl4 AND CONV_STD_LOGIC(overload_cnt1 = "111")) AND (NOT enable_overload_cnt2)) ;
   bit_err_exc5 <= (error_frame AND CONV_STD_LOGIC(error_cnt2 = "111")) OR (overload_frame_xhdl4 AND CONV_STD_LOGIC(overload_cnt2 = "111")) ;
   bit_err_exc6 <= (CONV_STD_LOGIC(eof_cnt = "110") AND rx_eof) AND (NOT transmitter_xhdl8) ;
   arbitration_field <= rx_id1 OR rx_rtr1 OR rx_ide OR rx_id2 OR rx_rtr2 ;
   last_bit_of_inter <= rx_inter_xhdl11 AND CONV_STD_LOGIC(bit_cnt(1 DOWNTO 0) = "10") ;
   not_first_bit_of_inter_xhdl10 <= rx_inter_xhdl11 AND CONV_STD_LOGIC(bit_cnt(1 DOWNTO 0) /= "00") ;

   -- Rx idle state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_idle_xhdl6 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_id1 OR go_error_frame_xhdl33) = '1') THEN
            rx_idle_xhdl6 <= '0' ;    
         ELSE
            IF (go_rx_idle = '1') THEN
               rx_idle_xhdl6 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx id1 state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_id1 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_rtr1 OR go_error_frame_xhdl33) = '1') THEN
            rx_id1 <= '0' ;    
         ELSE
            IF (go_rx_id1 = '1') THEN
               rx_id1 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx rtr1 state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_rtr1 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_ide OR go_error_frame_xhdl33) = '1') THEN
            rx_rtr1 <= '0' ;    
         ELSE
            IF (go_rx_rtr1 = '1') THEN
               rx_rtr1 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx ide state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_ide <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_r0 OR go_rx_id2 OR go_error_frame_xhdl33) = '1') THEN
            rx_ide <= '0' ;    
         ELSE
            IF (go_rx_ide = '1') THEN
               rx_ide <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx id2 state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_id2 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_rtr2 OR go_error_frame_xhdl33) = '1') THEN
            rx_id2 <= '0' ;    
         ELSE
            IF (go_rx_id2 = '1') THEN
               rx_id2 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx rtr2 state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_rtr2 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_r1 OR go_error_frame_xhdl33) = '1') THEN
            rx_rtr2 <= '0' ;    
         ELSE
            IF (go_rx_rtr2 = '1') THEN
               rx_rtr2 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx r0 state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_r1 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_r0 OR go_error_frame_xhdl33) = '1') THEN
            rx_r1 <= '0' ;    
         ELSE
            IF (go_rx_r1 = '1') THEN
               rx_r1 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx r0 state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_r0 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_dlc OR go_error_frame_xhdl33) = '1') THEN
            rx_r0 <= '0' ;    
         ELSE
            IF (go_rx_r0 = '1') THEN
               rx_r0 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx dlc state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_dlc <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_data OR go_rx_crc OR go_error_frame_xhdl33) = '1') THEN
            rx_dlc <= '0' ;    
         ELSE
            IF (go_rx_dlc = '1') THEN
               rx_dlc <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx data state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_data <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_crc OR go_error_frame_xhdl33) = '1') THEN
            rx_data <= '0' ;    
         ELSE
            IF (go_rx_data = '1') THEN
               rx_data <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx crc state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_crc <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_crc_lim OR go_error_frame_xhdl33) = '1') THEN
            rx_crc <= '0' ;    
         ELSE
            IF (go_rx_crc = '1') THEN
               rx_crc <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx crc delimiter state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_crc_lim <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_ack OR go_error_frame_xhdl33) = '1') THEN
            rx_crc_lim <= '0' ;    
         ELSE
            IF (go_rx_crc_lim = '1') THEN
               rx_crc_lim <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx ack state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_ack <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_ack_lim OR go_error_frame_xhdl33) = '1') THEN
            rx_ack <= '0' ;    
         ELSE
            IF (go_rx_ack = '1') THEN
               rx_ack <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx ack delimiter state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_ack_lim <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_eof OR go_error_frame_xhdl33) = '1') THEN
            rx_ack_lim <= '0' ;    
         ELSE
            IF (go_rx_ack_lim = '1') THEN
               rx_ack_lim <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rx eof state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_eof <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_inter_xhdl9 OR go_error_frame_xhdl33 OR go_overload_frame_xhdl32) = '1') THEN
            rx_eof <= '0' ;    
         ELSE
            IF (go_rx_eof = '1') THEN
               rx_eof <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Interframe space
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_inter_xhdl11 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_idle OR go_rx_id1 OR go_overload_frame_xhdl32 OR go_error_frame_xhdl33) = '1') THEN
            rx_inter_xhdl11 <= '0' ;    
         ELSE
            IF (go_rx_inter_xhdl9 = '1') THEN
               rx_inter_xhdl11 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- ID register
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         id <= "00000000000000000000000000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (((sample_point AND (rx_id1 OR rx_id2)) AND (NOT bit_de_stuff)) = '1') THEN
               id <= id(27 DOWNTO 0) & sampled_bit ;    
         END IF;
      END IF;
   END PROCESS;

   -- rtr1 bit
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rtr1 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (((sample_point AND rx_rtr1) AND (NOT bit_de_stuff)) = '1') THEN
            rtr1 <= sampled_bit ;    
         END IF;
      END IF;
   END PROCESS;

   -- rtr2 bit
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rtr2 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (((sample_point AND rx_rtr2) AND (NOT bit_de_stuff)) = '1') THEN
            rtr2 <= sampled_bit ;    
         END IF;
      END IF;
   END PROCESS;

   -- ide bit
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         ide <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (((sample_point AND rx_ide) AND (NOT bit_de_stuff)) = '1') THEN
            ide <= sampled_bit ;    
         END IF;
      END IF;
   END PROCESS;

   -- Data length
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         data_len <= "0000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (((sample_point AND rx_dlc) AND (NOT bit_de_stuff)) = '1') THEN
            data_len <= data_len(2 DOWNTO 0) & sampled_bit ;    
         END IF;
      END IF;
   END PROCESS;

   -- Data
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         tmp_data <= "00000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
            IF (((sample_point AND rx_data) AND (NOT bit_de_stuff)) = '1') THEN
               tmp_data <= tmp_data(6 DOWNTO 0) & sampled_bit ;    
            END IF;
       END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         write_data_to_tmp_fifo <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
            IF ((((sample_point AND rx_data) AND (NOT bit_de_stuff)) AND (andv(bit_cnt(2 DOWNTO 0)))) = '1') THEN
               write_data_to_tmp_fifo <= '1' ;    
            ELSE
               write_data_to_tmp_fifo <= '0' ;    
            END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         byte_cnt <= "000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
            IF (write_data_to_tmp_fifo = '1') THEN
               byte_cnt <= byte_cnt + "001" ;    
            ELSE
               IF ((sample_point AND go_rx_crc_lim) = '1') THEN
                  byte_cnt <= "000" ;    
               END IF;
            END IF;
      END IF;
   END PROCESS;

   PROCESS (clk)
   BEGIN
      IF (clk'EVENT AND clk = '1') THEN
         IF (write_data_to_tmp_fifo = '1') THEN
            tmp_fifo(conv_integer(byte_cnt)) <= tmp_data ;    
         END IF;
      END IF;
   END PROCESS;

   -- CRC
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         crc_in <= "000000000000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
            IF (((sample_point AND rx_crc) AND (NOT bit_de_stuff)) = '1') THEN
               crc_in <= crc_in(13 DOWNTO 0) & sampled_bit ;    
            END IF;
      END IF;
   END PROCESS;

   -- bit_cnt
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         bit_cnt <= "000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
            IF ((go_rx_id1 OR go_rx_id2 OR go_rx_dlc OR go_rx_data OR go_rx_crc OR go_rx_ack OR go_rx_eof OR go_rx_inter_xhdl9 OR go_error_frame_xhdl33 OR go_overload_frame_xhdl32) = '1') THEN
               bit_cnt <= "000000" ;    
            ELSE
               IF ((sample_point AND (NOT bit_de_stuff)) = '1') THEN
                  bit_cnt <= bit_cnt + "000001" ;    
               END IF;
         END IF;
      END IF;
   END PROCESS;

   -- eof_cnt
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         eof_cnt <= "000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
            IF (sample_point = '1') THEN
               IF ((go_rx_inter_xhdl9 OR go_error_frame_xhdl33 OR go_overload_frame_xhdl32) = '1') THEN
                  eof_cnt <= "000" ;    
               ELSE
                  IF (rx_eof = '1') THEN
                     eof_cnt <= eof_cnt + "001" ;    
                  END IF;
               END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Enabling bit de-stuffing
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         bit_stuff_cnt_en <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
            IF (bit_de_stuff_set = '1') THEN
               bit_stuff_cnt_en <= '1' ;    
            ELSE
               IF (bit_de_stuff_reset = '1') THEN
                  bit_stuff_cnt_en <= '0' ;    
               END IF;
         END IF;
      END IF;
   END PROCESS;

   -- bit_stuff_cnt
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         bit_stuff_cnt <= "001";    
      ELSIF (clk'EVENT AND clk = '1') THEN
            IF (bit_de_stuff_reset = '1') THEN
               bit_stuff_cnt <= "001" ;    
            ELSE
               IF ((sample_point AND bit_stuff_cnt_en) = '1') THEN
                  IF (bit_stuff_cnt = "101") THEN
                     bit_stuff_cnt <= "001" ;    
                  ELSE
                     IF (sampled_bit = sampled_bit_q) THEN
                        bit_stuff_cnt <= bit_stuff_cnt + "001" ;    
                     ELSE
                        bit_stuff_cnt <= "001" ;    
                     END IF;
                  END IF;
               END IF;
         END IF;
      END IF;
   END PROCESS;

   -- bit_stuff_cnt_tx
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         bit_stuff_cnt_tx <= "001";    
      ELSIF (clk'EVENT AND clk = '1') THEN
            IF ((reset_mode = '1') or (bit_de_stuff_reset = '1')) THEN
               bit_stuff_cnt_tx <= "001" ;    
            ELSE
               IF ((tx_point_q AND bit_stuff_cnt_en) = '1') THEN
                  IF (bit_stuff_cnt_tx = "101") THEN
                     bit_stuff_cnt_tx <= "001" ;    
                  ELSE
                     IF (tx_xhdl29 = tx_q) THEN
                        bit_stuff_cnt_tx <= bit_stuff_cnt_tx + "001" ;    
                     ELSE
                        bit_stuff_cnt_tx <= "001" ;    
                     END IF;
                  END IF;
               END IF;
         END IF;
      END IF;
   END PROCESS;
   bit_de_stuff <= CONV_STD_LOGIC(bit_stuff_cnt = "101") ;
   bit_de_stuff_tx <= CONV_STD_LOGIC(bit_stuff_cnt_tx = "101") ;
   -- stuff_err
   stuff_err <= ((sample_point AND bit_stuff_cnt_en) AND bit_de_stuff) AND CONV_STD_LOGIC(sampled_bit = sampled_bit_q) ;

   -- Generating delayed signals
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         reset_mode_q <= '0' ;    
         node_bus_off_q <= '0' ;    
      ELSIF (clk'EVENT AND clk = '1') THEN
         reset_mode_q <= reset_mode ;    
         node_bus_off_q <= node_bus_off_xhdl13 ;    
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         crc_enable <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (rst_crc_enable = '1') THEN
            crc_enable <= '0' ;    
         ELSE
            IF (go_crc_enable = '1') THEN
               crc_enable <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- CRC error generation
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         crc_err <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((reset_mode OR error_frame_ended) = '1') THEN
            crc_err <= '0' ;    
         ELSE
            IF (go_rx_ack = '1') THEN
               crc_err <= CONV_STD_LOGIC(crc_in /= calculated_crc) ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   -- Conditions for form error
   form_err <= sample_point AND ((((NOT bit_de_stuff) AND rx_crc_lim) AND (NOT sampled_bit)) OR (rx_ack_lim AND (NOT sampled_bit)) OR (((CONV_STD_LOGIC(eof_cnt < "110") AND rx_eof) AND (NOT sampled_bit)) AND (NOT transmitter_xhdl8)) OR (((rx_eof) AND (NOT sampled_bit)) AND transmitter_xhdl8)) ;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         ack_err_latched <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((reset_mode OR error_frame_ended OR go_overload_frame_xhdl32) = '1') THEN
            ack_err_latched <= '0' ;    
         ELSE
            IF (ack_err = '1') THEN
               ack_err_latched <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         bit_err_latched <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((reset_mode OR error_frame_ended OR go_overload_frame_xhdl32) = '1') THEN
            bit_err_latched <= '0' ;    
         ELSE
            IF (bit_err = '1') THEN
               bit_err_latched <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   -- Rule 5 (Fault confinement).
   rule5 <= bit_err AND ((((NOT node_error_passive_xhdl26) AND error_frame) AND CONV_STD_LOGIC(error_cnt1 < "111")) OR (overload_frame_xhdl4 AND CONV_STD_LOGIC(overload_cnt1 < "111"))) ;

   -- Rule 3 exception 1 - first part (Fault confinement).
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rule3_exc1_1 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((error_flag_over OR rule3_exc1_2) = '1') THEN
            rule3_exc1_1 <= '0' ;    
         ELSE
            IF (((transmitter_xhdl8 AND node_error_passive_xhdl26) AND ack_err) = '1') THEN
               rule3_exc1_1 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Rule 3 exception 1 - second part (Fault confinement).
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rule3_exc1_2 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_error_frame_xhdl33 OR rule3_exc1_2) = '1') THEN
            rule3_exc1_2 <= '0' ;    
         ELSE
            IF ((((rule3_exc1_1 AND CONV_STD_LOGIC(error_cnt1 < "111")) AND sample_point) AND (NOT sampled_bit)) = '1') THEN
               rule3_exc1_2 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         stuff_err_latched <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((reset_mode OR error_frame_ended OR go_overload_frame_xhdl32) = '1') THEN
            stuff_err_latched <= '0' ;    
         ELSE
            IF (stuff_err = '1') THEN
               stuff_err_latched <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         form_err_latched <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((reset_mode OR error_frame_ended OR go_overload_frame_xhdl32) = '1') THEN
            form_err_latched <= '0' ;    
         ELSE
            IF (form_err = '1') THEN
               form_err_latched <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   xhdl_49 <= ((crc_enable AND sample_point) AND (NOT bit_de_stuff));
   i_can_crc_rx : can_vhdl_crc 
      PORT MAP (
         clk => clk,
         data => sampled_bit,
         enable => xhdl_49,
         initialize => go_crc_enable,
         crc => calculated_crc);   
   
   no_byte0 <= rtr1 OR CONV_STD_LOGIC(data_len < "0001") ;
   no_byte1 <= rtr1 OR CONV_STD_LOGIC(data_len < "0010") ;
   port_xhdl73 <= tmp_fifo(0);
   port_xhdl74 <= tmp_fifo(1);
   i_can_acf : can_vhdl_acf 
      PORT MAP (
         clk => clk,
         rst => rst,
         id => id,
         reset_mode => reset_mode,
         acceptance_filter_mode => acceptance_filter_mode,
         extended_mode => extended_mode,
         acceptance_code_0 => acceptance_code_0,
         acceptance_mask_0 => acceptance_mask_0,
         acceptance_code_1 => acceptance_code_1,
         acceptance_code_2 => acceptance_code_2,
         acceptance_code_3 => acceptance_code_3,
         acceptance_mask_1 => acceptance_mask_1,
         acceptance_mask_2 => acceptance_mask_2,
         acceptance_mask_3 => acceptance_mask_3,
         go_rx_crc_lim => go_rx_crc_lim,
         go_rx_inter => go_rx_inter_xhdl9,
         go_error_frame => go_error_frame_xhdl33,
         data0 => port_xhdl73,
         data1 => port_xhdl74,
         rtr1 => rtr1,
         rtr2 => rtr2,
         ide => ide,
         no_byte0 => no_byte0,
         no_byte1 => no_byte1,
         id_ok => id_ok);   
   
   temp_xhdl75 <= "101" WHEN ide = '1' ELSE "011";
   temp_xhdl76 <= (temp_xhdl75) WHEN extended_mode = '1' ELSE "010";
   header_len(2 DOWNTO 0) <= temp_xhdl76 ;
   storing_header <= CONV_STD_LOGIC(header_cnt < header_len) ;
   temp_xhdl77 <= (data_len - "0001") WHEN (data_len < "1000") ELSE "0111";
   temp_xhdl78 <= "1111" WHEN remote_rq = '1' ELSE (temp_xhdl77);
   limited_data_len_minus1(3 DOWNTO 0) <= temp_xhdl78 ;
   reset_wr_fifo <= CONV_STD_LOGIC(data_cnt = (limited_data_len_minus1 + ('0' & header_len))) OR reset_mode ;
   err <= form_err OR stuff_err OR bit_err OR ack_err OR form_err_latched OR stuff_err_latched OR bit_err_latched OR ack_err_latched OR crc_err ;

   -- Write enable signal for 64-byte rx fifo
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         wr_fifo <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (reset_wr_fifo = '1') THEN
            wr_fifo <= '0' ;    
         ELSE
            IF ((((go_rx_inter_xhdl9 AND id_ok) AND (NOT error_frame_ended)) AND ((NOT tx_state_xhdl2) OR self_rx_request)) = '1') THEN
               wr_fifo <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Header counter. Header length depends on the mode of operation and frame format.
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         header_cnt <= "000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (reset_wr_fifo = '1') THEN
            header_cnt <= "000" ;    
         ELSE
            IF ((wr_fifo AND storing_header) = '1') THEN
               header_cnt <= header_cnt + "001" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Data counter. Length of the data is limited to 8 bytes.
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         data_cnt <= "0000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (reset_wr_fifo = '1') THEN
            data_cnt <= "0000" ;    
         ELSE
            IF (wr_fifo = '1') THEN
               data_cnt <= data_cnt + "0001" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Multiplexing data that is stored to 64-byte fifo depends on the mode of operation and frame format
   
   PROCESS (extended_mode, ide, data_cnt, header_cnt, header_len, storing_header, id, rtr1, rtr2, data_len, tmp_fifo)
      VARIABLE data_for_fifo_xhdl79  : std_logic_vector(7 DOWNTO 0);
      VARIABLE temp_xhdl80  : std_logic_vector(5 DOWNTO 0);
   BEGIN
      temp_xhdl80 := storing_header & extended_mode & ide & header_cnt;
      IF (temp_xhdl80 = "111000") THEN 
               data_for_fifo_xhdl79 := '1' & rtr2 & "00" & data_len;    --  extended mode, extended format header
      ELSIF (temp_xhdl80 = "111001") THEN 
               data_for_fifo_xhdl79 := id(28 DOWNTO 21);    --  extended mode, extended format header
      ELSIF (temp_xhdl80 = "111010") THEN 
               data_for_fifo_xhdl79 := id(20 DOWNTO 13);    --  extended mode, extended format header
      ELSIF (temp_xhdl80 = "111011") THEN 
               data_for_fifo_xhdl79 := id(12 DOWNTO 5);    --  extended mode, extended format header
      ELSIF (temp_xhdl80 = "111100") THEN 
               data_for_fifo_xhdl79 := id(4 DOWNTO 0) & rtr2 & "00";    --  extended mode, extended format header
      ELSIF (temp_xhdl80 = "110000") THEN 
               data_for_fifo_xhdl79 := '0' & rtr1 & "00" & data_len;    --  extended mode, standard format header
      ELSIF (temp_xhdl80 = "110001") THEN 
               data_for_fifo_xhdl79 := id(10 DOWNTO 3);    --  extended mode, standard format header
      ELSIF (temp_xhdl80 = "110010") THEN 
               data_for_fifo_xhdl79 := id(2 DOWNTO 0) & rtr1 & "0000";    --  extended mode, standard format header
      ELSIF (temp_xhdl80 = "10-000") THEN 
               data_for_fifo_xhdl79 := id(10 DOWNTO 3);    --  normal mode                    header
      ELSIF (temp_xhdl80 = "10-001") THEN 
               data_for_fifo_xhdl79 := id(2 DOWNTO 0) & rtr1 & data_len;    --  normal mode                    header
      ELSE
               data_for_fifo_xhdl79 := tmp_fifo(conv_integer(data_cnt - ('0' & header_len)) mod 8);    --  data 
      
      END IF;
      data_for_fifo <= data_for_fifo_xhdl79;
   END PROCESS;
   
   -- Instantiation of the RX fifo module
   -- port connections for Ram
   --64x8
   --64x4
   --64x1
   i_can_fifo : can_vhdl_fifo 
      PORT MAP (
         clk => clk,
         rst => rst,
         wr => wr_fifo,
         data_in => data_for_fifo,
         addr => addr(5 DOWNTO 0),
         data_out => data_out_xhdl1,
         fifo_selected => fifo_selected,
         reset_mode => reset_mode,
         release_buffer => release_buffer,
         extended_mode => extended_mode,
         overrun => overrun_xhdl21,
         info_empty => info_empty_xhdl22,
         info_cnt => rx_message_counter_xhdl28);   
   

   -- Transmitting error frame.
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         error_frame <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((set_reset_mode_xhdl12 OR error_frame_ended OR go_overload_frame_xhdl32) = '1') THEN
            error_frame <= '0' ;    
         ELSE
            IF (go_error_frame_xhdl33 = '1') THEN
               error_frame <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         error_cnt1 <= "000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((error_frame_ended OR go_error_frame_xhdl33 OR go_overload_frame_xhdl32) = '1') THEN
            error_cnt1 <= "000" ;    
         ELSE
            IF (((error_frame AND tx_point) AND CONV_STD_LOGIC(error_cnt1 < "111")) = '1') THEN
               error_cnt1 <= error_cnt1 + "001" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   error_flag_over <= ((((NOT node_error_passive_xhdl26) AND sample_point) AND CONV_STD_LOGIC(error_cnt1 = "111")) OR ((node_error_passive_xhdl26 AND sample_point) AND CONV_STD_LOGIC(passive_cnt = "110"))) AND (NOT enable_error_cnt2) ;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         error_flag_over_latched <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((error_frame_ended OR go_error_frame_xhdl33 OR go_overload_frame_xhdl32) = '1') THEN
            error_flag_over_latched <= '0' ;    
         ELSE
            IF (error_flag_over = '1') THEN
               error_flag_over_latched <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         enable_error_cnt2 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((error_frame_ended OR go_error_frame_xhdl33 OR go_overload_frame_xhdl32) = '1') THEN
            enable_error_cnt2 <= '0' ;    
         ELSE
            IF ((error_frame AND (error_flag_over AND sampled_bit)) = '1') THEN
               enable_error_cnt2 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         error_cnt2 <= "000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((error_frame_ended OR go_error_frame_xhdl33 OR go_overload_frame_xhdl32) = '1') THEN
            error_cnt2 <= "000" ;    
         ELSE
            IF ((enable_error_cnt2 AND tx_point) = '1') THEN
               error_cnt2 <= error_cnt2 + "001" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         delayed_dominant_cnt <= "000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((enable_error_cnt2 OR go_error_frame_xhdl33 OR enable_overload_cnt2 OR go_overload_frame_xhdl32) = '1') THEN
            delayed_dominant_cnt <= "000" ;    
         ELSE
            IF (((sample_point AND (NOT sampled_bit)) AND CONV_STD_LOGIC((error_cnt1 = "111") OR (overload_cnt1 = "111"))) = '1') THEN
               delayed_dominant_cnt <= delayed_dominant_cnt + "001" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- passive_cnt
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         passive_cnt <= "001";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((error_frame_ended OR go_error_frame_xhdl33 OR go_overload_frame_xhdl32 OR first_compare_bit) = '1') THEN
            passive_cnt <= "001" ;    
         ELSE
            IF ((sample_point AND CONV_STD_LOGIC(passive_cnt < "110")) = '1') THEN
               IF (((error_frame AND (NOT enable_error_cnt2)) AND CONV_STD_LOGIC(sampled_bit = sampled_bit_q)) = '1') THEN
                  passive_cnt <= passive_cnt + "001" ;    
               ELSE
                  passive_cnt <= "001" ;    
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- When comparing 6 equal bits, first is always equal
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         first_compare_bit <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (go_error_frame_xhdl33 = '1') THEN
            first_compare_bit <= '1' ;    
         ELSE
            IF (sample_point = '1') THEN
               first_compare_bit <= '0';    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Transmitting overload frame.
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         overload_frame_xhdl4 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((overload_frame_ended OR go_error_frame_xhdl33) = '1') THEN
            overload_frame_xhdl4 <= '0' ;    
         ELSE
            IF (go_overload_frame_xhdl32 = '1') THEN
               overload_frame_xhdl4 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         overload_cnt1 <= "000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((overload_frame_ended OR go_error_frame_xhdl33 OR go_overload_frame_xhdl32) = '1') THEN
            overload_cnt1 <= "000" ;    
         ELSE
            IF (((overload_frame_xhdl4 AND tx_point) AND CONV_STD_LOGIC(overload_cnt1 < "111")) = '1') THEN
               overload_cnt1 <= overload_cnt1 + "001" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   overload_flag_over <= (sample_point AND CONV_STD_LOGIC(overload_cnt1 = "111")) AND (NOT enable_overload_cnt2) ;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         enable_overload_cnt2 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((overload_frame_ended OR go_error_frame_xhdl33 OR go_overload_frame_xhdl32) = '1') THEN
            enable_overload_cnt2 <= '0' ;    
         ELSE
            IF ((overload_frame_xhdl4 AND (overload_flag_over AND sampled_bit)) = '1') THEN
               enable_overload_cnt2 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         overload_cnt2 <= "000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((overload_frame_ended OR go_error_frame_xhdl33 OR go_overload_frame_xhdl32) = '1') THEN
            overload_cnt2 <= "000" ;    
         ELSE
            IF ((enable_overload_cnt2 AND tx_point) = '1') THEN
               overload_cnt2 <= overload_cnt2 + "001" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         overload_request_cnt <= "00";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_error_frame_xhdl33 OR go_rx_id1) = '1') THEN
            overload_request_cnt <= "00" ;    
         ELSE
            IF ((overload_request AND overload_frame_xhdl4) = '1') THEN
               overload_request_cnt <= overload_request_cnt + "01" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         overload_frame_blocked <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_error_frame_xhdl33 OR go_rx_id1) = '1') THEN
            overload_frame_blocked <= '0' ;    
         ELSE
            IF (((overload_request AND overload_frame_xhdl4) AND CONV_STD_LOGIC(overload_request_cnt = "10")) = '1') THEN
               -- This is a second sequential overload_request
               
               overload_frame_blocked <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   send_ack_xhdl35 <= (((NOT tx_state_xhdl2) AND rx_ack) AND (NOT err)) AND (NOT listen_only_mode) ;

   PROCESS (reset_mode, node_bus_off_xhdl13, tx_state_xhdl2, go_tx_xhdl34, bit_de_stuff_tx, tx_bit, tx_q, send_ack_xhdl35, go_overload_frame_xhdl32, overload_frame_xhdl4, overload_cnt1, go_error_frame_xhdl33, error_frame, error_cnt1, node_error_passive_xhdl26)
      VARIABLE tx_next_xhdl30_xhdl105  : std_logic;
   BEGIN
      IF ((reset_mode OR node_bus_off_xhdl13) = '1') THEN
         -- Reset or node_bus_off
         
         tx_next_xhdl30_xhdl105 := '1';    
      ELSE
         IF ((go_error_frame_xhdl33 OR error_frame) = '1') THEN
            -- Transmitting error frame
            
            IF (error_cnt1 < "110") THEN
               IF (node_error_passive_xhdl26 = '1') THEN
                  tx_next_xhdl30_xhdl105 := '1';    
               ELSE
                  tx_next_xhdl30_xhdl105 := '0';    
               END IF;
            ELSE
               tx_next_xhdl30_xhdl105 := '1';    
            END IF;
         ELSE
            IF ((go_overload_frame_xhdl32 OR overload_frame_xhdl4) = '1') THEN
               -- Transmitting overload frame
               
               IF (overload_cnt1 < "110") THEN
                  tx_next_xhdl30_xhdl105 := '0';    
               ELSE
                  tx_next_xhdl30_xhdl105 := '1';    
               END IF;
            ELSE
               IF ((go_tx_xhdl34 OR tx_state_xhdl2) = '1') THEN
                  -- Transmitting message
                  
                  tx_next_xhdl30_xhdl105 := ((NOT bit_de_stuff_tx) AND tx_bit) OR (bit_de_stuff_tx AND (NOT tx_q));    
               ELSE
                  IF (send_ack_xhdl35 = '1') THEN
                     -- Acknowledge
                     
                     tx_next_xhdl30_xhdl105 := '0';    
                  ELSE
                     tx_next_xhdl30_xhdl105 := '1';    
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
      tx_next_xhdl30 <= tx_next_xhdl30_xhdl105;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         tx_xhdl29 <= '1';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (reset_mode = '1') THEN
            tx_xhdl29 <= '1';    
         ELSE
            IF (tx_point = '1') THEN
               tx_xhdl29 <= tx_next_xhdl30 ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         tx_q <= '0' ;    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (reset_mode = '1') THEN
            tx_q <= '0' ;    
         ELSE
            IF (tx_point = '1') THEN
               tx_q <= tx_xhdl29 AND (NOT go_early_tx_latched) ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Delayed tx point 
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         tx_point_q <= '0' ;    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (reset_mode = '1') THEN
            tx_point_q <= '0' ;    
         ELSE
            tx_point_q <= tx_point ;    
         END IF;
      END IF;
   END PROCESS;
   
   -- Changing bit order from [7:0] to [0:7] 
   i_ibo_tx_data_0 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_0,
         do => r_tx_data_0);   
   
   i_ibo_tx_data_1 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_1,
         do => r_tx_data_1);   
   
   i_ibo_tx_data_2 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_2,
         do => r_tx_data_2);   
   
   i_ibo_tx_data_3 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_3,
         do => r_tx_data_3);   
   
   i_ibo_tx_data_4 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_4,
         do => r_tx_data_4);   
   
   i_ibo_tx_data_5 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_5,
         do => r_tx_data_5);   
   
   i_ibo_tx_data_6 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_6,
         do => r_tx_data_6);   
   
   i_ibo_tx_data_7 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_7,
         do => r_tx_data_7);   
   
   i_ibo_tx_data_8 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_8,
         do => r_tx_data_8);   
   
   i_ibo_tx_data_9 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_9,
         do => r_tx_data_9);   
   
   i_ibo_tx_data_10 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_10,
         do => r_tx_data_10);   
   
   i_ibo_tx_data_11 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_11,
         do => r_tx_data_11);   
   
   i_ibo_tx_data_12 : can_vhdl_ibo 
      PORT MAP (
         di => tx_data_12,
         do => r_tx_data_12);   
   
   
   -- Changing bit order from [14:0] to [0:14] 
   i_calculated_crc0 : can_vhdl_ibo 
      PORT MAP (
         di => calculated_crc(14 DOWNTO 7),
         do => r_calculated_crc(7 DOWNTO 0));   
   
   xhdl_106 <= calculated_crc(6 DOWNTO 0) & '0';
   i_calculated_crc1 : can_vhdl_ibo 
      PORT MAP (
         di => xhdl_106,
         do => r_calculated_crc(15 DOWNTO 8));   
   
   basic_chain <= r_tx_data_1(7 DOWNTO 4) & "00" & r_tx_data_1(3 DOWNTO 0) & r_tx_data_0(7 DOWNTO 0) & '0' ;
   basic_chain_data <= r_tx_data_9 & r_tx_data_8 & r_tx_data_7 & r_tx_data_6 & r_tx_data_5 & r_tx_data_4 & r_tx_data_3 & r_tx_data_2 ;
   extended_chain_std <= r_tx_data_0(7 DOWNTO 4) & "00" & r_tx_data_0(1) & r_tx_data_2(2 DOWNTO 0) & r_tx_data_1(7 DOWNTO 0) & '0' ;
   extended_chain_ext <= r_tx_data_0(7 DOWNTO 4) & "00" & r_tx_data_0(1) & r_tx_data_4(4 DOWNTO 0) & r_tx_data_3(7 DOWNTO 0) & r_tx_data_2(7 DOWNTO 3) & '1' & '1' & r_tx_data_2(2 DOWNTO 0) & r_tx_data_1(7 DOWNTO 0) & '0' ;
   extended_chain_data_std <= r_tx_data_10 & r_tx_data_9 & r_tx_data_8 & r_tx_data_7 & r_tx_data_6 & r_tx_data_5 & r_tx_data_4 & r_tx_data_3 ;
   extended_chain_data_ext <= r_tx_data_12 & r_tx_data_11 & r_tx_data_10 & r_tx_data_9 & r_tx_data_8 & r_tx_data_7 & r_tx_data_6 & r_tx_data_5 ;

   PROCESS (extended_mode, rx_data, tx_pointer, extended_chain_data_std, extended_chain_data_ext, rx_crc, r_calculated_crc, r_tx_data_0, extended_chain_ext, extended_chain_std, basic_chain_data, basic_chain, finish_msg)
      VARIABLE tx_bit_xhdl107  : std_logic;
   BEGIN
      IF (extended_mode = '1') THEN
         IF (rx_data = '1') THEN
            -- data stage
            
            IF (r_tx_data_0(0) = '1') THEN
               -- Extended frame
               
               tx_bit_xhdl107 := extended_chain_data_ext(conv_integer(tx_pointer));    
            ELSE
               tx_bit_xhdl107 := extended_chain_data_std(conv_integer(tx_pointer));    
            END IF;
         ELSE
            IF (rx_crc = '1') THEN
               tx_bit_xhdl107 := r_calculated_crc(conv_integer(tx_pointer(3 downto 0)));    
            ELSE
               IF (finish_msg = '1') THEN
                  tx_bit_xhdl107 := '1';    
               ELSE
                  IF (r_tx_data_0(0) = '1') THEN
                     -- Extended frame
                     
                     tx_bit_xhdl107 := extended_chain_ext(conv_integer(tx_pointer));    
                  ELSE
                     tx_bit_xhdl107 := extended_chain_std(conv_integer(tx_pointer));    
                  END IF;
               END IF;
            END IF;
         END IF;
      ELSE
         -- Basic mode
         
         IF (rx_data = '1') THEN
            -- data stage
            
            tx_bit_xhdl107 := basic_chain_data(conv_integer(tx_pointer));    
         ELSE
            IF (rx_crc = '1') THEN
               tx_bit_xhdl107 := r_calculated_crc(conv_integer(tx_pointer));    
            ELSE
               IF (finish_msg = '1') THEN
                  tx_bit_xhdl107 := '1';    
               ELSE
                  tx_bit_xhdl107 := basic_chain(conv_integer(tx_pointer));    
               END IF;
            END IF;
         END IF;
      END IF;
      tx_bit <= tx_bit_xhdl107;
   END PROCESS;
   temp_xhdl108 <= "111111" WHEN tx_data_0(3) = '1' ELSE ((tx_data_0(2 DOWNTO 0) & "000") - 1);
   limited_tx_cnt_ext <= temp_xhdl108 ;
   temp_xhdl109 <= "111111" WHEN tx_data_1(3) = '1' ELSE ((tx_data_1(2 DOWNTO 0) & "000") - 1);
   limited_tx_cnt_std <= temp_xhdl109 ;
   -- arbitration + control for extended format
   -- arbitration + control for extended format
   -- arbitration + control for standard format
   -- data       (overflow is OK here)
   -- data       (overflow is OK here)
   -- crc
   -- at the end
   rst_tx_pointer <= ((((((NOT bit_de_stuff_tx) AND tx_point) AND (NOT rx_data)) AND extended_mode) AND r_tx_data_0(0)) AND CONV_STD_LOGIC(tx_pointer = "100110")) OR ((((((NOT bit_de_stuff_tx) AND tx_point) AND (NOT rx_data)) AND extended_mode) AND (NOT r_tx_data_0(0))) AND CONV_STD_LOGIC(tx_pointer = "010010")) OR (((((NOT bit_de_stuff_tx) AND tx_point) AND (NOT rx_data)) AND (NOT extended_mode)) AND CONV_STD_LOGIC(tx_pointer = "010010")) OR (((((NOT bit_de_stuff_tx) AND tx_point) AND rx_data) AND extended_mode) AND CONV_STD_LOGIC(tx_pointer = limited_tx_cnt_ext)) OR (((((NOT bit_de_stuff_tx) AND tx_point) AND rx_data) AND (NOT extended_mode)) AND CONV_STD_LOGIC(tx_pointer = limited_tx_cnt_std)) OR (tx_point AND rx_crc_lim) OR (go_rx_idle) OR (reset_mode) OR (overload_frame_xhdl4) OR (error_frame) ;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         tx_pointer <= "000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (rst_tx_pointer = '1') THEN
            tx_pointer <= "000000" ;    
         ELSE
            IF ((go_early_tx OR ((tx_point AND (tx_state_xhdl2 OR go_tx_xhdl34)) AND (NOT bit_de_stuff_tx))) = '1') THEN
               tx_pointer <= tx_pointer + "000001" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   tx_successful_xhdl19 <= ((((transmitter_xhdl8 AND go_rx_inter_xhdl9) AND (NOT go_error_frame_xhdl33)) AND (NOT error_frame_ended)) AND (NOT overload_frame_ended)) AND (NOT arbitration_lost) ;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         need_to_tx_xhdl20 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((tx_successful_xhdl19 OR reset_mode OR (abort_tx AND (NOT transmitting_xhdl7)) OR (((NOT tx_state_xhdl2) AND tx_state_q_xhdl3) AND single_shot_transmission)) = '1') THEN
            need_to_tx_xhdl20 <= '0' ;    
         ELSE
            IF ((tx_request AND sample_point) = '1') THEN
               need_to_tx_xhdl20 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   go_early_tx <= ((((((NOT listen_only_mode) AND need_to_tx_xhdl20) AND (NOT tx_state_xhdl2)) AND (NOT suspend OR CONV_STD_LOGIC(susp_cnt = "111"))) AND sample_point) AND (NOT sampled_bit)) AND (rx_idle_xhdl6 OR last_bit_of_inter) ;
   go_tx_xhdl34 <= ((((NOT listen_only_mode) AND need_to_tx_xhdl20) AND (NOT tx_state_xhdl2)) AND (NOT suspend OR (sample_point AND CONV_STD_LOGIC(susp_cnt = "111")))) AND (go_early_tx OR rx_idle_xhdl6) ;

   -- go_early_tx latched (for proper bit_de_stuff generation)
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         go_early_tx_latched <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((reset_mode OR tx_point) = '1') THEN
            go_early_tx_latched <= '0' ;    
         ELSE
            IF (go_early_tx = '1') THEN
               go_early_tx_latched <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Tx state
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         tx_state_xhdl2 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((reset_mode OR go_rx_inter_xhdl9 OR error_frame OR arbitration_lost) = '1') THEN
            tx_state_xhdl2 <= '0' ;    
         ELSE
            IF (go_tx_xhdl34 = '1') THEN
               tx_state_xhdl2 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         tx_state_q_xhdl3 <= '0' ;    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (reset_mode = '1') THEN
            tx_state_q_xhdl3 <= '0' ;    
         ELSE
            tx_state_q_xhdl3 <= tx_state_xhdl2 ;    
         END IF;
      END IF;
   END PROCESS;

   -- Node is a transmitter
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         transmitter_xhdl8 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (go_tx_xhdl34 = '1') THEN
            transmitter_xhdl8 <= '1' ;    
         ELSE
            IF ((reset_mode OR go_rx_idle OR (suspend AND go_rx_id1)) = '1') THEN
               transmitter_xhdl8 <= '0' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Signal "transmitting" signals that the core is a transmitting (message, error frame or overload frame). No synchronization is done meanwhile.
   -- Node might be both transmitter or receiver (sending error or overload frame)
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         transmitting_xhdl7 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_error_frame_xhdl33 OR go_overload_frame_xhdl32 OR go_tx_xhdl34 OR send_ack_xhdl35) = '1') THEN
            transmitting_xhdl7 <= '1' ;    
         ELSE
            IF ((reset_mode OR go_rx_idle OR (go_rx_id1 AND (NOT tx_state_xhdl2)) OR (arbitration_lost AND tx_state_xhdl2)) = '1') THEN
               transmitting_xhdl7 <= '0' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         suspend <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((reset_mode OR (sample_point AND CONV_STD_LOGIC(susp_cnt = "111"))) = '1') THEN
            suspend <= '0' ;    
         ELSE
            IF (((not_first_bit_of_inter_xhdl10 AND transmitter_xhdl8) AND node_error_passive_xhdl26) = '1') THEN
               suspend <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         susp_cnt_en <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((reset_mode OR (sample_point AND CONV_STD_LOGIC(susp_cnt = "111"))) = '1') THEN
            susp_cnt_en <= '0' ;    
         ELSE
            IF (((suspend AND sample_point) AND last_bit_of_inter) = '1') THEN
               susp_cnt_en <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         susp_cnt <= "000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((reset_mode OR (sample_point AND CONV_STD_LOGIC(susp_cnt = "111"))) = '1') THEN
            susp_cnt <= "000" ;    
         ELSE
            IF ((susp_cnt_en AND sample_point) = '1') THEN
               susp_cnt <= susp_cnt + "001" ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         finish_msg <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_idle OR go_rx_id1 OR error_frame OR reset_mode) = '1') THEN
            finish_msg <= '0' ;    
         ELSE
            IF (go_rx_crc_lim = '1') THEN
               finish_msg <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         arbitration_lost <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((go_rx_idle OR error_frame_ended) = '1') THEN
            arbitration_lost <= '0' ;    
         ELSE
            IF (((((transmitter_xhdl8 AND sample_point) AND tx_xhdl29) AND arbitration_field) AND NOT sampled_bit) = '1') THEN
               arbitration_lost <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         arbitration_lost_q <= '0' ;    
      ELSIF (clk'EVENT AND clk = '1') THEN
         arbitration_lost_q <= arbitration_lost;
      END IF;
   END PROCESS;
   set_arbitration_lost_irq_xhdl24 <= (arbitration_lost AND (NOT arbitration_lost_q)) AND (NOT arbitration_blocked) ;

   PROCESS (clk, rst)
   BEGIN
     IF (rst = '1') THEN
       arbitration_field_d <= '0';
     ELSIF (clk'EVENT AND clk = '1') THEN
		 if (sample_point = '1') then
			 arbitration_field_d <= arbitration_field;
         end if;
     END IF;
   END PROCESS;
   
   PROCESS (clk, rst)
   BEGIN
     IF (rst = '1') THEN
       read_error_code_capture_reg_q <= '0';
     ELSIF (clk'EVENT AND clk = '1') THEN
       read_error_code_capture_reg_q <= read_error_code_capture_reg;
     END IF;
   END PROCESS;
   
   reset_error_code_capture_reg <= read_error_code_capture_reg_q and not read_error_code_capture_reg;
      
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         arbitration_cnt <= (others =>'0');    
      ELSIF (clk'EVENT AND clk = '1') THEN
		  if ((sample_point = '1') and (bit_de_stuff = '0')) then
            IF (arbitration_field_d = '1') THEN
               arbitration_cnt <= arbitration_cnt + "01";    
            ELSE 
               arbitration_cnt <= (others =>'0');    
            END IF;
          END IF;
      END IF;
   END PROCESS;

  
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         arbitration_lost_capture_xhdl25 <= "00000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (set_arbitration_lost_irq_xhdl24 = '1') THEN
            arbitration_lost_capture_xhdl25 <= arbitration_cnt ;    
         END IF;
      END IF;
   END PROCESS;
   
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         arbitration_blocked <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (read_arbitration_lost_capture_reg = '1') THEN
            arbitration_blocked <= '0' ;    
         ELSIF (set_arbitration_lost_irq_xhdl24 = '1') THEN
            arbitration_blocked <= '1' ;
         END IF;
      END IF;
   END PROCESS;


   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         rx_err_cnt_xhdl15 <= "000000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((we_rx_err_cnt AND (NOT node_bus_off_xhdl13)) = '1') THEN
            rx_err_cnt_xhdl15 <= '0' & data_in ;    
         ELSE
            IF (set_reset_mode_xhdl12 = '1') THEN
               rx_err_cnt_xhdl15 <= "000000000" ;    
            ELSE
               IF (((NOT listen_only_mode) AND (NOT transmitter_xhdl8 OR arbitration_lost)) = '1') THEN
                  IF ((((go_rx_ack_lim AND (NOT go_error_frame_xhdl33)) AND (NOT crc_err)) AND CONV_STD_LOGIC(rx_err_cnt_xhdl15 > "000000000")) = '1') THEN
                     IF (rx_err_cnt_xhdl15 > "001111111") THEN
                        rx_err_cnt_xhdl15 <= "001111111" ;    
                     ELSE
                        rx_err_cnt_xhdl15 <= rx_err_cnt_xhdl15 - "000000001" ;    
                     END IF;
                  ELSE
                     IF (rx_err_cnt_xhdl15 < "010000000") THEN
                        IF ((go_error_frame_xhdl33 AND (NOT rule5)) = '1') THEN
                           -- 1  (rule 5 is just the opposite then rule 1 exception
                           
                           rx_err_cnt_xhdl15 <= rx_err_cnt_xhdl15 + "000000001" ;    
                        ELSE
                           IF ((((((error_flag_over AND (NOT error_flag_over_latched)) AND sample_point) AND (NOT sampled_bit)) AND CONV_STD_LOGIC(error_cnt1 = "111")) OR (go_error_frame_xhdl33 AND rule5) OR ((sample_point AND (NOT sampled_bit)) AND CONV_STD_LOGIC(delayed_dominant_cnt = "111"))) = '1') THEN
                              -- 2
                              -- 5
                              -- 6
                              
                              rx_err_cnt_xhdl15 <= rx_err_cnt_xhdl15 + "000001000" ;    
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         tx_err_cnt_xhdl16 <= "000000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (we_tx_err_cnt = '1') THEN
            tx_err_cnt_xhdl16 <= '0' & data_in ;    
         ELSE
            IF (set_reset_mode_xhdl12 = '1') THEN
               tx_err_cnt_xhdl16 <= "010000000" ;    
            ELSE
               IF ((CONV_STD_LOGIC(tx_err_cnt_xhdl16 > "000000000") AND (tx_successful_xhdl19 OR bus_free)) = '1') THEN
                  tx_err_cnt_xhdl16 <= tx_err_cnt_xhdl16 - "000000001" ;    
               ELSE
                  IF ((transmitter_xhdl8 AND (NOT arbitration_lost)) = '1') THEN
                     IF ((((sample_point AND (NOT sampled_bit)) AND CONV_STD_LOGIC(delayed_dominant_cnt = "111")) OR (go_error_frame_xhdl33 AND rule5) OR ((go_error_frame_xhdl33 AND (NOT ((transmitter_xhdl8 AND node_error_passive_xhdl26) AND ack_err))) AND (NOT (((((transmitter_xhdl8 AND stuff_err) AND arbitration_field) AND sample_point) AND tx_xhdl29) AND (NOT sampled_bit)))) OR (error_frame AND rule3_exc1_2)) = '1') THEN
                        -- 6
                        -- 4  (rule 5 is the same as rule 4)
                        -- 3 
                        -- 3
                        
                        tx_err_cnt_xhdl16 <= tx_err_cnt_xhdl16 + "000001000" ;    
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         node_error_passive_xhdl26 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((rx_err_cnt_xhdl15 < "010000000") AND (tx_err_cnt_xhdl16 < "010000000")) THEN
            node_error_passive_xhdl26 <= '0' ;    
         ELSE
            IF (((CONV_STD_LOGIC((rx_err_cnt_xhdl15 >= "010000000") OR (tx_err_cnt_xhdl16 >= "010000000")) AND (error_frame_ended OR go_error_frame_xhdl33 OR ((NOT reset_mode) AND reset_mode_q))) AND (NOT node_bus_off_xhdl13)) = '1') THEN
               node_error_passive_xhdl26 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   node_error_active_xhdl27 <= NOT (node_error_passive_xhdl26 OR node_bus_off_xhdl13) ;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         node_bus_off_xhdl13 <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (((CONV_STD_LOGIC((rx_err_cnt_xhdl15 = "000000000") AND (tx_err_cnt_xhdl16 = "000000000")) AND (NOT reset_mode)) OR (we_tx_err_cnt AND CONV_STD_LOGIC(data_in < "11111111"))) = '1') THEN
            node_bus_off_xhdl13 <= '0' ;    
         ELSE
            IF ((CONV_STD_LOGIC(tx_err_cnt_xhdl16 >= "100000000") OR (we_tx_err_cnt AND CONV_STD_LOGIC(data_in = "11111111"))) = '1') THEN
               node_bus_off_xhdl13 <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         bus_free_cnt <= "0000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
            IF (sample_point = '1') THEN
               IF (((sampled_bit AND bus_free_cnt_en) AND CONV_STD_LOGIC(bus_free_cnt < "1010")) = '1') THEN
                  bus_free_cnt <= bus_free_cnt + "0001" ;    
               ELSE
                  bus_free_cnt <= "0000" ;    
               END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         bus_free_cnt_en <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF ((((NOT reset_mode) AND reset_mode_q) OR (node_bus_off_q AND (NOT reset_mode))) = '1') THEN
            bus_free_cnt_en <= '1' ;    
         ELSE
            IF ((((sample_point AND sampled_bit) AND CONV_STD_LOGIC(bus_free_cnt = "1010")) AND (NOT node_bus_off_xhdl13)) = '1') THEN
               bus_free_cnt_en <= '0' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         bus_free <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
            IF (((sample_point AND sampled_bit) AND CONV_STD_LOGIC(bus_free_cnt = "1010") and waiting_for_bus_free) = '1') THEN
               bus_free <= '1' ;    
            ELSE
               bus_free <= '0' ;    
            END IF;
      END IF;
   END PROCESS;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         waiting_for_bus_free <= '1';    
      ELSIF (clk'EVENT AND clk = '1') THEN
            IF ((bus_free AND (NOT node_bus_off_xhdl13)) = '1') THEN
               waiting_for_bus_free <= '0' ;    
            ELSIF ((node_bus_off_q AND (NOT reset_mode)) = '1') THEN
                  waiting_for_bus_free <= '1' ;    
            END IF;
      END IF;
   END PROCESS;
   bus_off_on_xhdl31 <= NOT node_bus_off_xhdl13 ;
   set_reset_mode_xhdl12 <= node_bus_off_xhdl13 AND (NOT node_bus_off_q) ;
   temp_xhdl110 <= ((rx_err_cnt_xhdl15 >= ('0' & error_warning_limit)) OR (tx_err_cnt_xhdl16 >= ('0' & error_warning_limit))) WHEN extended_mode = '1' ELSE ((rx_err_cnt_xhdl15 >= "001100000") OR (tx_err_cnt_xhdl16 >= "001100000"));
   error_status_xhdl14 <= CONV_STD_LOGIC(temp_xhdl110) ;
   transmit_status_xhdl17 <= transmitting_xhdl7 OR (extended_mode AND waiting_for_bus_free) ;
   temp_xhdl111 <= (waiting_for_bus_free OR ((NOT rx_idle_xhdl6) AND (NOT transmitting_xhdl7))) WHEN extended_mode = '1' ELSE (((NOT waiting_for_bus_free) AND (NOT rx_idle_xhdl6)) AND (NOT transmitting_xhdl7));
   receive_status_xhdl18 <= temp_xhdl111 ;

   -- Error code capture register 
   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         error_capture_code_xhdl5 <= "00000000";    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (reset_error_code_capture_reg = '1') THEN
            error_capture_code_xhdl5 <= "00000000" ;    
         ELSE
            IF (set_bus_error_irq_xhdl23 = '1') THEN
               error_capture_code_xhdl5 <= error_capture_code_type(7 DOWNTO 6) & error_capture_code_direction & error_capture_code_segment(4 DOWNTO 0) ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;
   error_capture_code_segment(0) <= rx_idle_xhdl6 OR rx_ide OR (rx_id2 AND CONV_STD_LOGIC(bit_cnt < "001101")) OR rx_r1 OR rx_r0 OR rx_dlc OR rx_ack OR rx_ack_lim OR (error_frame AND node_error_active_xhdl27) ;
   error_capture_code_segment(1) <= rx_idle_xhdl6 OR rx_id1 OR rx_id2 OR rx_dlc OR rx_data OR rx_ack_lim OR rx_eof OR rx_inter_xhdl11 OR (error_frame AND node_error_passive_xhdl26) ;
   error_capture_code_segment(2) <= (rx_id1 AND CONV_STD_LOGIC(bit_cnt > "000111")) OR rx_rtr1 OR rx_ide OR rx_id2 OR rx_rtr2 OR rx_r1 OR (error_frame AND node_error_passive_xhdl26) OR overload_frame_xhdl4 ;
   error_capture_code_segment(3) <= (rx_id2 AND CONV_STD_LOGIC(bit_cnt > "000100")) OR rx_rtr2 OR rx_r1 OR rx_r0 OR rx_dlc OR rx_data OR rx_crc OR rx_crc_lim OR rx_ack OR rx_ack_lim OR rx_eof OR overload_frame_xhdl4 ;
   error_capture_code_segment(4) <= rx_crc_lim OR rx_ack OR rx_ack_lim OR rx_eof OR rx_inter_xhdl11 OR error_frame OR overload_frame_xhdl4 ;
   error_capture_code_direction <= NOT transmitting_xhdl7 ;

   PROCESS (bit_err, form_err, stuff_err)
      VARIABLE error_capture_code_type_xhdl112  : std_logic_vector(7 DOWNTO 6);
   BEGIN
      IF (bit_err = '1') THEN
         error_capture_code_type_xhdl112(7 DOWNTO 6) := "00";    
      ELSE
         IF (form_err = '1') THEN
            error_capture_code_type_xhdl112(7 DOWNTO 6) := "01";    
         ELSE
            IF (stuff_err = '1') THEN
               error_capture_code_type_xhdl112(7 DOWNTO 6) := "10";    
            ELSE
               error_capture_code_type_xhdl112(7 DOWNTO 6) := "11";    
            END IF;
         END IF;
      END IF;
      error_capture_code_type <= error_capture_code_type_xhdl112;
   END PROCESS;
   set_bus_error_irq_xhdl23 <= go_error_frame_xhdl33 AND (NOT error_capture_code_blocked) ;

   PROCESS (clk, rst)
   BEGIN
      IF (rst = '1') THEN
         error_capture_code_blocked <= '0';    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (read_error_code_capture_reg = '1') THEN
            error_capture_code_blocked <= '0' ;    
         ELSE
            IF (set_bus_error_irq_xhdl23 = '1') THEN
               error_capture_code_blocked <= '1' ;    
            END IF;
         END IF;
      END IF;
   END PROCESS;

END ARCHITECTURE RTL;