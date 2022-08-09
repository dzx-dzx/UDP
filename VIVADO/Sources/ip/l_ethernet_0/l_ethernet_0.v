
//------------------------------------------------------------------------------
// (c) Copyright 1995-2013 Xilinx, Inc. All rights reserved.
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

`timescale 1fs/1fs


(* CHECK_LICENSE_TYPE = "l_ethernet_0,l_ethernet_core,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
(* CORE_GENERATION_INFO = "l_ethernet_0,l_ethernet_v2_5_0,{x_ipProduct=Vivado 2019.1,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=l_ethernet,x_ipVersion=2.5,x_ipCoreRevision=0,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_CORE=Ethernet MAC+PCS/PMA,C_RUNTIME_SWITCH=0,C_LINE_RATE=40,C_NUM_OF_LANES=4,C_NUM_OF_CORES=1,C_CLOCKING=Asynchronous,C_DATA_PATH_INTERFACE=256-bit Regular AXI4-Stream,C_BASE_R_KR=BASE-R,C_INCLUDE_FEC_LOGIC=0,C_INCLUDE_RSFEC_LOGIC=0,C_INCLUDE_KP4_RSFEC=0,C_INCLUDE_AUTO_NEG_LT_LOGIC=None,C_ANLT_CLK_IN_MHZ=100,C_INCLUDE_AXI4_INTERFACE=0,C_INCLUDE_STATISTICS_COUNTERS=0,C_STATISTICS_REGS_TYPE=0,C_INCLUDE_USER_FIFO=1,C_ENABLE_TX_FLOW_CONTROL_LOGIC=0,C_ENABLE_RX_FLOW_CONTROL_LOGIC=0,C_ENABLE_TIME_STAMPING=0,C_PTP_OPERATION_MODE=2,C_PTP_CLOCKING_MODE=0,C_TX_LATENCY_ADJUST=0,C_ENABLE_VLANE_ADJUST_MODE=0,C_GT_LOCATION=1,C_INS_LOSS_NYQ=30,C_RX_EQ_MODE=AUTO,C_GT_REF_CLK_FREQ=156.25,C_GT_DRP_CLK=100.00,C_GT_TYPE=GTY,C_GT_GROUP_SELECT=Quad X0Y0,C_LANE1_GT_LOC=X1Y40,C_LANE2_GT_LOC=X1Y41,C_LANE3_GT_LOC=X1Y42,C_LANE4_GT_LOC=X1Y43,C_ENABLE_PIPELINE_REG=0,C_ADD_GT_CNTRL_STS_PORTS=0,C_INCLUDE_SHARED_LOGIC=1,C_RX_FRAME_ERR_BASE=3,C_FAST_SIM_MODE=0,C_FAMILY_CHK=virtexuplus,IS_BOARD_PROJECT=0,C_AXIS_TDATA_WIDTH=256,C_AXIS_TUSR_WIDTH=1,C_IS_256BIT_TX_0=axis_rx_0,C_IS_256BIT_TX_1=axis_rx_1,C_GTM_GROUP_SELECT=NA,x_ipLicense=l_eth_mac_pcs@2019.04(design_linking),x_ipLicense=l_eth_basekr@2019.04(design_linking),x_ipLicense=l_eth_baser@2019.04(design_linking)}" *)
(* X_CORE_INFO = "l_ethernet_v2_5_0,Vivado 2019.1" *)

module l_ethernet_0 (
 
////// GT Signals
  gt_rxp_in_0,
  gt_rxn_in_0,
  gt_txp_out_0,
  gt_txn_out_0,
  gt_rxp_in_1,
  gt_rxn_in_1,
  gt_txp_out_1,
  gt_txn_out_1,
  gt_rxp_in_2,
  gt_rxn_in_2,
  gt_txp_out_2,
  gt_txn_out_2,
  gt_rxp_in_3,
  gt_rxn_in_3,
  gt_txp_out_3,
  gt_txn_out_3,
  tx_clk_out_0,
  rx_core_clk_0,
  rx_clk_out_0,
  rxrecclkout_0,
  gtwiz_reset_tx_datapath_0,
  gtwiz_reset_rx_datapath_0,
  gt_loopback_in_0,
//// RX_0 Signals
  rx_reset_0,
  user_rx_reset_0,

//// RX_0 User Interface  Signals

  rx_axis_tvalid_0,
  rx_axis_tdata_0,
  rx_axis_tkeep_0,
  rx_axis_tuser_0,
  rx_axis_tlast_0,
  rx_preambleout_0,



//// RX_0 Control Signals
  ctl_rx_test_pattern_0,
  ctl_rx_enable_0,
  ctl_rx_delete_fcs_0,
  ctl_rx_ignore_fcs_0,
  ctl_rx_max_packet_len_0,
  ctl_rx_min_packet_len_0,
  ctl_rx_custom_preamble_enable_0,
  ctl_rx_check_sfd_0,
  ctl_rx_check_preamble_0,
  ctl_rx_process_lfi_0,
  ctl_rx_force_resync_0,




//// RX_0 Stats Signals
  stat_rx_block_lock_0,
  stat_rx_framing_err_valid_0_0,
  stat_rx_framing_err_0_0,
  stat_rx_framing_err_valid_1_0,
  stat_rx_framing_err_1_0,
  stat_rx_framing_err_valid_2_0,
  stat_rx_framing_err_2_0,
  stat_rx_framing_err_valid_3_0,
  stat_rx_framing_err_3_0,
  stat_rx_vl_demuxed_0,
  stat_rx_vl_number_0_0,
  stat_rx_vl_number_1_0,
  stat_rx_vl_number_2_0,
  stat_rx_vl_number_3_0,
  stat_rx_synced_0,
  stat_rx_misaligned_0,
  stat_rx_aligned_err_0,
  stat_rx_synced_err_0,
  stat_rx_mf_len_err_0,
  stat_rx_mf_repeat_err_0,
  stat_rx_mf_err_0,
  stat_rx_bip_err_0_0,
  stat_rx_bip_err_1_0,
  stat_rx_bip_err_2_0,
  stat_rx_bip_err_3_0,
  stat_rx_aligned_0,
  stat_rx_hi_ber_0,
  stat_rx_status_0,
  stat_rx_bad_code_0,
  stat_rx_total_packets_0,
  stat_rx_total_good_packets_0,
  stat_rx_total_bytes_0,
  stat_rx_total_good_bytes_0,
  stat_rx_packet_small_0,
  stat_rx_jabber_0,
  stat_rx_packet_large_0,
  stat_rx_oversize_0,
  stat_rx_undersize_0,
  stat_rx_toolong_0,
  stat_rx_fragment_0,
  stat_rx_packet_64_bytes_0,
  stat_rx_packet_65_127_bytes_0,
  stat_rx_packet_128_255_bytes_0,
  stat_rx_packet_256_511_bytes_0,
  stat_rx_packet_512_1023_bytes_0,
  stat_rx_packet_1024_1518_bytes_0,
  stat_rx_packet_1519_1522_bytes_0,
  stat_rx_packet_1523_1548_bytes_0,
  stat_rx_bad_fcs_0,
  stat_rx_packet_bad_fcs_0,
  stat_rx_stomped_fcs_0,
  stat_rx_packet_1549_2047_bytes_0,
  stat_rx_packet_2048_4095_bytes_0,
  stat_rx_packet_4096_8191_bytes_0,
  stat_rx_packet_8192_9215_bytes_0,
  stat_rx_bad_preamble_0,
  stat_rx_bad_sfd_0,
  stat_rx_got_signal_os_0,
  stat_rx_test_pattern_mismatch_0,
  stat_rx_truncated_0,
  stat_rx_local_fault_0,
  stat_rx_remote_fault_0,
  stat_rx_internal_local_fault_0,
  stat_rx_received_local_fault_0,





//// TX_0 Signals
  tx_reset_0,
  user_tx_reset_0,

//// TX_0 User Interface  Signals
  tx_axis_tready_0,
  tx_axis_tvalid_0,
  tx_axis_tdata_0,
  tx_axis_tkeep_0,
  tx_axis_tuser_0,
  tx_axis_tlast_0,
  tx_unfout_0,
  tx_preamblein_0,

//// TX_0 Control Signals
  ctl_tx_test_pattern_0,
  ctl_tx_enable_0,
  ctl_tx_fcs_ins_enable_0,
  ctl_tx_ipg_value_0,
  ctl_tx_send_lfi_0,
  ctl_tx_send_rfi_0,
  ctl_tx_send_idle_0,
  ctl_tx_custom_preamble_enable_0,
  ctl_tx_ignore_fcs_0,


//// TX_0 Stats Signals
  stat_tx_underflow_err_0,
  stat_tx_overflow_err_0,
  stat_tx_total_packets_0,
  stat_tx_total_bytes_0,
  stat_tx_total_good_packets_0,
  stat_tx_total_good_bytes_0,
  stat_tx_packet_64_bytes_0,
  stat_tx_packet_65_127_bytes_0,
  stat_tx_packet_128_255_bytes_0,
  stat_tx_packet_256_511_bytes_0,
  stat_tx_packet_512_1023_bytes_0,
  stat_tx_packet_1024_1518_bytes_0,
  stat_tx_packet_1519_1522_bytes_0,
  stat_tx_packet_1523_1548_bytes_0,
  stat_tx_packet_small_0,
  stat_tx_packet_large_0,
  stat_tx_packet_1549_2047_bytes_0,
  stat_tx_packet_2048_4095_bytes_0,
  stat_tx_packet_4096_8191_bytes_0,
  stat_tx_packet_8192_9215_bytes_0,
  stat_tx_bad_fcs_0,
  stat_tx_frame_error_0,
  stat_tx_local_fault_0,












  gtpowergood_out_0,
  txoutclksel_in_0,
  rxoutclksel_in_0,

  gt_refclk_out,
  gt_refclk_p,
  gt_refclk_n,

  sys_reset,
  dclk
);
  

  input  wire gt_rxp_in_0;
  input  wire gt_rxn_in_0;
  output wire gt_txp_out_0;
  output wire gt_txn_out_0;


  input  wire gt_rxp_in_1;
  input  wire gt_rxn_in_1;
  output wire gt_txp_out_1;
  output wire gt_txn_out_1;


  input  wire gt_rxp_in_2;
  input  wire gt_rxn_in_2;
  output wire gt_txp_out_2;
  output wire gt_txn_out_2;


  input  wire gt_rxp_in_3;
  input  wire gt_rxn_in_3;
  output wire gt_txp_out_3;
  output wire gt_txn_out_3;


  output wire tx_clk_out_0;
  input wire rx_core_clk_0;
  output wire rx_clk_out_0;
  output wire [3:0] rxrecclkout_0;
  input wire gtwiz_reset_tx_datapath_0;
  input wire gtwiz_reset_rx_datapath_0;
  input  wire [11:0] gt_loopback_in_0;
//// RX_0 Signals
  input  wire rx_reset_0;
  output wire user_rx_reset_0;
//// RX_0 User Interface Signals
  output rx_axis_tvalid_0;
  output [255:0] rx_axis_tdata_0;
  output [31:0] rx_axis_tkeep_0;
  output rx_axis_tuser_0;
  output rx_axis_tlast_0;
  output [55:0] rx_preambleout_0;



//// RX_0 Control Signals
  input  wire ctl_rx_test_pattern_0;
  input  wire ctl_rx_enable_0;
  input  wire ctl_rx_delete_fcs_0;
  input  wire ctl_rx_ignore_fcs_0;
  input  wire [14:0] ctl_rx_max_packet_len_0;
  input  wire [7:0] ctl_rx_min_packet_len_0;
  input  wire ctl_rx_custom_preamble_enable_0;
  input  wire ctl_rx_check_sfd_0;
  input  wire ctl_rx_check_preamble_0;
  input  wire ctl_rx_process_lfi_0;
  input  wire ctl_rx_force_resync_0;


//// RX_0 Stats Signals
  output wire [3:0] stat_rx_block_lock_0;
  output wire stat_rx_framing_err_valid_0_0;
  output wire stat_rx_framing_err_0_0;
  output wire stat_rx_framing_err_valid_1_0;
  output wire stat_rx_framing_err_1_0;
  output wire stat_rx_framing_err_valid_2_0;
  output wire stat_rx_framing_err_2_0;
  output wire stat_rx_framing_err_valid_3_0;
  output wire stat_rx_framing_err_3_0;
  output wire [3:0] stat_rx_vl_demuxed_0;
  output wire [1:0] stat_rx_vl_number_0_0;
  output wire [1:0] stat_rx_vl_number_1_0;
  output wire [1:0] stat_rx_vl_number_2_0;
  output wire [1:0] stat_rx_vl_number_3_0;
  output wire [3:0] stat_rx_synced_0;
  output wire stat_rx_misaligned_0;
  output wire stat_rx_aligned_err_0;
  output wire [3:0] stat_rx_synced_err_0;
  output wire [3:0] stat_rx_mf_len_err_0;
  output wire [3:0] stat_rx_mf_repeat_err_0;
  output wire [3:0] stat_rx_mf_err_0;
  output wire stat_rx_bip_err_0_0;
  output wire stat_rx_bip_err_1_0;
  output wire stat_rx_bip_err_2_0;
  output wire stat_rx_bip_err_3_0;
  output wire stat_rx_aligned_0;
  output wire stat_rx_hi_ber_0;
  output wire stat_rx_status_0;
  output wire [1:0] stat_rx_bad_code_0;
  output wire [1:0] stat_rx_total_packets_0;
  output wire stat_rx_total_good_packets_0;
  output wire [5:0] stat_rx_total_bytes_0;
  output wire [13:0] stat_rx_total_good_bytes_0;
  output wire [1:0] stat_rx_packet_small_0;
  output wire stat_rx_jabber_0;
  output wire stat_rx_packet_large_0;
  output wire stat_rx_oversize_0;
  output wire [1:0] stat_rx_undersize_0;
  output wire stat_rx_toolong_0;
  output wire [1:0] stat_rx_fragment_0;
  output wire stat_rx_packet_64_bytes_0;
  output wire stat_rx_packet_65_127_bytes_0;
  output wire stat_rx_packet_128_255_bytes_0;
  output wire stat_rx_packet_256_511_bytes_0;
  output wire stat_rx_packet_512_1023_bytes_0;
  output wire stat_rx_packet_1024_1518_bytes_0;
  output wire stat_rx_packet_1519_1522_bytes_0;
  output wire stat_rx_packet_1523_1548_bytes_0;
  output wire [1:0] stat_rx_bad_fcs_0;
  output wire stat_rx_packet_bad_fcs_0;
  output wire [1:0] stat_rx_stomped_fcs_0;
  output wire stat_rx_packet_1549_2047_bytes_0;
  output wire stat_rx_packet_2048_4095_bytes_0;
  output wire stat_rx_packet_4096_8191_bytes_0;
  output wire stat_rx_packet_8192_9215_bytes_0;
  output wire stat_rx_bad_preamble_0;
  output wire stat_rx_bad_sfd_0;
  output wire stat_rx_got_signal_os_0;
  output wire [1:0] stat_rx_test_pattern_mismatch_0;
  output wire stat_rx_truncated_0;
  output wire stat_rx_local_fault_0;
  output wire stat_rx_remote_fault_0;
  output wire stat_rx_internal_local_fault_0;
  output wire stat_rx_received_local_fault_0;


//// TX_0 Signals
  input  wire tx_reset_0;
  output wire user_tx_reset_0;

//// TX_0 User Interface Signals
  output tx_axis_tready_0;
  input tx_axis_tvalid_0;
  input [255:0] tx_axis_tdata_0;
  input [31:0] tx_axis_tkeep_0;
  input tx_axis_tuser_0;
  input tx_axis_tlast_0;
  output tx_unfout_0;
  input wire [55:0] tx_preamblein_0;

//// TX_0 Control Signals
  input  wire ctl_tx_test_pattern_0;
  input  wire ctl_tx_enable_0;
  input  wire ctl_tx_fcs_ins_enable_0;
  input  wire [3:0] ctl_tx_ipg_value_0;
  input  wire ctl_tx_send_lfi_0;
  input  wire ctl_tx_send_rfi_0;
  input  wire ctl_tx_send_idle_0;
  input  wire ctl_tx_custom_preamble_enable_0;
  input  wire ctl_tx_ignore_fcs_0;


//// TX_0 Stats Signals
  output wire stat_tx_underflow_err_0;
  output wire stat_tx_overflow_err_0;
  output wire stat_tx_total_packets_0;
  output wire [4:0] stat_tx_total_bytes_0;
  output wire stat_tx_total_good_packets_0;
  output wire [13:0] stat_tx_total_good_bytes_0;
  output wire stat_tx_packet_64_bytes_0;
  output wire stat_tx_packet_65_127_bytes_0;
  output wire stat_tx_packet_128_255_bytes_0;
  output wire stat_tx_packet_256_511_bytes_0;
  output wire stat_tx_packet_512_1023_bytes_0;
  output wire stat_tx_packet_1024_1518_bytes_0;
  output wire stat_tx_packet_1519_1522_bytes_0;
  output wire stat_tx_packet_1523_1548_bytes_0;
  output wire stat_tx_packet_small_0;
  output wire stat_tx_packet_large_0;
  output wire stat_tx_packet_1549_2047_bytes_0;
  output wire stat_tx_packet_2048_4095_bytes_0;
  output wire stat_tx_packet_4096_8191_bytes_0;
  output wire stat_tx_packet_8192_9215_bytes_0;
  output wire stat_tx_bad_fcs_0;
  output wire stat_tx_frame_error_0;
  output wire stat_tx_local_fault_0;












  output wire gt_refclk_out;
  input  wire gt_refclk_p;
  input  wire gt_refclk_n;

  output wire [3:0] gtpowergood_out_0;
  input wire [11:0] txoutclksel_in_0;
  input wire [11:0] rxoutclksel_in_0;
  input  wire sys_reset;
  input  wire dclk;


  l_ethernet_0_wrapper #(
    .C_LINE_RATE(40),
    .C_NUM_OF_CORES(1),
    .C_CLOCKING("Asynchronous"),
    .C_DATA_PATH_INTERFACE("256-bit Regular AXI4-Stream"),
    .C_BASE_R_KR("BASE-R"),
    .C_INCLUDE_FEC_LOGIC("0"),
    .C_INCLUDE_RSFEC_LOGIC("0"),
    .C_INCLUDE_AUTO_NEG_LT_LOGIC("None"),
    .C_INCLUDE_USER_FIFO("1"),
    .C_ENABLE_TX_FLOW_CONTROL_LOGIC(0),
    .C_ENABLE_RX_FLOW_CONTROL_LOGIC(0),
    .C_ENABLE_TIME_STAMPING(0),
    .C_PTP_OPERATION_MODE(2),
    .C_PTP_CLOCKING_MODE(0),
    .C_TX_LATENCY_ADJUST(0),
    .C_ENABLE_VLANE_ADJUST_MODE(0),
    .C_GT_REF_CLK_FREQ(156.25),
    .C_GT_DRP_CLK(100.00),
    .C_GT_TYPE("GTY"),
    .C_LANE1_GT_LOC("X1Y40"),
    .C_LANE2_GT_LOC("X1Y41"),
    .C_LANE3_GT_LOC("X1Y42"),
    .C_LANE4_GT_LOC("X1Y43"),
    .C_ENABLE_PIPELINE_REG(0),
    .C_ADD_GT_CNTRL_STS_PORTS(0),
    .C_INCLUDE_SHARED_LOGIC(1)
  ) inst (
  
    .gt_rxp_in_0 (gt_rxp_in_0),
    .gt_rxn_in_0 (gt_rxn_in_0),
    .gt_txp_out_0 (gt_txp_out_0),
    .gt_txn_out_0 (gt_txn_out_0),
    .gt_rxp_in_1 (gt_rxp_in_1),
    .gt_rxn_in_1 (gt_rxn_in_1),
    .gt_txp_out_1 (gt_txp_out_1),
    .gt_txn_out_1 (gt_txn_out_1),
    .gt_rxp_in_2 (gt_rxp_in_2),
    .gt_rxn_in_2 (gt_rxn_in_2),
    .gt_txp_out_2 (gt_txp_out_2),
    .gt_txn_out_2 (gt_txn_out_2),
    .gt_rxp_in_3 (gt_rxp_in_3),
    .gt_rxn_in_3 (gt_rxn_in_3),
    .gt_txp_out_3 (gt_txp_out_3),
    .gt_txn_out_3 (gt_txn_out_3),

    .tx_clk_out_0 (tx_clk_out_0),
    .rx_core_clk_0 (rx_core_clk_0),
    .rx_clk_out_0 (rx_clk_out_0),
    .rxrecclkout_0 (rxrecclkout_0),
    .gtwiz_reset_tx_datapath_0 (gtwiz_reset_tx_datapath_0),
    .gtwiz_reset_rx_datapath_0 (gtwiz_reset_rx_datapath_0),

    .gt_loopback_in_0 (gt_loopback_in_0),

    .rx_reset_0(rx_reset_0),
    .user_rx_reset_0 (user_rx_reset_0),

//// RX User Interface Signals
  .rx_axis_tvalid_0 (rx_axis_tvalid_0),
  .rx_axis_tdata_0  (rx_axis_tdata_0),
  .rx_axis_tkeep_0  (rx_axis_tkeep_0),
  .rx_axis_tuser_0  (rx_axis_tuser_0),
  .rx_axis_tlast_0  (rx_axis_tlast_0),
  .rx_preambleout_0 (rx_preambleout_0),






//// RX Control Signals
    .ctl_rx_test_pattern_0 (ctl_rx_test_pattern_0),
    .ctl_rx_enable_0 (ctl_rx_enable_0),
    .ctl_rx_delete_fcs_0 (ctl_rx_delete_fcs_0),
    .ctl_rx_ignore_fcs_0 (ctl_rx_ignore_fcs_0),
    .ctl_rx_max_packet_len_0 (ctl_rx_max_packet_len_0),
    .ctl_rx_min_packet_len_0 (ctl_rx_min_packet_len_0),
    .ctl_rx_custom_preamble_enable_0 (ctl_rx_custom_preamble_enable_0),
    .ctl_rx_check_sfd_0 (ctl_rx_check_sfd_0),
    .ctl_rx_check_preamble_0 (ctl_rx_check_preamble_0),
    .ctl_rx_process_lfi_0 (ctl_rx_process_lfi_0),
    .ctl_rx_force_resync_0 (ctl_rx_force_resync_0),





//// RX Stats Signals
    .stat_rx_block_lock_0 (stat_rx_block_lock_0),
    .stat_rx_framing_err_valid_0_0 (stat_rx_framing_err_valid_0_0),
    .stat_rx_framing_err_0_0 (stat_rx_framing_err_0_0),
    .stat_rx_framing_err_valid_1_0 (stat_rx_framing_err_valid_1_0),
    .stat_rx_framing_err_1_0 (stat_rx_framing_err_1_0),
    .stat_rx_framing_err_valid_2_0 (stat_rx_framing_err_valid_2_0),
    .stat_rx_framing_err_2_0 (stat_rx_framing_err_2_0),
    .stat_rx_framing_err_valid_3_0 (stat_rx_framing_err_valid_3_0),
    .stat_rx_framing_err_3_0 (stat_rx_framing_err_3_0),
    .stat_rx_vl_demuxed_0 (stat_rx_vl_demuxed_0),
    .stat_rx_vl_number_0_0 (stat_rx_vl_number_0_0),
    .stat_rx_vl_number_1_0 (stat_rx_vl_number_1_0),
    .stat_rx_vl_number_2_0 (stat_rx_vl_number_2_0),
    .stat_rx_vl_number_3_0 (stat_rx_vl_number_3_0),
    .stat_rx_synced_0 (stat_rx_synced_0),
    .stat_rx_misaligned_0 (stat_rx_misaligned_0),
    .stat_rx_aligned_err_0 (stat_rx_aligned_err_0),
    .stat_rx_synced_err_0 (stat_rx_synced_err_0),
    .stat_rx_mf_len_err_0 (stat_rx_mf_len_err_0),
    .stat_rx_mf_repeat_err_0 (stat_rx_mf_repeat_err_0),
    .stat_rx_mf_err_0 (stat_rx_mf_err_0),
    .stat_rx_bip_err_0_0 (stat_rx_bip_err_0_0),
    .stat_rx_bip_err_1_0 (stat_rx_bip_err_1_0),
    .stat_rx_bip_err_2_0 (stat_rx_bip_err_2_0),
    .stat_rx_bip_err_3_0 (stat_rx_bip_err_3_0),
    .stat_rx_aligned_0 (stat_rx_aligned_0),
    .stat_rx_hi_ber_0 (stat_rx_hi_ber_0),
    .stat_rx_status_0 (stat_rx_status_0),
    .stat_rx_bad_code_0 (stat_rx_bad_code_0),
    .stat_rx_total_packets_0 (stat_rx_total_packets_0),
    .stat_rx_total_good_packets_0 (stat_rx_total_good_packets_0),
    .stat_rx_total_bytes_0 (stat_rx_total_bytes_0),
    .stat_rx_total_good_bytes_0 (stat_rx_total_good_bytes_0),
    .stat_rx_packet_small_0 (stat_rx_packet_small_0),
    .stat_rx_jabber_0 (stat_rx_jabber_0),
    .stat_rx_packet_large_0 (stat_rx_packet_large_0),
    .stat_rx_oversize_0 (stat_rx_oversize_0),
    .stat_rx_undersize_0 (stat_rx_undersize_0),
    .stat_rx_toolong_0 (stat_rx_toolong_0),
    .stat_rx_fragment_0 (stat_rx_fragment_0),
    .stat_rx_packet_64_bytes_0 (stat_rx_packet_64_bytes_0),
    .stat_rx_packet_65_127_bytes_0 (stat_rx_packet_65_127_bytes_0),
    .stat_rx_packet_128_255_bytes_0 (stat_rx_packet_128_255_bytes_0),
    .stat_rx_packet_256_511_bytes_0 (stat_rx_packet_256_511_bytes_0),
    .stat_rx_packet_512_1023_bytes_0 (stat_rx_packet_512_1023_bytes_0),
    .stat_rx_packet_1024_1518_bytes_0 (stat_rx_packet_1024_1518_bytes_0),
    .stat_rx_packet_1519_1522_bytes_0 (stat_rx_packet_1519_1522_bytes_0),
    .stat_rx_packet_1523_1548_bytes_0 (stat_rx_packet_1523_1548_bytes_0),
    .stat_rx_bad_fcs_0 (stat_rx_bad_fcs_0),
    .stat_rx_packet_bad_fcs_0 (stat_rx_packet_bad_fcs_0),
    .stat_rx_stomped_fcs_0 (stat_rx_stomped_fcs_0),
    .stat_rx_packet_1549_2047_bytes_0 (stat_rx_packet_1549_2047_bytes_0),
    .stat_rx_packet_2048_4095_bytes_0 (stat_rx_packet_2048_4095_bytes_0),
    .stat_rx_packet_4096_8191_bytes_0 (stat_rx_packet_4096_8191_bytes_0),
    .stat_rx_packet_8192_9215_bytes_0 (stat_rx_packet_8192_9215_bytes_0),
    .stat_rx_bad_preamble_0 (stat_rx_bad_preamble_0),
    .stat_rx_bad_sfd_0 (stat_rx_bad_sfd_0),
    .stat_rx_got_signal_os_0 (stat_rx_got_signal_os_0),
    .stat_rx_test_pattern_mismatch_0 (stat_rx_test_pattern_mismatch_0),
    .stat_rx_truncated_0 (stat_rx_truncated_0),
    .stat_rx_local_fault_0 (stat_rx_local_fault_0),
    .stat_rx_remote_fault_0 (stat_rx_remote_fault_0),
    .stat_rx_internal_local_fault_0 (stat_rx_internal_local_fault_0),
    .stat_rx_received_local_fault_0 (stat_rx_received_local_fault_0),



    .tx_reset_0 (tx_reset_0),
    .user_tx_reset_0 (user_tx_reset_0),
//// TX User Interface Signals
  .tx_axis_tready_0 (tx_axis_tready_0),
  .tx_axis_tvalid_0 (tx_axis_tvalid_0),
  .tx_axis_tdata_0  (tx_axis_tdata_0),
  .tx_axis_tkeep_0  (tx_axis_tkeep_0),
  .tx_axis_tuser_0  (tx_axis_tuser_0),
  .tx_axis_tlast_0  (tx_axis_tlast_0),
  .tx_unfout_0      (tx_unfout_0),
  .tx_preamblein_0 (tx_preamblein_0),

//// TX Control Signals
    .ctl_tx_test_pattern_0 (ctl_tx_test_pattern_0),
    .ctl_tx_enable_0 (ctl_tx_enable_0),
    .ctl_tx_fcs_ins_enable_0 (ctl_tx_fcs_ins_enable_0),
    .ctl_tx_ipg_value_0 (ctl_tx_ipg_value_0),
    .ctl_tx_send_lfi_0 (ctl_tx_send_lfi_0),
    .ctl_tx_send_rfi_0 (ctl_tx_send_rfi_0),
    .ctl_tx_send_idle_0 (ctl_tx_send_idle_0),
    .ctl_tx_custom_preamble_enable_0 (ctl_tx_custom_preamble_enable_0),
    .ctl_tx_ignore_fcs_0 (ctl_tx_ignore_fcs_0),


//// TX Stats Signals
    .stat_tx_underflow_err_0 (stat_tx_underflow_err_0),
    .stat_tx_overflow_err_0 (stat_tx_overflow_err_0),
    .stat_tx_total_packets_0 (stat_tx_total_packets_0),
    .stat_tx_total_bytes_0 (stat_tx_total_bytes_0),
    .stat_tx_total_good_packets_0 (stat_tx_total_good_packets_0),
    .stat_tx_total_good_bytes_0 (stat_tx_total_good_bytes_0),
    .stat_tx_packet_64_bytes_0 (stat_tx_packet_64_bytes_0),
    .stat_tx_packet_65_127_bytes_0 (stat_tx_packet_65_127_bytes_0),
    .stat_tx_packet_128_255_bytes_0 (stat_tx_packet_128_255_bytes_0),
    .stat_tx_packet_256_511_bytes_0 (stat_tx_packet_256_511_bytes_0),
    .stat_tx_packet_512_1023_bytes_0 (stat_tx_packet_512_1023_bytes_0),
    .stat_tx_packet_1024_1518_bytes_0 (stat_tx_packet_1024_1518_bytes_0),
    .stat_tx_packet_1519_1522_bytes_0 (stat_tx_packet_1519_1522_bytes_0),
    .stat_tx_packet_1523_1548_bytes_0 (stat_tx_packet_1523_1548_bytes_0),
    .stat_tx_packet_small_0 (stat_tx_packet_small_0),
    .stat_tx_packet_large_0 (stat_tx_packet_large_0),
    .stat_tx_packet_1549_2047_bytes_0 (stat_tx_packet_1549_2047_bytes_0),
    .stat_tx_packet_2048_4095_bytes_0 (stat_tx_packet_2048_4095_bytes_0),
    .stat_tx_packet_4096_8191_bytes_0 (stat_tx_packet_4096_8191_bytes_0),
    .stat_tx_packet_8192_9215_bytes_0 (stat_tx_packet_8192_9215_bytes_0),
    .stat_tx_bad_fcs_0 (stat_tx_bad_fcs_0),
    .stat_tx_frame_error_0 (stat_tx_frame_error_0),
    .stat_tx_local_fault_0 (stat_tx_local_fault_0),






    .gtpowergood_out_0 (gtpowergood_out_0),
    .txoutclksel_in_0 (txoutclksel_in_0),
    .rxoutclksel_in_0 (rxoutclksel_in_0),
    .gt_refclk_p(gt_refclk_p),
    .gt_refclk_n(gt_refclk_n),
    .gt_refclk_out(gt_refclk_out),
    .sys_reset(sys_reset),
    .dclk(dclk)

  );
endmodule



