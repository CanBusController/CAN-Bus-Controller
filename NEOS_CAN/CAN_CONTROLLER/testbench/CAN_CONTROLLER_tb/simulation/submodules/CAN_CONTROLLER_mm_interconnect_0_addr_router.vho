--IP Functional Simulation Model
--VERSION_BEGIN 13.1 cbx_mgl 2013:10:24:09:16:30:SJ cbx_simgen 2013:10:24:09:15:20:SJ  VERSION_END


-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- You may only use these simulation model output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event Altera disclaims all warranties of any kind).


--synopsys translate_off

--synthesis_resources = 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  CAN_CONTROLLER_mm_interconnect_0_addr_router IS 
	 PORT 
	 ( 
		 clk	:	IN  STD_LOGIC;
		 reset	:	IN  STD_LOGIC;
		 sink_data	:	IN  STD_LOGIC_VECTOR (87 DOWNTO 0);
		 sink_endofpacket	:	IN  STD_LOGIC;
		 sink_ready	:	OUT  STD_LOGIC;
		 sink_startofpacket	:	IN  STD_LOGIC;
		 sink_valid	:	IN  STD_LOGIC;
		 src_channel	:	OUT  STD_LOGIC_VECTOR (2 DOWNTO 0);
		 src_data	:	OUT  STD_LOGIC_VECTOR (87 DOWNTO 0);
		 src_endofpacket	:	OUT  STD_LOGIC;
		 src_ready	:	IN  STD_LOGIC;
		 src_startofpacket	:	OUT  STD_LOGIC;
		 src_valid	:	OUT  STD_LOGIC
	 ); 
 END CAN_CONTROLLER_mm_interconnect_0_addr_router;

 ARCHITECTURE RTL OF CAN_CONTROLLER_mm_interconnect_0_addr_router IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL  wire_w_lg_w_sink_data_range142w267w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w221w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_sink_data_range145w266w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  s_wire_can_controller_mm_interconnect_0_addr_router_src_channel_1_237_dataout :	STD_LOGIC;
	 SIGNAL  wire_w_sink_data_range142w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_sink_data_range145w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
 BEGIN

	wire_w_lg_w_sink_data_range142w267w(0) <= wire_w_sink_data_range142w(0) AND wire_w_lg_w_sink_data_range145w266w(0);
	wire_w221w(0) <= NOT s_wire_can_controller_mm_interconnect_0_addr_router_src_channel_1_237_dataout;
	wire_w_lg_w_sink_data_range145w266w(0) <= NOT wire_w_sink_data_range145w(0);
	s_wire_can_controller_mm_interconnect_0_addr_router_src_channel_1_237_dataout <= (wire_w_lg_w_sink_data_range142w267w(0) AND sink_data(49));
	sink_ready <= src_ready;
	src_channel <= ( "0" & wire_w221w & s_wire_can_controller_mm_interconnect_0_addr_router_src_channel_1_237_dataout);
	src_data <= ( sink_data(87 DOWNTO 75) & wire_w221w & s_wire_can_controller_mm_interconnect_0_addr_router_src_channel_1_237_dataout & sink_data(72 DOWNTO 0));
	src_endofpacket <= sink_endofpacket;
	src_startofpacket <= sink_startofpacket;
	src_valid <= sink_valid;
	wire_w_sink_data_range142w(0) <= sink_data(47);
	wire_w_sink_data_range145w(0) <= sink_data(48);

 END RTL; --CAN_CONTROLLER_mm_interconnect_0_addr_router
--synopsys translate_on
--VALID FILE
