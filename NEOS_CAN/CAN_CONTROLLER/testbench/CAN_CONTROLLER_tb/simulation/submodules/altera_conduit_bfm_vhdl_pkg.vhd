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
-- This is a Bus Functional Model (BFM) VHDL package for a Standard Conduit Master.
-- This package provides the API that will be used to get the value of the sampled
-- input/bidirection port or set the value to be driven to the output ports.
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






package altera_conduit_bfm_vhdl_pkg is

   -- output signal register
   type altera_conduit_bfm_out_trans_t is record
      rx_i_out               : std_logic_vector(0 downto 0);
   end record;
   
   shared variable out_trans        : altera_conduit_bfm_out_trans_t;

   -- input signal register
   signal tx_o_in                : std_logic_vector(0 downto 0);
   signal bus_off_on_in          : std_logic_vector(0 downto 0);
   signal irq_on_in              : std_logic_vector(0 downto 0);
   signal clkout_o_in            : std_logic_vector(0 downto 0);

   -- VHDL Procedure API
   
   -- set rx_i value
   procedure set_rx_i                   (signal_value : in std_logic_vector(0 downto 0));
   
   -- get tx_o value
   procedure get_tx_o                   (signal_value : out std_logic_vector(0 downto 0));
   
   -- get bus_off_on value
   procedure get_bus_off_on             (signal_value : out std_logic_vector(0 downto 0));
   
   -- get irq_on value
   procedure get_irq_on                 (signal_value : out std_logic_vector(0 downto 0));
   
   -- get clkout_o value
   procedure get_clkout_o               (signal_value : out std_logic_vector(0 downto 0));
   
   -- VHDL Event API

   procedure event_tx_o_change;   

   procedure event_bus_off_on_change;   

   procedure event_irq_on_change;   

   procedure event_clkout_o_change;   

end altera_conduit_bfm_vhdl_pkg;

package body altera_conduit_bfm_vhdl_pkg is
   
   procedure set_rx_i                   (signal_value : in std_logic_vector(0 downto 0)) is
   begin
      
      out_trans.rx_i_out := signal_value;
      
   end procedure set_rx_i;
   
   procedure get_tx_o                   (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := tx_o_in;
   
   end procedure get_tx_o;
   
   procedure get_bus_off_on             (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := bus_off_on_in;
   
   end procedure get_bus_off_on;
   
   procedure get_irq_on                 (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := irq_on_in;
   
   end procedure get_irq_on;
   
   procedure get_clkout_o               (signal_value : out std_logic_vector(0 downto 0)) is
   begin

      signal_value := clkout_o_in;
   
   end procedure get_clkout_o;
   
   procedure event_tx_o_change is
   begin

      wait until (tx_o_in'event);

   end event_tx_o_change;
   procedure event_bus_off_on_change is
   begin

      wait until (bus_off_on_in'event);

   end event_bus_off_on_change;
   procedure event_irq_on_change is
   begin

      wait until (irq_on_in'event);

   end event_irq_on_change;
   procedure event_clkout_o_change is
   begin

      wait until (clkout_o_in'event);

   end event_clkout_o_change;

end altera_conduit_bfm_vhdl_pkg;

