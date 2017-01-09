
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

# ACDS 13.1 162 win32 2017.01.05.22:54:42

# ----------------------------------------
# Auto-generated simulation script

# ----------------------------------------
# Initialize variables
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
}

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "Network_can"
}

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
}

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "C:/altera/13.1/quartus/"
}

# ----------------------------------------
# Initialize simulation properties - DO NOT MODIFY!
set ELAB_OPTIONS ""
set SIM_OPTIONS ""
if ![ string match "*-64 vsim*" [ vsim -version ] ] {
} else {
}

set Aldec "Riviera"
if { [ string match "*Active-HDL*" [ vsim -version ] ] } {
  set Aldec "Active"
}

if { [ string match "Active" $Aldec ] } {
  scripterconf -tcl
  createdesign "$TOP_LEVEL_NAME"  "."
  opendesign "$TOP_LEVEL_NAME"
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
  file copy -force $QSYS_SIMDIR/submodules/Network_can_onchip_memory2_1.hex ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_onchip_memory2_0.hex ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_ociram_default_contents.dat ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_ociram_default_contents.hex ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_ociram_default_contents.mif ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_rf_ram_a.dat ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_rf_ram_a.hex ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_rf_ram_a.mif ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_rf_ram_b.dat ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_rf_ram_b.hex ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_rf_ram_b.mif ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_ociram_default_contents.dat ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_ociram_default_contents.hex ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_ociram_default_contents.mif ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_rf_ram_a.dat ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_rf_ram_a.hex ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_rf_ram_a.mif ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_rf_ram_b.dat ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_rf_ram_b.hex ./
  file copy -force $QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_rf_ram_b.mif ./
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib      ./libraries     
ensure_lib      ./libraries/work
vmap       work ./libraries/work
ensure_lib                  ./libraries/altera_ver      
vmap       altera_ver       ./libraries/altera_ver      
ensure_lib                  ./libraries/lpm_ver         
vmap       lpm_ver          ./libraries/lpm_ver         
ensure_lib                  ./libraries/sgate_ver       
vmap       sgate_ver        ./libraries/sgate_ver       
ensure_lib                  ./libraries/altera_mf_ver   
vmap       altera_mf_ver    ./libraries/altera_mf_ver   
ensure_lib                  ./libraries/altera_lnsim_ver
vmap       altera_lnsim_ver ./libraries/altera_lnsim_ver
ensure_lib                  ./libraries/cycloneiii_ver  
vmap       cycloneiii_ver   ./libraries/cycloneiii_ver  
ensure_lib                  ./libraries/altera          
vmap       altera           ./libraries/altera          
ensure_lib                  ./libraries/lpm             
vmap       lpm              ./libraries/lpm             
ensure_lib                  ./libraries/sgate           
vmap       sgate            ./libraries/sgate           
ensure_lib                  ./libraries/altera_mf       
vmap       altera_mf        ./libraries/altera_mf       
ensure_lib                  ./libraries/altera_lnsim    
vmap       altera_lnsim     ./libraries/altera_lnsim    
ensure_lib                  ./libraries/cycloneiii      
vmap       cycloneiii       ./libraries/cycloneiii      
ensure_lib                                                                                   ./libraries/width_adapter                                                                    
vmap       width_adapter                                                                     ./libraries/width_adapter                                                                    
ensure_lib                                                                                   ./libraries/rsp_xbar_mux_001                                                                 
vmap       rsp_xbar_mux_001                                                                  ./libraries/rsp_xbar_mux_001                                                                 
ensure_lib                                                                                   ./libraries/rsp_xbar_mux                                                                     
vmap       rsp_xbar_mux                                                                      ./libraries/rsp_xbar_mux                                                                     
ensure_lib                                                                                   ./libraries/rsp_xbar_demux_002                                                               
vmap       rsp_xbar_demux_002                                                                ./libraries/rsp_xbar_demux_002                                                               
ensure_lib                                                                                   ./libraries/cmd_xbar_mux_002                                                                 
vmap       cmd_xbar_mux_002                                                                  ./libraries/cmd_xbar_mux_002                                                                 
ensure_lib                                                                                   ./libraries/cmd_xbar_mux                                                                     
vmap       cmd_xbar_mux                                                                      ./libraries/cmd_xbar_mux                                                                     
ensure_lib                                                                                   ./libraries/cmd_xbar_demux_001                                                               
vmap       cmd_xbar_demux_001                                                                ./libraries/cmd_xbar_demux_001                                                               
ensure_lib                                                                                   ./libraries/cmd_xbar_demux                                                                   
vmap       cmd_xbar_demux                                                                    ./libraries/cmd_xbar_demux                                                                   
ensure_lib                                                                                   ./libraries/burst_adapter                                                                    
vmap       burst_adapter                                                                     ./libraries/burst_adapter                                                                    
ensure_lib                                                                                   ./libraries/id_router_002                                                                    
vmap       id_router_002                                                                     ./libraries/id_router_002                                                                    
ensure_lib                                                                                   ./libraries/id_router_001                                                                    
vmap       id_router_001                                                                     ./libraries/id_router_001                                                                    
ensure_lib                                                                                   ./libraries/id_router                                                                        
vmap       id_router                                                                         ./libraries/id_router                                                                        
ensure_lib                                                                                   ./libraries/addr_router_001                                                                  
vmap       addr_router_001                                                                   ./libraries/addr_router_001                                                                  
ensure_lib                                                                                   ./libraries/addr_router                                                                      
vmap       addr_router                                                                       ./libraries/addr_router                                                                      
ensure_lib                                                                                   ./libraries/onchip_memory2_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo           
vmap       onchip_memory2_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo            ./libraries/onchip_memory2_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo           
ensure_lib                                                                                   ./libraries/nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo
vmap       nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo ./libraries/nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo
ensure_lib                                                                                   ./libraries/nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent         
vmap       nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent          ./libraries/nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent         
ensure_lib                                                                                   ./libraries/nios2_qsys_0_instruction_master_translator_avalon_universal_master_0_agent       
vmap       nios2_qsys_0_instruction_master_translator_avalon_universal_master_0_agent        ./libraries/nios2_qsys_0_instruction_master_translator_avalon_universal_master_0_agent       
ensure_lib                                                                                   ./libraries/nios2_qsys_0_jtag_debug_module_translator                                        
vmap       nios2_qsys_0_jtag_debug_module_translator                                         ./libraries/nios2_qsys_0_jtag_debug_module_translator                                        
ensure_lib                                                                                   ./libraries/nios2_qsys_0_instruction_master_translator                                       
vmap       nios2_qsys_0_instruction_master_translator                                        ./libraries/nios2_qsys_0_instruction_master_translator                                       
ensure_lib                                                                                   ./libraries/rst_controller                                                                   
vmap       rst_controller                                                                    ./libraries/rst_controller                                                                   
ensure_lib                                                                                   ./libraries/irq_mapper                                                                       
vmap       irq_mapper                                                                        ./libraries/irq_mapper                                                                       
ensure_lib                                                                                   ./libraries/mm_interconnect_1                                                                
vmap       mm_interconnect_1                                                                 ./libraries/mm_interconnect_1                                                                
ensure_lib                                                                                   ./libraries/mm_interconnect_0                                                                
vmap       mm_interconnect_0                                                                 ./libraries/mm_interconnect_0                                                                
ensure_lib                                                                                   ./libraries/Bus_CAN_0                                                                        
vmap       Bus_CAN_0                                                                         ./libraries/Bus_CAN_0                                                                        
ensure_lib                                                                                   ./libraries/onchip_memory2_1                                                                 
vmap       onchip_memory2_1                                                                  ./libraries/onchip_memory2_1                                                                 
ensure_lib                                                                                   ./libraries/onchip_memory2_0                                                                 
vmap       onchip_memory2_0                                                                  ./libraries/onchip_memory2_0                                                                 
ensure_lib                                                                                   ./libraries/nios2_qsys_1                                                                     
vmap       nios2_qsys_1                                                                      ./libraries/nios2_qsys_1                                                                     
ensure_lib                                                                                   ./libraries/nios2_qsys_0                                                                     
vmap       nios2_qsys_0                                                                      ./libraries/nios2_qsys_0                                                                     
ensure_lib                                                                                   ./libraries/Can_controller_0                                                                 
vmap       Can_controller_0                                                                  ./libraries/Can_controller_0                                                                 

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  vlog +define+SKIP_KEYWORDS_PRAGMA "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"              -work altera_ver      
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                       -work lpm_ver         
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                          -work sgate_ver       
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                      -work altera_mf_ver   
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                  -work altera_lnsim_ver
  vlog                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiii_atoms.v"               -work cycloneiii_ver  
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_syn_attributes.vhd"        -work altera          
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_standard_functions.vhd"    -work altera          
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/alt_dspbuilder_package.vhd"       -work altera          
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_europa_support_lib.vhd"    -work altera          
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives_components.vhd" -work altera          
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.vhd"            -work altera          
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/220pack.vhd"                      -work lpm             
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.vhd"                     -work lpm             
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate_pack.vhd"                   -work sgate           
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.vhd"                        -work sgate           
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf_components.vhd"         -work altera_mf       
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.vhd"                    -work altera_mf       
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim_components.vhd"      -work altera_lnsim    
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiii_atoms.vhd"             -work cycloneiii      
  vcom                              "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiii_components.vhd"        -work cycloneiii      
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vlog  "$QSYS_SIMDIR/submodules/aldec/altera_merlin_width_adapter.sv"                                                                                -work width_adapter                                                                    
  vlog  "$QSYS_SIMDIR/submodules/aldec/altera_merlin_address_alignment.sv"                                                                            -work width_adapter                                                                    
  vlog  "$QSYS_SIMDIR/submodules/aldec/altera_merlin_burst_uncompressor.sv"                                                                           -work width_adapter                                                                    
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_rsp_xbar_mux_001.vho"                                                                  -work rsp_xbar_mux_001                                                                 
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_rsp_xbar_mux.vho"                                                                      -work rsp_xbar_mux                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_rsp_xbar_demux_002.vho"                                                                -work rsp_xbar_demux_002                                                               
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_cmd_xbar_mux_002.vho"                                                                  -work cmd_xbar_mux_002                                                                 
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_cmd_xbar_mux.vho"                                                                      -work cmd_xbar_mux                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_cmd_xbar_demux_001.vho"                                                                -work cmd_xbar_demux_001                                                               
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_cmd_xbar_demux.vho"                                                                    -work cmd_xbar_demux                                                                   
  vlog  "$QSYS_SIMDIR/submodules/aldec/altera_merlin_burst_adapter.sv"                                                                                -work burst_adapter                                                                    
  vlog  "$QSYS_SIMDIR/submodules/aldec/altera_merlin_address_alignment.sv"                                                                            -work burst_adapter                                                                    
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_id_router_002.vho"                                                                     -work id_router_002                                                                    
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_id_router_001.vho"                                                                     -work id_router_001                                                                    
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_id_router.vho"                                                                         -work id_router                                                                        
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_addr_router_001.vho"                                                                   -work addr_router_001                                                                  
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_addr_router.vho"                                                                       -work addr_router                                                                      
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_onchip_memory2_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo.vho"            -work onchip_memory2_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo           
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0_nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo.vho" -work nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo
  vlog  "$QSYS_SIMDIR/submodules/aldec/altera_merlin_slave_agent.sv"                                                                                  -work nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent         
  vlog  "$QSYS_SIMDIR/submodules/aldec/altera_merlin_burst_uncompressor.sv"                                                                           -work nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent         
  vlog  "$QSYS_SIMDIR/submodules/aldec/altera_merlin_master_agent.sv"                                                                                 -work nios2_qsys_0_instruction_master_translator_avalon_universal_master_0_agent       
  vlog  "$QSYS_SIMDIR/submodules/aldec/altera_merlin_slave_translator.sv"                                                                             -work nios2_qsys_0_jtag_debug_module_translator                                        
  vlog  "$QSYS_SIMDIR/submodules/aldec/altera_merlin_master_translator.sv"                                                                            -work nios2_qsys_0_instruction_master_translator                                       
  vlog  "$QSYS_SIMDIR/submodules/aldec/altera_reset_controller.v"                                                                                     -work rst_controller                                                                   
  vlog  "$QSYS_SIMDIR/submodules/aldec/altera_reset_synchronizer.v"                                                                                   -work rst_controller                                                                   
  vcom  "$QSYS_SIMDIR/submodules/Network_can_irq_mapper.vho"                                                                                          -work irq_mapper                                                                       
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_1.vhd"                                                                                   -work mm_interconnect_1                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_nios2_qsys_1_jtag_debug_module_translator.vhd"                                         -work mm_interconnect_1                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_onchip_memory2_1_s1_translator.vhd"                                                    -work mm_interconnect_1                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_can_controller_1_avalon_slave_0_translator.vhd"                                        -work mm_interconnect_1                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_nios2_qsys_1_jtag_debug_module_translator_avalon_universal_slave_0_agent.vhd"          -work mm_interconnect_1                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_onchip_memory2_1_s1_translator_avalon_universal_slave_0_agent.vhd"                     -work mm_interconnect_1                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_width_adapter.vhd"                                                                     -work mm_interconnect_1                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_width_adapter_002.vhd"                                                                 -work mm_interconnect_1                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_nios2_qsys_1_instruction_master_translator.vhd"                                        -work mm_interconnect_1                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_1_nios2_qsys_1_data_master_translator.vhd"                                               -work mm_interconnect_1                                                                
  vcom  "$QSYS_SIMDIR/submodules/Network_can_mm_interconnect_0.vhd"                                                                                   -work mm_interconnect_0                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_nios2_qsys_0_jtag_debug_module_translator.vhd"                                         -work mm_interconnect_0                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_onchip_memory2_0_s1_translator.vhd"                                                    -work mm_interconnect_0                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_can_controller_0_avalon_slave_0_translator.vhd"                                        -work mm_interconnect_0                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent.vhd"          -work mm_interconnect_0                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_onchip_memory2_0_s1_translator_avalon_universal_slave_0_agent.vhd"                     -work mm_interconnect_0                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_width_adapter.vhd"                                                                     -work mm_interconnect_0                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_width_adapter_002.vhd"                                                                 -work mm_interconnect_0                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_nios2_qsys_0_instruction_master_translator.vhd"                                        -work mm_interconnect_0                                                                
  vcom  "$QSYS_SIMDIR/submodules/network_can_mm_interconnect_0_nios2_qsys_0_data_master_translator.vhd"                                               -work mm_interconnect_0                                                                
  vcom  "$QSYS_SIMDIR/submodules/CAN_Bus.vhd"                                                                                                         -work Bus_CAN_0                                                                        
  vcom  "$QSYS_SIMDIR/submodules/Network_can_onchip_memory2_1.vhd"                                                                                    -work onchip_memory2_1                                                                 
  vcom  "$QSYS_SIMDIR/submodules/Network_can_onchip_memory2_0.vhd"                                                                                    -work onchip_memory2_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1.vhd"                                                                                        -work nios2_qsys_1                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_jtag_debug_module_sysclk.vhd"                                                               -work nios2_qsys_1                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_jtag_debug_module_tck.vhd"                                                                  -work nios2_qsys_1                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_jtag_debug_module_wrapper.vhd"                                                              -work nios2_qsys_1                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_oci_test_bench.vhd"                                                                         -work nios2_qsys_1                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_1_test_bench.vhd"                                                                             -work nios2_qsys_1                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0.vhd"                                                                                        -work nios2_qsys_0                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_jtag_debug_module_sysclk.vhd"                                                               -work nios2_qsys_0                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_jtag_debug_module_tck.vhd"                                                                  -work nios2_qsys_0                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_jtag_debug_module_wrapper.vhd"                                                              -work nios2_qsys_0                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_oci_test_bench.vhd"                                                                         -work nios2_qsys_0                                                                     
  vcom  "$QSYS_SIMDIR/submodules/Network_can_nios2_qsys_0_test_bench.vhd"                                                                             -work nios2_qsys_0                                                                     
  vcom  "$QSYS_SIMDIR/submodules/BSP_Interface.vhd"                                                                                                   -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/CAN_Baudrate_Prescaler.vhd"                                                                                          -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/CAN_Bit_Timing_Logic.vhd"                                                                                            -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/CAN_BSP.vhd"                                                                                                         -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/CAN_Bus.vhd"                                                                                                         -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/CAN_Control.vhd"                                                                                                     -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/CAN_Controller_Top.vhd"                                                                                              -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/CAN_CRC.vhd"                                                                                                         -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/CAN_Interface.vhd"                                                                                                   -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/CAN_Message.vhd"                                                                                                     -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/CAN_Register.vhd"                                                                                                    -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/CPU_Interface.vhd"                                                                                                   -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/submodules/SWITCH_CTRL_CPU.vhd"                                                                                                 -work Can_controller_0                                                                 
  vcom  "$QSYS_SIMDIR/Network_can.vhd"                                                                                                                                                                                                       
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim +access +r -t ps $ELAB_OPTIONS -L work -L width_adapter -L rsp_xbar_mux_001 -L rsp_xbar_mux -L rsp_xbar_demux_002 -L cmd_xbar_mux_002 -L cmd_xbar_mux -L cmd_xbar_demux_001 -L cmd_xbar_demux -L burst_adapter -L id_router_002 -L id_router_001 -L id_router -L addr_router_001 -L addr_router -L onchip_memory2_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo -L nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo -L nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent -L nios2_qsys_0_instruction_master_translator_avalon_universal_master_0_agent -L nios2_qsys_0_jtag_debug_module_translator -L nios2_qsys_0_instruction_master_translator -L rst_controller -L irq_mapper -L mm_interconnect_1 -L mm_interconnect_0 -L Bus_CAN_0 -L onchip_memory2_1 -L onchip_memory2_0 -L nios2_qsys_1 -L nios2_qsys_0 -L Can_controller_0 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiii $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with -dbg -O2 option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -dbg -O2 +access +r -t ps $ELAB_OPTIONS -L work -L width_adapter -L rsp_xbar_mux_001 -L rsp_xbar_mux -L rsp_xbar_demux_002 -L cmd_xbar_mux_002 -L cmd_xbar_mux -L cmd_xbar_demux_001 -L cmd_xbar_demux -L burst_adapter -L id_router_002 -L id_router_001 -L id_router -L addr_router_001 -L addr_router -L onchip_memory2_0_s1_translator_avalon_universal_slave_0_agent_rsp_fifo -L nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo -L nios2_qsys_0_jtag_debug_module_translator_avalon_universal_slave_0_agent -L nios2_qsys_0_instruction_master_translator_avalon_universal_master_0_agent -L nios2_qsys_0_jtag_debug_module_translator -L nios2_qsys_0_instruction_master_translator -L rst_controller -L irq_mapper -L mm_interconnect_1 -L mm_interconnect_0 -L Bus_CAN_0 -L onchip_memory2_1 -L onchip_memory2_0 -L nios2_qsys_1 -L nios2_qsys_0 -L Can_controller_0 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiii $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -dbg -O2
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                     -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with -dbg -O2 option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -dbg -O2"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR           -- Quartus installation directory."
}
file_copy
h
