-- (C) 2001-2013 Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions and other 
-- software and tools, and its AMPP partner logic functions, and any output 
-- files any of the foregoing (including device programming or simulation 
-- files), and any associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License Subscription 
-- Agreement, Altera MegaCore Function License Agreement, or other applicable 
-- license agreement, including, without limitation, that your use is for the 
-- sole purpose of programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the applicable 
-- agreement for further details.


-- $Id: //acds/main/ip/sopc/components/verification/altera_tristate_conduit_bfm/altera_tristate_conduit_bfm.sv.terp#7 $
-- $Revision: #7 $
-- $Date: 2010/08/05 $
-- $Author: klong $
-------------------------------------------------------------------------------
-- =head1 NAME
-- altera_conduit_bfm
-- =head1 SYNOPSIS
-- Bus Functional Model (BFM) for a Standard Conduit BFM
-------------------------------------------------------------------------------
-- =head1 DESCRIPTION
-- This is a Bus Functional Model (BFM) for a Standard Conduit Master.
-- This BFM sampled the input/bidirection port value or driving user's value to 
-- output ports when user call the API.  
-- This BFM's HDL is been generated through terp file in Qsys/SOPC Builder.
-- Generation parameters:
-- output_name:                  altera_conduit_bfm
-- role:width:direction:         rx_i:1:output,tx_o:1:input,bus_off_on:1:input,irq_on:1:input,clkout_o:1:input
-- clocked                       0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.altera_conduit_bfm_vhdl_pkg.all;

entity altera_conduit_bfm is
   port (
      sig_rx_i         : out   std_logic_vector(0 downto 0);
      sig_tx_o         : in    std_logic_vector(0 downto 0);
      sig_bus_off_on   : in    std_logic_vector(0 downto 0);
      sig_irq_on       : in    std_logic_vector(0 downto 0);
      sig_clkout_o     : in    std_logic_vector(0 downto 0)
   );
end altera_conduit_bfm;

architecture altera_conduit_bfm_arch of altera_conduit_bfm is 

      signal update : std_logic := '0';

   begin
      process begin
         wait for 1 ps;
         update <= not update;
      end process;

      process (update) begin
         sig_rx_i         <= out_trans.rx_i_out after 1 ps;
         tx_o_in          <= sig_tx_o;
         bus_off_on_in    <= sig_bus_off_on;
         irq_on_in        <= sig_irq_on;
         clkout_o_in      <= sig_clkout_o;
      end process;

end altera_conduit_bfm_arch;

