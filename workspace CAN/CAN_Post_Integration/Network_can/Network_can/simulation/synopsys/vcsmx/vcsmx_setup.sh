
# (C) 2001-2017 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 13.1 162 win32 2017.01.15.11:34:26

# ----------------------------------------
# vcsmx - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="Network_can"
QSYS_SIMDIR="./../../"
QUARTUS_INSTALL_DIR="C:/altera/13.1/quartus/"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="+vcs+finish+100"

# ----------------------------------------
# overwrite variables - DO NOT MODIFY!
# This block evaluates each command line argument, typically used for 
# overwriting variables. An example usage:
#   sh <simulator>_setup.sh SKIP_ELAB=1 SKIP_SIM=1
for expression in "$@"; do
  eval $expression
  if [ $? -ne 0 ]; then
    echo "Error: This command line argument, \"$expression\", is/has an invalid expression." >&2
    exit $?
  fi
done

# ----------------------------------------
# initialize simulation properties - DO NOT MODIFY!
ELAB_OPTIONS=""
SIM_OPTIONS=""
if [[ `vcs -platform` != *"amd64"* ]]; then
  :
else
  :
fi

# ----------------------------------------
# create compilation libraries
mkdir -p ./libraries/work/
mkdir -p ./libraries/rsp_xbar_mux_001/
mkdir -p ./libraries/rsp_xbar_mux/
mkdir -p ./libraries/rsp_xbar_demux_002/
mkdir -p ./libraries/cmd_xbar_mux_002/
mkdir -p ./libraries/cmd_xbar_mux/
mkdir -p ./libraries/cmd_xbar_demux_001/
mkdir -p ./libraries/cmd_xbar_demux/
mkdir -p ./libraries/id_router_002/
mkdir -p ./libraries/id_router_001/
mkdir -p ./libraries/id_router/
mkdir -p ./libraries/addr_router_001/
mkdir -p ./libraries/addr_router/
mkdir -p ./libraries/onchip_memory2_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo/
mkdir -p ./libraries/nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo/
mkdir -p ./libraries/irq_mapper/
mkdir -p ./libraries/mm_interconnect_1/
mkdir -p ./libraries/mm_interconnect_0/
mkdir -p ./libraries/Bus_CAN_0/
mkdir -p ./libraries/onchip_memory2_1/
mkdir -p ./libraries/onchip_memory2_0/
mkdir -p ./libraries/nios2_qsys_1/
mkdir -p ./libraries/nios2_qsys_0/
mkdir -p ./libraries/Can_controller_0/
mkdir -p ./libraries/altera/
mkdir -p ./libraries/lpm/
mkdir -p ./libraries/sgate/
mkdir -p ./libraries/altera_mf/
mkdir -p ./libraries/altera_lnsim/
mkdir -p ./libraries/cycloneiii/

# ----------------------------------------
# copy RAM/ROM files to simulation directory
if [ $SKIP_FILE_COPY -eq 0 ]; then
  cp -f $QSYS_SIMDIR/submodules/Network_can_onchip_memory2_1.hex ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_onchip_memory2_0.hex ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_ociram_default_contents.dat ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_ociram_default_contents.hex ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_ociram_default_contents.mif ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_rf_ram_a.dat ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_rf_ram_a.hex ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_rf_ram_a.mif ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_rf_ram_b.dat ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_rf_ram_b.hex ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_rf_ram_b.mif ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_ociram_default_contents.dat ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_ociram_default_contents.hex ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_ociram_default_contents.mif ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_rf_ram_a.dat ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_rf_ram_a.hex ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_rf_ram_a.mif ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_rf_ram_b.dat ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_rf_ram_b.hex ./
  cp -f $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_rf_ram_b.mif ./
fi

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_syn_attributes.vhd"        -work altera      
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_standard_functions.vhd"    -work altera      
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/alt_dspbuilder_package.vhd"       -work altera      
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_europa_support_lib.vhd"    -work altera      
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives_components.vhd" -work altera      
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.vhd"            -work altera      
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/220pack.vhd"                      -work lpm         
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.vhd"                     -work lpm         
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate_pack.vhd"                   -work sgate       
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.vhd"                        -work sgate       
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf_components.vhd"         -work altera_mf   
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.vhd"                    -work altera_mf   
  vlogan +v2k -sverilog "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                  -work altera_lnsim
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim_components.vhd"      -work altera_lnsim
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiii_atoms.vhd"             -work cycloneiii  
  vhdlan                "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiii_components.vhd"        -work cycloneiii  
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_rsp_xbar_mux_001.vho"                                                                  -work rsp_xbar_mux_001                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_rsp_xbar_mux.vho"                                                                      -work rsp_xbar_mux                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_rsp_xbar_demux_002.vho"                                                                -work rsp_xbar_demux_002                                                               
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_cmd_xbar_mux_002.vho"                                                                  -work cmd_xbar_mux_002                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_cmd_xbar_mux.vho"                                                                      -work cmd_xbar_mux                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_cmd_xbar_demux_001.vho"                                                                -work cmd_xbar_demux_001                                                               
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_cmd_xbar_demux.vho"                                                                    -work cmd_xbar_demux                                                                   
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_id_router_002.vho"                                                                     -work id_router_002                                                                    
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_id_router_001.vho"                                                                     -work id_router_001                                                                    
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_id_router.vho"                                                                         -work id_router                                                                        
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_addr_router_001.vho"                                                                   -work addr_router_001                                                                  
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_addr_router.vho"                                                                       -work addr_router                                                                      
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_onchip_memory2_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo.vho"            -work onchip_memory2_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo           
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo.vho" -work nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_irq_mapper.vho"                                                                                          -work irq_mapper                                                                       
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_1.vhd"                                                                                   -work mm_interconnect_1                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_nios2_qsys_1_jtag_debug_module_translator.vhd"                                         -work mm_interconnect_1                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_onchip_memory2_1_s1_translator.vhd"                                                    -work mm_interconnect_1                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_can_controller_1_avalon_slave_0_translator.vhd"                                        -work mm_interconnect_1                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_nios2_qsys_1_jtag_debug_module_translator_avalon_universal_slave_0_agent.vhd"          -work mm_interconnect_1                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_onchip_memory2_1_s1_translator_avalon_universal_slave_0_agent.vhd"                     -work mm_interconnect_1                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_width_adapter.vhd"                                                                     -work mm_interconnect_1                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_width_adapter_002.vhd"                                                                 -work mm_interconnect_1                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_nios2_qsys_1_instruction_master_translator.vhd"                                        -work mm_interconnect_1                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_nios2_qsys_1_data_master_translator.vhd"                                               -work mm_interconnect_1                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0.vhd"                                                                                   -work mm_interconnect_0                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_nios2_qsys_0_jtag_debug_module_translator.vhd"                                         -work mm_interconnect_0                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_onchip_memory2_0_s1_translator.vhd"                                                    -work mm_interconnect_0                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_can_controller_0_avalon_slave_0_translator.vhd"                                        -work mm_interconnect_0                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent.vhd"          -work mm_interconnect_0                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_onchip_memory2_0_s1_translator_avalon_universal_slave_0_agent.vhd"                     -work mm_interconnect_0                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_width_adapter.vhd"                                                                     -work mm_interconnect_0                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_width_adapter_002.vhd"                                                                 -work mm_interconnect_0                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_nios2_qsys_0_instruction_master_translator.vhd"                                        -work mm_interconnect_0                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_nios2_qsys_0_data_master_translator.vhd"                                               -work mm_interconnect_0                                                                
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/CAN_Bus.vhd"                                                                                                         -work Bus_CAN_0                                                                        
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_onchip_memory2_1.vhd"                                                                                    -work onchip_memory2_1                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_onchip_memory2_0.vhd"                                                                                    -work onchip_memory2_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1.vhd"                                                                                        -work nios2_qsys_1                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_jtag_debug_module_sysclk.vhd"                                                               -work nios2_qsys_1                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_jtag_debug_module_tck.vhd"                                                                  -work nios2_qsys_1                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_jtag_debug_module_wrapper.vhd"                                                              -work nios2_qsys_1                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_oci_test_bench.vhd"                                                                         -work nios2_qsys_1                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_test_bench.vhd"                                                                             -work nios2_qsys_1                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0.vhd"                                                                                        -work nios2_qsys_0                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_jtag_debug_module_sysclk.vhd"                                                               -work nios2_qsys_0                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_jtag_debug_module_tck.vhd"                                                                  -work nios2_qsys_0                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_jtag_debug_module_wrapper.vhd"                                                              -work nios2_qsys_0                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_oci_test_bench.vhd"                                                                         -work nios2_qsys_0                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_test_bench.vhd"                                                                             -work nios2_qsys_0                                                                     
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/BSP_Interface.vhd"                                                                                                   -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/CAN_Baudrate_Prescaler.vhd"                                                                                          -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/CAN_Bit_Timing_Logic.vhd"                                                                                            -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/CAN_BSP.vhd"                                                                                                         -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/CAN_Bus.vhd"                                                                                                         -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/CAN_Control.vhd"                                                                                                     -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/CAN_Controller_Top.vhd"                                                                                              -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/CAN_CRC.vhd"                                                                                                         -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/CAN_Interface.vhd"                                                                                                   -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/CAN_Message.vhd"                                                                                                     -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/CAN_Register.vhd"                                                                                                    -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/CPU_Interface.vhd"                                                                                                   -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/submodules/SWITCH_CTRL_CPU.vhd"                                                                                                 -work Can_controller_0                                                                 
  vhdlan -xlrm "$QSYS_SIMDIR/Network_can.vhd"                                                                                                                                                                                                       
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  vcs -lca -t ps $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $SIM_OPTIONS $USER_DEFINED_SIM_OPTIONS
fi
