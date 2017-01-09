# TCL File Generated by Component Editor 13.1
# Thu Jan 05 20:29:39 UTC 2017
# DO NOT MODIFY


# 
# Can_controller "Can_controller" v1.0
# Hamza Meddeb / Nour Laaribi / Safwen Baroudi 2017.01.05.20:29:39
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module Can_controller
# 
set_module_property DESCRIPTION ""
set_module_property NAME Can_controller
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Hamza Meddeb / Nour Laaribi / Safwen Baroudi"
set_module_property DISPLAY_NAME Can_controller
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL CAN_Controller_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file BSP_Interface.vhd VHDL PATH ../VHDL/BSP_Interface.vhd
add_fileset_file CAN_Baudrate_Prescaler.vhd VHDL PATH ../VHDL/CAN_Baudrate_Prescaler.vhd
add_fileset_file CAN_Bit_Timing_Logic.vhd VHDL PATH ../VHDL/CAN_Bit_Timing_Logic.vhd
add_fileset_file CAN_BSP.vhd VHDL PATH ../VHDL/CAN_BSP.vhd
add_fileset_file CAN_Bus.vhd VHDL PATH ../VHDL/CAN_Bus.vhd
add_fileset_file CAN_Control.vhd VHDL PATH ../VHDL/CAN_Control.vhd
add_fileset_file CAN_Controller_Top.vhd VHDL PATH ../VHDL/CAN_Controller_Top.vhd TOP_LEVEL_FILE
add_fileset_file CAN_CRC.vhd VHDL PATH ../VHDL/CAN_CRC.vhd
add_fileset_file CAN_Interface.vhd VHDL PATH ../VHDL/CAN_Interface.vhd
add_fileset_file CAN_Message.vhd VHDL PATH ../VHDL/CAN_Message.vhd
add_fileset_file CAN_Register.vhd VHDL PATH ../VHDL/CAN_Register.vhd
add_fileset_file CPU_Interface.vhd VHDL PATH ../VHDL/CPU_Interface.vhd
add_fileset_file SWITCH_CTRL_CPU.vhd VHDL PATH ../VHDL/SWITCH_CTRL_CPU.vhd

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL CAN_Controller_top
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file BSP_Interface.vhd VHDL PATH ../VHDL/BSP_Interface.vhd
add_fileset_file CAN_Baudrate_Prescaler.vhd VHDL PATH ../VHDL/CAN_Baudrate_Prescaler.vhd
add_fileset_file CAN_Bit_Timing_Logic.vhd VHDL PATH ../VHDL/CAN_Bit_Timing_Logic.vhd
add_fileset_file CAN_BSP.vhd VHDL PATH ../VHDL/CAN_BSP.vhd
add_fileset_file CAN_Bus.vhd VHDL PATH ../VHDL/CAN_Bus.vhd
add_fileset_file CAN_Control.vhd VHDL PATH ../VHDL/CAN_Control.vhd
add_fileset_file CAN_Controller_Top.vhd VHDL PATH ../VHDL/CAN_Controller_Top.vhd
add_fileset_file CAN_CRC.vhd VHDL PATH ../VHDL/CAN_CRC.vhd
add_fileset_file CAN_Interface.vhd VHDL PATH ../VHDL/CAN_Interface.vhd
add_fileset_file CAN_Message.vhd VHDL PATH ../VHDL/CAN_Message.vhd
add_fileset_file CAN_Register.vhd VHDL PATH ../VHDL/CAN_Register.vhd
add_fileset_file CPU_Interface.vhd VHDL PATH ../VHDL/CPU_Interface.vhd
add_fileset_file SWITCH_CTRL_CPU.vhd VHDL PATH ../VHDL/SWITCH_CTRL_CPU.vhd


# 
# parameters
# 


# 
# display items
# 


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clock_sink
set_interface_property avalon_slave_0 associatedReset reset_sink
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 read read Input 1
add_interface_port avalon_slave_0 write write Input 1
add_interface_port avalon_slave_0 address address Input 6
add_interface_port avalon_slave_0 writedata writedata Input 16
add_interface_port avalon_slave_0 readdata readdata Output 16
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink rst reset Input 1


# 
# connection point clock_sink
# 
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 0
set_interface_property clock_sink ENABLED true
set_interface_property clock_sink EXPORT_OF ""
set_interface_property clock_sink PORT_NAME_MAP ""
set_interface_property clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink SVD_ADDRESS_GROUP ""

add_interface_port clock_sink clk clk Input 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock ""
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end RxCAN export Input 1


# 
# connection point conduit_end_1
# 
add_interface conduit_end_1 conduit end
set_interface_property conduit_end_1 associatedClock ""
set_interface_property conduit_end_1 associatedReset ""
set_interface_property conduit_end_1 ENABLED true
set_interface_property conduit_end_1 EXPORT_OF ""
set_interface_property conduit_end_1 PORT_NAME_MAP ""
set_interface_property conduit_end_1 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_1 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_1 TxCAN export Output 1

