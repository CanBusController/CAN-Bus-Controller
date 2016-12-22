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

--synthesis_resources = mux21 4 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  CAN_CONTROLLER_mm_interconnect_0_addr_router_001 IS 
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
 END CAN_CONTROLLER_mm_interconnect_0_addr_router_001;

 ARCHITECTURE RTL OF CAN_CONTROLLER_mm_interconnect_0_addr_router_001 IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL	wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_16m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_17m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_can_controller_mm_interconnect_0_addr_router_001_src_data_18m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_can_controller_mm_interconnect_0_addr_router_001_src_data_19m_dataout	:	STD_LOGIC;
	 SIGNAL  wire_w_lg_w_sink_data_range143w266w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w1w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_sink_data_range146w265w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  s_wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_1_243_dataout :	STD_LOGIC;
	 SIGNAL  s_wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_2_258_dataout :	STD_LOGIC;
	 SIGNAL  wire_w_sink_data_range143w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_sink_data_range146w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
 BEGIN

	wire_w_lg_w_sink_data_range143w266w(0) <= wire_w_sink_data_range143w(0) AND wire_w_lg_w_sink_data_range146w265w(0);
	wire_w1w(0) <= NOT s_wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_1_243_dataout;
	wire_w_lg_w_sink_data_range146w265w(0) <= NOT wire_w_sink_data_range146w(0);
	s_wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_1_243_dataout <= (wire_w_lg_w_sink_data_range143w266w(0) AND sink_data(49));
	s_wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_2_258_dataout <= ((((((NOT sink_data(44)) AND (NOT sink_data(45))) AND (NOT sink_data(46))) AND (NOT sink_data(47))) AND sink_data(48)) AND sink_data(49));
	sink_ready <= src_ready;
	src_channel <= ( s_wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_2_258_dataout & wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_16m_dataout & wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_17m_dataout);
	src_data <= ( sink_data(87 DOWNTO 75) & wire_can_controller_mm_interconnect_0_addr_router_001_src_data_18m_dataout & wire_can_controller_mm_interconnect_0_addr_router_001_src_data_19m_dataout & sink_data(72 DOWNTO 0));
	src_endofpacket <= sink_endofpacket;
	src_startofpacket <= sink_startofpacket;
	src_valid <= sink_valid;
	wire_w_sink_data_range143w(0) <= sink_data(47);
	wire_w_sink_data_range146w(0) <= sink_data(48);
	wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_16m_dataout <= wire_w1w(0) AND NOT(s_wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_2_258_dataout);
	wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_17m_dataout <= s_wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_1_243_dataout AND NOT(s_wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_2_258_dataout);
	wire_can_controller_mm_interconnect_0_addr_router_001_src_data_18m_dataout <= wire_w1w(0) AND NOT(s_wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_2_258_dataout);
	wire_can_controller_mm_interconnect_0_addr_router_001_src_data_19m_dataout <= s_wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_1_243_dataout AND NOT(s_wire_can_controller_mm_interconnect_0_addr_router_001_src_channel_2_258_dataout);

 END RTL; --CAN_CONTROLLER_mm_interconnect_0_addr_router_001
--synopsys translate_on
--VALID FILE
