// (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:ip:gt_reset_ip:1.1
// IP Revision: 2

(* X_CORE_INFO = "l_ethernet_0_everest_gt_reset_controller_0_inst,Vivado 2022.1" *)
(* CHECK_LICENSE_TYPE = "l_ethernet_0_everest_gt_reset_controller_0,l_ethernet_0_everest_gt_reset_controller_0_inst,{}" *)
(* CORE_GENERATION_INFO = "l_ethernet_0_everest_gt_reset_controller_0,l_ethernet_0_everest_gt_reset_controller_0_inst,{x_ipProduct=Vivado 2022.1,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=gt_reset_ip,x_ipVersion=1.1,x_ipCoreRevision=2,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,MASTER_RESET_EN=1,P_FREERUN_FREQUENCY=100.00,P_TX_PLL_TYPE=0,P_RX_PLL_TYPE=0,P_RX_LINE_RATE=10.3125}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module l_ethernet_0_everest_gt_reset_controller_0 (
  gtwiz_reset_clk_freerun_in,
  gtwiz_reset_all_in,
  gtwiz_reset_tx_pll_and_datapath_in,
  gtwiz_reset_tx_datapath_in,
  gtwiz_reset_rx_pll_and_datapath_in,
  gtwiz_reset_rx_datapath_in,
  gtwiz_reset_rx_cdr_stable_out,
  gtwiz_reset_tx_done_out,
  gtwiz_reset_rx_done_out,
  gtwiz_reset_userclk_tx_active_in,
  gtwiz_reset_userclk_rx_active_in,
  gtpowergood_in,
  txusrclk2_in,
  ilo_reset_done,
  plllock_tx_in,
  txresetdone_in,
  rxusrclk2_in,
  plllock_rx_in,
  rxcdrlock_in,
  rxresetdone_in,
  pllreset_tx_out,
  txprogdivreset_out,
  iloreset_out,
  mst_tx_reset,
  mst_rx_reset,
  mst_tx_dp_reset,
  mst_rx_dp_reset,
  mst_tx_resetdone,
  mst_rx_resetdone,
  pcie_enable,
  pcie_rstb_out,
  gttxreset_out,
  txuserrdy_out,
  pllreset_rx_out,
  rxprogdivreset_out,
  gtrxreset_out,
  rxuserrdy_out,
  tx_enabled_tie_in,
  rx_enabled_tie_in,
  shared_pll_tie_in
);

input wire gtwiz_reset_clk_freerun_in;
input wire gtwiz_reset_all_in;
input wire gtwiz_reset_tx_pll_and_datapath_in;
input wire gtwiz_reset_tx_datapath_in;
input wire gtwiz_reset_rx_pll_and_datapath_in;
input wire gtwiz_reset_rx_datapath_in;
output wire gtwiz_reset_rx_cdr_stable_out;
output wire gtwiz_reset_tx_done_out;
output wire gtwiz_reset_rx_done_out;
input wire gtwiz_reset_userclk_tx_active_in;
input wire gtwiz_reset_userclk_rx_active_in;
input wire gtpowergood_in;
input wire txusrclk2_in;
input wire ilo_reset_done;
input wire plllock_tx_in;
input wire txresetdone_in;
input wire rxusrclk2_in;
input wire plllock_rx_in;
input wire rxcdrlock_in;
input wire rxresetdone_in;
output wire pllreset_tx_out;
output wire txprogdivreset_out;
output wire iloreset_out;
output wire mst_tx_reset;
output wire mst_rx_reset;
output wire mst_tx_dp_reset;
output wire mst_rx_dp_reset;
input wire mst_tx_resetdone;
input wire mst_rx_resetdone;
input wire pcie_enable;
output wire pcie_rstb_out;
output wire gttxreset_out;
output wire txuserrdy_out;
output wire pllreset_rx_out;
output wire rxprogdivreset_out;
output wire gtrxreset_out;
output wire rxuserrdy_out;
input wire tx_enabled_tie_in;
input wire rx_enabled_tie_in;
input wire shared_pll_tie_in;

  l_ethernet_0_everest_gt_reset_controller_0_inst #(
    .MASTER_RESET_EN(1),
    .P_FREERUN_FREQUENCY(100.00),
    .P_TX_PLL_TYPE(0),
    .P_RX_PLL_TYPE(0),
    .P_RX_LINE_RATE(10.3125)
  ) inst (
    .gtwiz_reset_clk_freerun_in(gtwiz_reset_clk_freerun_in),
    .gtwiz_reset_all_in(gtwiz_reset_all_in),
    .gtwiz_reset_tx_pll_and_datapath_in(gtwiz_reset_tx_pll_and_datapath_in),
    .gtwiz_reset_tx_datapath_in(gtwiz_reset_tx_datapath_in),
    .gtwiz_reset_rx_pll_and_datapath_in(gtwiz_reset_rx_pll_and_datapath_in),
    .gtwiz_reset_rx_datapath_in(gtwiz_reset_rx_datapath_in),
    .gtwiz_reset_rx_cdr_stable_out(gtwiz_reset_rx_cdr_stable_out),
    .gtwiz_reset_tx_done_out(gtwiz_reset_tx_done_out),
    .gtwiz_reset_rx_done_out(gtwiz_reset_rx_done_out),
    .gtwiz_reset_userclk_tx_active_in(gtwiz_reset_userclk_tx_active_in),
    .gtwiz_reset_userclk_rx_active_in(gtwiz_reset_userclk_rx_active_in),
    .gtpowergood_in(gtpowergood_in),
    .txusrclk2_in(txusrclk2_in),
    .ilo_reset_done(ilo_reset_done),
    .plllock_tx_in(plllock_tx_in),
    .txresetdone_in(txresetdone_in),
    .rxusrclk2_in(rxusrclk2_in),
    .plllock_rx_in(plllock_rx_in),
    .rxcdrlock_in(rxcdrlock_in),
    .rxresetdone_in(rxresetdone_in),
    .pllreset_tx_out(pllreset_tx_out),
    .txprogdivreset_out(txprogdivreset_out),
    .iloreset_out(iloreset_out),
    .mst_tx_reset(mst_tx_reset),
    .mst_rx_reset(mst_rx_reset),
    .mst_tx_dp_reset(mst_tx_dp_reset),
    .mst_rx_dp_reset(mst_rx_dp_reset),
    .mst_tx_resetdone(mst_tx_resetdone),
    .mst_rx_resetdone(mst_rx_resetdone),
    .pcie_enable(pcie_enable),
    .pcie_rstb_out(pcie_rstb_out),
    .gttxreset_out(gttxreset_out),
    .txuserrdy_out(txuserrdy_out),
    .pllreset_rx_out(pllreset_rx_out),
    .rxprogdivreset_out(rxprogdivreset_out),
    .gtrxreset_out(gtrxreset_out),
    .rxuserrdy_out(rxuserrdy_out),
    .tx_enabled_tie_in(tx_enabled_tie_in),
    .rx_enabled_tie_in(rx_enabled_tie_in),
    .shared_pll_tie_in(shared_pll_tie_in)
  );
endmodule
