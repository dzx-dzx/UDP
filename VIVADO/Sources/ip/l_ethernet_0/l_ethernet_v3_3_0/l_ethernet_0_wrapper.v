// ------------------------------------------------------------------------------
//   (c) Copyright 2020-2021 Xilinx, Inc. All rights reserved.
// 
//   This file contains confidential and proprietary information
//   of Xilinx, Inc. and is protected under U.S. and
//   international copyright and other intellectual property
//   laws.
// 
//   DISCLAIMER
//   This disclaimer is not a license and does not grant any
//   rights to the materials distributed herewith. Except as
//   otherwise provided in a valid license issued to you by
//   Xilinx, and to the maximum extent permitted by applicable
//   law: (1) THESE MATERIALS ARE MADE AVAILABLE \"AS IS\" AND
//   WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//   AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//   BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//   INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//   (2) Xilinx shall not be liable (whether in contract or tort,
//   including negligence, or under any other theory of
//   liability) for any loss or damage of any kind or nature
//   related to, arising under or in connection with these
//   materials, including for any direct, or any indirect,
//   special, incidental, or consequential loss or damage
//   (including loss of data, profits, goodwill, or any type of
//   loss or damage suffered as a result of any action brought
//   by a third party) even if such damage or loss was
//   reasonably foreseeable or Xilinx had been advised of the
//   possibility of the same.
// 
//   CRITICAL APPLICATIONS
//   Xilinx products are not designed or intended to be fail-
//   safe, or for use in any application requiring fail-safe
//   performance, such as life-support or safety devices or
//   systems, Class III medical devices, nuclear facilities,
//   applications related to the deployment of airbags, or any
//   other applications that could lead to death, personal
//   injury, or severe property or environmental damage
//   (individually and collectively, \"Critical
//   Applications\"). Customer assumes the sole risk and
//   liability of any use of Xilinx products in Critical
//   Applications, subject only to applicable laws and
//   regulations governing limitations on product liability.
// 
//   THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//   PART OF THIS FILE AT ALL TIMES.
//
// 
//
//       Owner:          
//       Revision:       $Id: $
//                       $Author: $
//                       $DateTime: $
//                       $Change: $
//       Description:
//
// 
////------------------------------------------------------------------------------


`timescale 1fs/1fs

(* DowngradeIPIdentifiedWarnings="yes" *)
module l_ethernet_0_wrapper

#(
    ////PHYSICAL LAYER OPTIONS
    parameter   C_LINE_RATE                      =   50,
    parameter   C_NUM_OF_CORES                   =   2,
    parameter   C_CLOCKING                       =   "Synchronous",
    parameter   C_DATA_PATH_INTERFACE            =   "128-bit Straddled AXI4-Stream",
    parameter   C_BASE_R_KR                      =   "BASE-KR",
    parameter   C_INCLUDE_FEC_LOGIC              =   0,
    parameter   C_INCLUDE_RSFEC_LOGIC            =   0,
    parameter   C_INCLUDE_AUTO_NEG_LT_LOGIC      =   "None",
    parameter   C_INCLUDE_USER_FIFO              =   0,
    parameter   C_ENABLE_TX_FLOW_CONTROL_LOGIC   =   0,
    parameter   C_ENABLE_RX_FLOW_CONTROL_LOGIC   =   0,
    parameter   C_ENABLE_TIME_STAMPING           =   0,
    parameter   C_PTP_OPERATION_MODE             =   2,
    parameter   C_PTP_CLOCKING_MODE              =   0,
    parameter   C_TX_LATENCY_ADJUST              =   0,
    parameter   C_ENABLE_VLANE_ADJUST_MODE       =   0,
    parameter   C_GT_REF_CLK_FREQ                =   322.265625,
    parameter   C_GT_DRP_CLK                     =   100,
    parameter   C_GT_TYPE                        =   "GTY",
    parameter   C_LANE1_GT_LOC                   =   "X0Y0",
    parameter   C_LANE2_GT_LOC                   =   "X0Y1",
    parameter   C_LANE3_GT_LOC                   =   "X0Y2",
    parameter   C_LANE4_GT_LOC                   =   "X0Y3",
    parameter   C_ENABLE_PIPELINE_REG            =   0,
    parameter   C_ADD_GT_CNTRL_STS_PORTS         =   0,
    parameter   C_INCLUDE_SHARED_LOGIC           =   1
)
(
  input  wire gt_rxp_in_0,
  input  wire gt_rxn_in_0,
  output wire gt_txp_out_0,
  output wire gt_txn_out_0,
  input  wire gt_rxp_in_1,
  input  wire gt_rxn_in_1,
  output wire gt_txp_out_1,
  output wire gt_txn_out_1,
  input  wire gt_rxp_in_2,
  input  wire gt_rxn_in_2,
  output wire gt_txp_out_2,
  output wire gt_txn_out_2,
  input  wire gt_rxp_in_3,
  input  wire gt_rxn_in_3,
  output wire gt_txp_out_3,
  output wire gt_txn_out_3,
  output wire tx_clk_out_0,
  input wire rx_core_clk_0,
  output wire rx_clk_out_0,
  input wire gtwiz_reset_tx_datapath_0,
  input wire gtwiz_reset_rx_datapath_0,
  input  wire [11:0] gt_loopback_in_0,
//// RX_0 Signals
  input  wire rx_reset_0,
  output wire user_rx_reset_0,
//// RX_0 User Interface Signals
  output rx_axis_tvalid_0,
  output [255:0] rx_axis_tdata_0,
  output [31:0] rx_axis_tkeep_0,
  output rx_axis_tuser_0,
  output rx_axis_tlast_0,
  output [55:0] rx_preambleout_0,
//// RX_0 Control Signals
  input  wire ctl_rx_test_pattern_0,
  input  wire ctl_rx_enable_0,
  input  wire ctl_rx_delete_fcs_0,
  input  wire ctl_rx_ignore_fcs_0,
  input  wire [14:0] ctl_rx_max_packet_len_0,
  input  wire [7:0] ctl_rx_min_packet_len_0,
  input  wire ctl_rx_custom_preamble_enable_0,
  input  wire ctl_rx_check_sfd_0,
  input  wire ctl_rx_check_preamble_0,
  input  wire ctl_rx_process_lfi_0,
  input  wire ctl_rx_force_resync_0,


//// RX_0 Stats Signals
  output wire [3:0] stat_rx_block_lock_0,
  output wire stat_rx_framing_err_valid_0_0,
  output wire stat_rx_framing_err_0_0,
  output wire stat_rx_framing_err_valid_1_0,
  output wire stat_rx_framing_err_1_0,
  output wire stat_rx_framing_err_valid_2_0,
  output wire stat_rx_framing_err_2_0,
  output wire stat_rx_framing_err_valid_3_0,
  output wire stat_rx_framing_err_3_0,
  output wire [3:0] stat_rx_vl_demuxed_0,
  output wire [1:0] stat_rx_vl_number_0_0,
  output wire [1:0] stat_rx_vl_number_1_0,
  output wire [1:0] stat_rx_vl_number_2_0,
  output wire [1:0] stat_rx_vl_number_3_0,
  output wire [3:0] stat_rx_synced_0,
  output wire stat_rx_misaligned_0,
  output wire stat_rx_aligned_err_0,
  output wire [3:0] stat_rx_synced_err_0,
  output wire [3:0] stat_rx_mf_len_err_0,
  output wire [3:0] stat_rx_mf_repeat_err_0,
  output wire [3:0] stat_rx_mf_err_0,
  output wire stat_rx_bip_err_0_0,
  output wire stat_rx_bip_err_1_0,
  output wire stat_rx_bip_err_2_0,
  output wire stat_rx_bip_err_3_0,
  output wire stat_rx_aligned_0,
  output wire stat_rx_hi_ber_0,
  output wire stat_rx_status_0,
  output wire [1:0] stat_rx_bad_code_0,
  output wire [1:0] stat_rx_total_packets_0,
  output wire stat_rx_total_good_packets_0,
  output wire [5:0] stat_rx_total_bytes_0,
  output wire [13:0] stat_rx_total_good_bytes_0,
  output wire [1:0] stat_rx_packet_small_0,
  output wire stat_rx_jabber_0,
  output wire stat_rx_packet_large_0,
  output wire stat_rx_oversize_0,
  output wire [1:0] stat_rx_undersize_0,
  output wire stat_rx_toolong_0,
  output wire [1:0] stat_rx_fragment_0,
  output wire stat_rx_packet_64_bytes_0,
  output wire stat_rx_packet_65_127_bytes_0,
  output wire stat_rx_packet_128_255_bytes_0,
  output wire stat_rx_packet_256_511_bytes_0,
  output wire stat_rx_packet_512_1023_bytes_0,
  output wire stat_rx_packet_1024_1518_bytes_0,
  output wire stat_rx_packet_1519_1522_bytes_0,
  output wire stat_rx_packet_1523_1548_bytes_0,
  output wire [1:0] stat_rx_bad_fcs_0,
  output wire stat_rx_packet_bad_fcs_0,
  output wire [1:0] stat_rx_stomped_fcs_0,
  output wire stat_rx_packet_1549_2047_bytes_0,
  output wire stat_rx_packet_2048_4095_bytes_0,
  output wire stat_rx_packet_4096_8191_bytes_0,
  output wire stat_rx_packet_8192_9215_bytes_0,
  output wire stat_rx_unicast_0,
  output wire stat_rx_multicast_0,
  output wire stat_rx_broadcast_0,
  output wire stat_rx_vlan_0,
  output wire stat_rx_inrangeerr_0,
  output wire stat_rx_bad_preamble_0,
  output wire stat_rx_bad_sfd_0,
  output wire stat_rx_got_signal_os_0,
  output wire [1:0] stat_rx_test_pattern_mismatch_0,
  output wire stat_rx_truncated_0,
  output wire stat_rx_local_fault_0,
  output wire stat_rx_remote_fault_0,
  output wire stat_rx_internal_local_fault_0,
  output wire stat_rx_received_local_fault_0,
//// TX_0 Signals
  input  wire tx_reset_0,
  output wire user_tx_reset_0,
//// TX_0 User Interface Signals
  output tx_axis_tready_0,
  input tx_axis_tvalid_0,
  input [255:0] tx_axis_tdata_0,
  input [31:0] tx_axis_tkeep_0,
  input tx_axis_tuser_0,
  input tx_axis_tlast_0,
  output tx_unfout_0,
  input wire [55:0] tx_preamblein_0,



//// TX_0 Control Signals
  input  wire ctl_tx_test_pattern_0,
  input  wire ctl_tx_enable_0,
  input  wire ctl_tx_fcs_ins_enable_0,
  input  wire [3:0] ctl_tx_ipg_value_0,
  input  wire ctl_tx_send_lfi_0,
  input  wire ctl_tx_send_rfi_0,
  input  wire ctl_tx_send_idle_0,
  input  wire ctl_tx_custom_preamble_enable_0,
  input  wire ctl_tx_ignore_fcs_0,
//// TX_0 Stats Signals
  output wire stat_tx_underflow_err_0,
  output wire stat_tx_overflow_err_0,
  output wire stat_tx_total_packets_0,
  output wire [4:0] stat_tx_total_bytes_0,
  output wire stat_tx_total_good_packets_0,
  output wire [13:0] stat_tx_total_good_bytes_0,
  output wire stat_tx_packet_64_bytes_0,
  output wire stat_tx_packet_65_127_bytes_0,
  output wire stat_tx_packet_128_255_bytes_0,
  output wire stat_tx_packet_256_511_bytes_0,
  output wire stat_tx_packet_512_1023_bytes_0,
  output wire stat_tx_packet_1024_1518_bytes_0,
  output wire stat_tx_packet_1519_1522_bytes_0,
  output wire stat_tx_packet_1523_1548_bytes_0,
  output wire stat_tx_packet_small_0,
  output wire stat_tx_packet_large_0,
  output wire stat_tx_packet_1549_2047_bytes_0,
  output wire stat_tx_packet_2048_4095_bytes_0,
  output wire stat_tx_packet_4096_8191_bytes_0,
  output wire stat_tx_packet_8192_9215_bytes_0,
  output wire stat_tx_unicast_0,
  output wire stat_tx_multicast_0,
  output wire stat_tx_broadcast_0,
  output wire stat_tx_vlan_0,
  output wire stat_tx_bad_fcs_0,
  output wire stat_tx_frame_error_0,
  output wire stat_tx_local_fault_0,







   output wire [3:0]      rxrecclkout_0,
   input  wire gt_refclk_p,
   input  wire gt_refclk_n,
   output wire gt_refclk_out,
   output wire [3:0] gtpowergood_out_0,
   input wire [11:0] txoutclksel_in_0,
   input wire [11:0] rxoutclksel_in_0,
   input  wire sys_reset,
   input  wire dclk

);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
  wire [0:0]      gt_refclk;
  wire   gt_refclk_copy;
 IBUFDS_GTE4 IBUFDS_GTE4_GTREFCLK0_INST (
    .I             (gt_refclk_p),
    .IB            (gt_refclk_n),
    .CEB           (1'b0),
    .O             (gt_refclk),
    .ODIV2         (gt_refclk_copy)
  );

wire power_good;
assign power_good = & gtpowergood_out_0;
     BUFG_GT refclk_bufg_gt_i
  (
      .I       (gt_refclk_copy),
      .CE      (power_good),
      .CEMASK  (1'b1),
      .CLR     (1'b0),
      .CLRMASK (1'b1),
      .DIV     (3'b000),
      .O       (gt_refclk_out)
  ); 



  wire [15:0] drpaddr_common_in_0;
  assign drpaddr_common_in_0 = 16'b0;
  wire [15:0] drpdi_common_in_0;
  wire [15:0] drpdo_common_out_0;
  assign drpdi_common_in_0 = 16'b0;

  wire [0:0]    gtrefclk00_in_0;
  wire [0:0]    qpll0outclk_out_0;
  wire [0:0]    qpll0outrefclk_out_0;
  assign gtrefclk00_in_0                    = gt_refclk;

  //wire [3:0] gtpowergood_out_0;

  wire [3:0]      rxrecclkout_out_0;
  assign rxrecclkout_0 = rxrecclkout_out_0;
//// Insert GT interface here
  localparam [28:0] MASTER_WATCHDOG_TIMER_RESET = (750000000 / (1000 / 100.00));

  wire [3:0]      gt_rxn_int_0;
  wire [3:0]      gt_rxp_int_0;
  wire [3:0]      gt_txn_int_0;
  wire [3:0]      gt_txp_int_0;
  wire [3:0]      gtyrxn_in_0;
  wire [3:0]      gtyrxp_in_0;
      
  wire [3:0]      gtytxn_out_0;
  wire [3:0]      gtytxp_out_0;
  wire [3:0]      rxpmaresetdone_out_0;
  wire [3:0]      txprgdivresetdone_out_0;
  wire [3:0]      txpmaresetdone_out_0;
  wire [3:0]      rxprgdivresetdone_out_0;
  wire [0:0]      gtwiz_userclk_rx_usrclk_out_0;
  wire [0:0]      gtwiz_userclk_rx_srcclk_out_0;
  wire [0:0]      gtwiz_userclk_rx_usrclk2_out_0;
  wire [3:0]      txusrclk_in_0;
  wire [3:0]      txusrclk2_in_0;
  wire [3:0]      rxusrclk_in_0;
  wire [3:0]      rxusrclk2_in_0;
  wire [511:0]    txdata_in_0;
  wire [511:0]    rxdata_out_0;
  wire [3:0]      rxgearboxslip_in_int_0;
  wire [3:0]      rxgearboxslip_in_0;
  wire [7:0]      rxdatavalid_out_0;
  wire [23:0]      rxheader_out_0;
  wire [7:0]      rxheadervalid_out_0;
  wire [23:0]      txheader_in_0;
  wire [27:0]      txsequence_in_0;
  wire [0:0]      gtwiz_reset_rx_done_int_0;
  wire [0:0]      gtwiz_reset_clk_freerun_in_0;
  wire [0:0]      gtwiz_reset_all_in_0;
  wire [0:0]      gtwiz_reset_tx_pll_and_datapath_in_0;
  wire [0:0]      gtwiz_reset_tx_datapath_in_0;
  wire [0:0]      gtwiz_reset_tx_done_out_0;
  wire [0:0]      gtwiz_reset_rx_pll_and_datapath_in_0;
  wire [0:0]      gtwiz_reset_rx_datapath_in_0;
  wire [0:0]      gtwiz_reset_rx_cdr_stable_out_0;
  wire [0:0]      gtwiz_reset_rx_done_out_0;
  wire [0:0]      gtwiz_reset_tx_done_int_0;
  wire [0:0]      gtwiz_userclk_tx_active_in_0;
  wire [0:0]      core_gtwiz_userclk_tx_reset_in_0;
  wire [0:0]      gtwiz_userclk_tx_srcclk_out_0;
  wire [0:0]      gtwiz_userclk_tx_usrclk_out_0;
  wire [0:0]      gtwiz_userclk_tx_usrclk2_out_0;
  wire [0:0]      core_gtwiz_userclk_tx_active_out_0;
  wire [0:0]      gtwiz_userclk_rx_active_in_0;
  wire [0:0]      core_gtwiz_userclk_rx_reset_in_0;
  wire [0:0]      core_gtwiz_userclk_rx_active_out_0;
  wire [39:0]    drpaddr_in_0;
  wire [63:0]    drpdi_in_0;
  wire [3:0]     drpen_in_0;
  wire [3:0]     drpwe_in_0;
  wire [3:0]     drpclk_in_0;
  wire [63:0]    drpdo_out_0;
  wire [3:0]     drprdy_out_0;
  wire [7:0]      rxstartofseq_out_0;
  wire [3:0]      rxlpmen_in_0;
  wire [3:0]      rxcdrhold_in_0;
  wire [3:0]      rxdfelfhold_in_0;
  wire [3:0]      rxlpmlfhold_in_0;
  wire [3:0]      rxdfelpmreset_in_0;
  wire [3:0]      rxpmareset_in_0;

  assign rxdfelfhold_in_0 = {4{1'b0}};
  assign rxlpmlfhold_in_0 = {4{1'b0}};
  assign rxcdrhold_in_0 = {4{1'b0}};
  assign rxdfelpmreset_in_0 = {4{1'b0}};
  assign rxpmareset_in_0 = {4{1'b0}};
  assign rxlpmen_in_0 = {4{1'b0}};
  assign drpaddr_in_0 = {4{10'b0000000000}};
  assign drpdi_in_0 = {4{16'h0000}};
  assign drpen_in_0 = {4{1'b0}};
  assign drpwe_in_0 = {4{1'b0}};
  assign drpclk_in_0 = {4{dclk}};

  reg [28:0] master_watchdog_0 = MASTER_WATCHDOG_TIMER_RESET;
  reg master_watchdog_barking_0 = 1'b0;
  wire master_watchdog_barking_sync_0;

  wire [0:0]      tx_reset_done_async_0;
  wire [0:0]      rx_reset_done_async_0;
  wire tx_reset_done_sync_0;
  l_ethernet_0_cdc_sync i_l_ethernet_0_core_cdc_sync_tx_resetdone_0
  (
   .clk              (rx_core_clk_0),
   .signal_in        (tx_reset_done_async_0), 
   .signal_out       (tx_reset_done_sync_0)
  );
  l_ethernet_0_cdc_sync i_l_ethernet_0_core_cdc_sync_watchdog_barking_sync_0
  (
   .clk              (dclk),
   .signal_in        (master_watchdog_barking_0), 
   .signal_out       (master_watchdog_barking_sync_0)
  );

  wire tx_reset_done_sync_dclk_0;
  wire rx_reset_done_sync_dclk_0;
  l_ethernet_0_cdc_sync i_l_ethernet_0_core_cdc_sync_tx_resetdone_0_dclk
  (
   .clk              (dclk),
   .signal_in        (tx_reset_done_async_0), 
   .signal_out       (tx_reset_done_sync_dclk_0)
  );
  l_ethernet_0_cdc_sync i_l_ethernet_0_core_cdc_sync_rx_resetdone_0_dclk
  (
   .clk              (dclk),
   .signal_in        (rx_reset_done_async_0), 
   .signal_out       (rx_reset_done_sync_dclk_0)
  );
  always @(posedge dclk)
  begin
    if((tx_reset_done_sync_dclk_0 == 1'b0 && rx_reset_done_sync_dclk_0 == 1'b0)  || stat_rx_status_0 == 1'b1  || master_watchdog_0 == 0)
      master_watchdog_0 <= MASTER_WATCHDOG_TIMER_RESET;
    else
      master_watchdog_0 <= master_watchdog_0 - 1;
    end

  always @(posedge dclk)
  begin
    if (master_watchdog_0 == 0)
      master_watchdog_barking_0 <= 1'b1;
    else
      master_watchdog_barking_0 <= 1'b0;
  end




  //assign gtwiz_reset_tx_datapath_in_0 = gtwiz_reset_tx_datapath_0;
  assign gtwiz_reset_tx_datapath_in_0 = gtwiz_reset_tx_datapath_0;
  assign gtwiz_reset_rx_datapath_in_0 = gtwiz_reset_rx_datapath_0 | master_watchdog_barking_sync_0;
  assign gtwiz_reset_all_in_0 = sys_reset ;
  wire [11:0] loopback_in_0 = gt_loopback_in_0;
  assign gt_rxn_int_0[0:0] = gt_rxn_in_0;
  assign gt_rxp_int_0[0:0] = gt_rxp_in_0;
  assign gt_txn_out_0 = gt_txn_int_0[0:0];
  assign gt_txp_out_0 = gt_txp_int_0[0:0];
  assign gt_rxn_int_0[1:1] = gt_rxn_in_1;
  assign gt_rxp_int_0[1:1] = gt_rxp_in_1;
  assign gt_txn_out_1 = gt_txn_int_0[1:1];
  assign gt_txp_out_1 = gt_txp_int_0[1:1];
  assign gt_rxn_int_0[2:2] = gt_rxn_in_2;
  assign gt_rxp_int_0[2:2] = gt_rxp_in_2;
  assign gt_txn_out_2 = gt_txn_int_0[2:2];
  assign gt_txp_out_2 = gt_txp_int_0[2:2];
  assign gt_rxn_int_0[3:3] = gt_rxn_in_3;
  assign gt_rxp_int_0[3:3] = gt_rxp_in_3;
  assign gt_txn_out_3 = gt_txn_int_0[3:3];
  assign gt_txp_out_3 = gt_txp_int_0[3:3];
  ////assign inputs to GT
  assign gtwiz_reset_clk_freerun_in_0 = dclk;
  assign gtwiz_reset_tx_pll_and_datapath_in_0 = 1'b0;
  assign gtwiz_reset_rx_pll_and_datapath_in_0 = 1'b0;
  assign gtwiz_reset_rx_data_good_in_0 = 1'b1;
  assign gtyrxn_in_0 = gt_rxn_int_0;
  assign gtyrxp_in_0 = gt_rxp_int_0;
  ////outputs from GT
  assign gt_txn_int_0 = gtytxn_out_0;
  assign gt_txp_int_0 = gtytxp_out_0;
  assign gtwiz_reset_tx_done_int_0 = gtwiz_reset_tx_done_out_0;
  assign gtwiz_reset_rx_done_int_0 = gtwiz_reset_rx_done_out_0;

  //// ===================================================================================================================
  //// TX/RX USER CLOCKING Helper block integration
  //// ===================================================================================================================

  wire [3:0]      txoutclk_out_0;
  wire [3:0]      rxoutclk_out_0;

  //// ===================================================================================================================
  //// USER CLOCKING RESETS
  //// ===================================================================================================================

  //// The TX user clocking helper block should be held in reset until the clock source of that block is known to be
  //// stable. The following assignment is an example of how that stability can be determined, based on the selected TX
  //// user clock source. Replace the assignment with the appropriate signal or logic to achieve that behavior as needed.


  //// The RX user clocking helper block should be held in reset until the clock source of that block is known to be
  //// stable. The following assignment is an example of how that stability can be determined, based on the selected RX
  //// user clock source. Replace the assignment with the appropriate signal or logic to achieve that behavior as needed.
  //// Note that, if the clock source is derived from the received data, this is indicated by a combination of the
  //// appropriate reset done signal and the reset helper block's RX CDR stable indicator.

  //// ===================================================================================================================
  //// USER CLOCKING Source clocks
  //// ===================================================================================================================

  assign gtwiz_userclk_tx_srcclk_out_0 = txoutclk_out_0[0];
  assign gtwiz_userclk_rx_srcclk_out_0 = rxoutclk_out_0[0];

  //// Instantiate a single instance of the transmitter user clocking network helper block
  assign core_gtwiz_userclk_tx_reset_in_0 = ~((&txprgdivresetdone_out_0) & (&txpmaresetdone_out_0));
  assign core_gtwiz_userclk_rx_reset_in_0 = ~(&rxpmaresetdone_out_0);
  //// Generate a single module instance which is driven by a clock source associated with the master transmitter channel,
  //// and which drives TXUSRCLK and TXUSRCLK2 for all channels
  //// The source clock is TXOUTCLK from the master transmitter channel
  l_ethernet_0_ultrascale_tx_userclk
  #(
    .P_CONTENTS                     (0),
    .P_FREQ_RATIO_SOURCE_TO_USRCLK  (1),
    .P_FREQ_RATIO_USRCLK_TO_USRCLK2 (1)
  ) i_core_gtwiz_userclk_tx_inst_0 (
    .gtwiz_userclk_tx_srcclk_in   (gtwiz_userclk_tx_srcclk_out_0),
    .gtwiz_userclk_tx_reset_in    (core_gtwiz_userclk_tx_reset_in_0),
    .gtwiz_userclk_tx_usrclk_out  (gtwiz_userclk_tx_usrclk_out_0),
    .gtwiz_userclk_tx_usrclk2_out (gtwiz_userclk_tx_usrclk2_out_0),
    .gtwiz_userclk_tx_active_out  (core_gtwiz_userclk_tx_active_out_0)
  );

  //// Generate a single module instance which is driven by a clock source associated with the master receiver channel,
  //// and which drives RXUSRCLK and RXUSRCLK2 for all channels
  //// The source clock is RXOUTCLK from the master receiver channel
  l_ethernet_0_ultrascale_rx_userclk
  #(
    .P_CONTENTS                     (0),
    .P_FREQ_RATIO_SOURCE_TO_USRCLK  (1),
    .P_FREQ_RATIO_USRCLK_TO_USRCLK2 (1)
  ) i_core_gtwiz_userclk_rx_inst_0 (
      .gtwiz_userclk_rx_srcclk_in   (gtwiz_userclk_rx_srcclk_out_0),
      .gtwiz_userclk_rx_reset_in    (core_gtwiz_userclk_rx_reset_in_0),
      .gtwiz_userclk_rx_usrclk_out  (gtwiz_userclk_rx_usrclk_out_0),
      .gtwiz_userclk_rx_usrclk2_out (gtwiz_userclk_rx_usrclk2_out_0),
      .gtwiz_userclk_rx_active_out  (core_gtwiz_userclk_rx_active_out_0)
    );

  //// Drive TXUSRCLK and TXUSRCLK2 for all channels with the respective helper block outputs
  assign txusrclk_in_0 = {4{gtwiz_userclk_tx_usrclk_out_0}};
  assign txusrclk2_in_0 = {4{gtwiz_userclk_tx_usrclk2_out_0}};
  assign gtwiz_userclk_tx_active_in_0 = core_gtwiz_userclk_tx_active_out_0;

  //// Drive RXUSRCLK and RXUSRCLK2 for each channel with the respective outputs of the associated helper block
  assign rxusrclk_in_0 = {4{gtwiz_userclk_rx_usrclk_out_0}};
  assign rxusrclk2_in_0 = {4{gtwiz_userclk_rx_usrclk2_out_0}};
  assign gtwiz_userclk_rx_active_in_0 = core_gtwiz_userclk_rx_active_out_0;
  
  //// GT Subcore Instatiataion 
  l_ethernet_0_gt i_l_ethernet_0_gt
  (
   .drpaddr_common_in(drpaddr_common_in_0),
   .drpaddr_in(drpaddr_in_0),
   .drpclk_common_in(drpclk_common_in_0),
   .drpclk_in(drpclk_in_0),
   .drpdi_common_in(drpdi_common_in_0),
   .drpdi_in(drpdi_in_0),
   .drpdo_common_out(drpdo_common_out_0),
   .drpdo_out(drpdo_out_0),
   .drpen_common_in(drpen_common_in_0),
   .drpen_in(drpen_in_0),
   .drprdy_common_out(drprdy_common_out_0),
   .drprdy_out(drprdy_out_0),
   .drpwe_common_in(drpwe_common_in_0),
   .drpwe_in(drpwe_in_0),
   .gtpowergood_out(gtpowergood_out_0),
   .gtrefclk00_in(gtrefclk00_in_0),
   .gtwiz_reset_all_in(gtwiz_reset_all_in_0),
   .gtwiz_reset_clk_freerun_in(gtwiz_reset_clk_freerun_in_0),
   .gtwiz_reset_rx_cdr_stable_out(gtwiz_reset_rx_cdr_stable_out_0),
   .gtwiz_reset_rx_datapath_in(gtwiz_reset_rx_datapath_in_0),
   .gtwiz_reset_rx_done_out(gtwiz_reset_rx_done_out_0),
   .gtwiz_reset_rx_pll_and_datapath_in(gtwiz_reset_rx_pll_and_datapath_in_0),
   .gtwiz_reset_tx_datapath_in(gtwiz_reset_tx_datapath_in_0),
   .gtwiz_reset_tx_done_out(gtwiz_reset_tx_done_out_0),
   .gtwiz_reset_tx_pll_and_datapath_in(gtwiz_reset_tx_pll_and_datapath_in_0),
   .gtwiz_userclk_rx_active_in(gtwiz_userclk_rx_active_in_0),
   .gtwiz_userclk_tx_active_in(gtwiz_userclk_tx_active_in_0),
   .gtyrxn_in(gtyrxn_in_0),
   .gtyrxp_in(gtyrxp_in_0),
   .gtytxn_out(gtytxn_out_0),
   .gtytxp_out(gtytxp_out_0),
   .loopback_in(loopback_in_0),
   .qpll0outclk_out(qpll0outclk_out_0),
   .qpll0outrefclk_out(qpll0outrefclk_out_0),
   .rxcdrhold_in(rxcdrhold_in_0),
   .rxdata_out(rxdata_out_0),
   .rxdatavalid_out(rxdatavalid_out_0),
   .rxdfelfhold_in(rxdfelfhold_in_0),
   .rxdfelpmreset_in(rxdfelpmreset_in_0),
   .rxgearboxslip_in(rxgearboxslip_in_0),
   .rxheader_out(rxheader_out_0),
   .rxheadervalid_out(rxheadervalid_out_0),
   .rxlpmen_in(rxlpmen_in_0),
   .rxlpmlfhold_in(rxlpmlfhold_in_0),
   .rxoutclk_out(rxoutclk_out_0),
   .rxoutclksel_in(rxoutclksel_in_0),
   .rxpmareset_in(rxpmareset_in_0),
   .rxpmaresetdone_out(rxpmaresetdone_out_0),
   .rxprgdivresetdone_out(rxprgdivresetdone_out_0),
   .rxrecclkout_out(rxrecclkout_out_0),
   .rxstartofseq_out(rxstartofseq_out_0),
   .rxusrclk2_in(rxusrclk2_in_0),
   .rxusrclk_in(rxusrclk_in_0),
   .txdata_in(txdata_in_0),
   .txheader_in(txheader_in_0),
   .txoutclk_out(txoutclk_out_0),
   .txoutclksel_in(txoutclksel_in_0),
   .txpmaresetdone_out(txpmaresetdone_out_0),
   .txprgdivresetdone_out(txprgdivresetdone_out_0),
   .txsequence_in(txsequence_in_0),
   .txusrclk2_in(txusrclk2_in_0),
   .txusrclk_in(txusrclk_in_0)
  );


  wire [0:0]      gtwiz_reset_tx_done_int_sync_0;
  wire [0:0]      gtwiz_reset_tx_done_int_sync_inv_0;
  wire [0:0]      gtwiz_reset_rx_done_int_sync_0;
  wire [0:0]      gtwiz_reset_rx_done_int_sync_inv_0;
  reg  [0:0]      rx_reset_done_async_r_0;
  wire [0:0]      rx_reset_done_0;
  wire [0:0]      rx_serdes_reset_done_0;
  wire [0:0]      rx_serdes_clk_core_0;
  wire [3:0]      rx_serdes_reset_done_core_0;
  wire            gt_txusrclk2_0;

  
  assign tx_clk_out_0 = gtwiz_userclk_tx_usrclk2_out_0;
  assign rx_clk_out_0 = gtwiz_userclk_rx_usrclk2_out_0;
  assign gt_txusrclk2_0 = gtwiz_userclk_tx_usrclk2_out_0;
  assign gt_rxusrclk2_0 = gtwiz_userclk_rx_usrclk2_out_0;
  assign rx_serdes_clk_core_0 = gtwiz_userclk_rx_usrclk2_out_0;
  
  
  
  

  wire [63:0]     tx_serdes_data_core0_lane0;
  wire [3:0]      tx_serdes_header_core0_lane0;
  wire [5:0]      tx_serdes_seq_core0_lane0;
  wire [5:0]      tx_serdes_seq_int_core0_lane0;

  wire [63:0]     rx_serdes_data_core0_lane0;
  wire [3:0]      rx_serdes_header_core0_lane0;
  wire [1:0]      rx_serdes_headervalid_core0_lane0;
  wire [1:0]      rx_serdes_datavalid_core0_lane0;
  wire [1:0]      rx_serdes_bitslip_core0_lane0;
  wire [63:0]     tx_serdes_data_int_core0_lane0;
  wire [3:0]      tx_serdes_header_int_core0_lane0;
  wire [63:0]     rx_serdes_data_int_core0_lane0;
  wire [3:0]      rx_serdes_header_int_core0_lane0;
  wire [1:0]      rx_serdes_headervalid_int_core0_lane0;
  wire [1:0]      rx_serdes_datavalid_int_core0_lane0;

  wire [63:0]     tx_serdes_data_core0_lane1;
  wire [3:0]      tx_serdes_header_core0_lane1;
  wire [5:0]      tx_serdes_seq_core0_lane1;
  wire [5:0]      tx_serdes_seq_int_core0_lane1;

  wire [63:0]     rx_serdes_data_core0_lane1;
  wire [3:0]      rx_serdes_header_core0_lane1;
  wire [1:0]      rx_serdes_headervalid_core0_lane1;
  wire [1:0]      rx_serdes_datavalid_core0_lane1;
  wire [1:0]      rx_serdes_bitslip_core0_lane1;
  wire [63:0]     tx_serdes_data_int_core0_lane1;
  wire [3:0]      tx_serdes_header_int_core0_lane1;
  wire [63:0]     rx_serdes_data_int_core0_lane1;
  wire [3:0]      rx_serdes_header_int_core0_lane1;
  wire [1:0]      rx_serdes_headervalid_int_core0_lane1;
  wire [1:0]      rx_serdes_datavalid_int_core0_lane1;

  l_ethernet_0_cdc_sync i_l_ethernet_0_core_cdc_sync_gt_tx_resetdone_0
  (
   .clk              (gt_txusrclk2_0),
   .signal_in        (gtwiz_reset_tx_done_int_0), 
   .signal_out       (gtwiz_reset_tx_done_int_sync_0)
  );

  assign gtwiz_reset_tx_done_int_sync_inv_0 = ~(gtwiz_reset_tx_done_int_sync_0);
  assign tx_reset_done_async_0 = gtwiz_reset_tx_done_int_sync_inv_0 | tx_reset_0;
  assign user_tx_reset_0 = tx_reset_done_async_0;

  l_ethernet_0_cdc_sync i_l_ethernet_0_core_cdc_sync_gt_rx_resetdone_0
  (
   .clk              (gt_txusrclk2_0),
   .signal_in        (gtwiz_reset_rx_done_int_0), 
   .signal_out       (gtwiz_reset_rx_done_int_sync_0)
  );

  assign gtwiz_reset_rx_done_int_sync_inv_0 = ~(gtwiz_reset_rx_done_int_sync_0);
  assign rx_reset_done_async_0 = gtwiz_reset_rx_done_int_sync_inv_0 | rx_reset_0;
 
  always @( posedge gt_txusrclk2_0)
  begin
       rx_reset_done_async_r_0 <= rx_reset_done_async_0;
  end

  l_ethernet_0_cdc_sync i_l_ethernet_0_core_cdc_sync_rx_reset_done__0
  (
   .clk              (rx_core_clk_0),
   .signal_in        (rx_reset_done_async_r_0), 
   .signal_out       (rx_reset_done_0)
  );
 
  l_ethernet_0_cdc_sync i_l_ethernet_0_core_cdc_sync_gt_rx_serdes_resetdone_0
  (
   .clk              (rx_serdes_clk_core_0),
   .signal_in        (rx_reset_done_async_r_0), 
   .signal_out       (rx_serdes_reset_done_0)
  );

  assign user_rx_reset_0 = rx_reset_done_0;
  assign rx_serdes_reset_done_core_0 = {4{rx_serdes_reset_done_0}};
  assign txdata_in_0 = { 96'b0, tx_serdes_data_int_core0_lane1[63:32],
                                      96'b0, tx_serdes_data_int_core0_lane1[31:0], 
                                      96'b0, tx_serdes_data_int_core0_lane0[63:32], 
                                      96'b0, tx_serdes_data_int_core0_lane0[31:0]};

  assign txheader_in_0 = {4'b0,tx_serdes_header_int_core0_lane1[3:2], 4'b0,tx_serdes_header_int_core0_lane1[1:0],
                                       4'b0,tx_serdes_header_int_core0_lane0[3:2], 4'b0,tx_serdes_header_int_core0_lane0[1:0]};
  assign txsequence_in_0 = {{4{1'b0, tx_serdes_seq_int_core0_lane0}}};

  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (64)
  ) i_l_ethernet_0_tx_64bit_retiming_sync_serdes_data0_core0_lane0 (
    .clk          (gt_txusrclk2_0),
    .data_in      (tx_serdes_data_core0_lane0),
    .data_out     (tx_serdes_data_int_core0_lane0)
  );

  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (4)
  ) i_l_ethernet_0_tx_4bit_retiming_sync_serdes_data0_core0_lane0 (
    .clk          (gt_txusrclk2_0),
    .data_in      (tx_serdes_header_core0_lane0),
    .data_out     (tx_serdes_header_int_core0_lane0)
  );

  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (6)
  ) i_l_ethernet_0_tx_6bit_retiming_sync_tx_serdes_seq_core0_lane0 (
    .clk          (gt_txusrclk2_0),
    .data_in      (tx_serdes_seq_core0_lane0),
    .data_out     (tx_serdes_seq_int_core0_lane0)
  );
  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (64)
  ) i_l_ethernet_0_tx_64bit_retiming_sync_serdes_data0_core0_lane1 (
    .clk          (gt_txusrclk2_0),
    .data_in      (tx_serdes_data_core0_lane1),
    .data_out     (tx_serdes_data_int_core0_lane1)
  );

  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (4)
  ) i_l_ethernet_0_tx_4bit_retiming_sync_serdes_data0_core0_lane1 (
    .clk          (gt_txusrclk2_0),
    .data_in      (tx_serdes_header_core0_lane1),
    .data_out     (tx_serdes_header_int_core0_lane1)
  );

  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (6)
  ) i_l_ethernet_0_tx_6bit_retiming_sync_tx_serdes_seq_core0_lane1 (
    .clk          (gt_txusrclk2_0),
    .data_in      (tx_serdes_seq_core0_lane1),
    .data_out     (tx_serdes_seq_int_core0_lane1)
  );

  assign rx_serdes_data_int_core0_lane0 =   {rxdata_out_0[159:128] ,rxdata_out_0[31:0]};
  assign rx_serdes_datavalid_int_core0_lane0 =  {rxdatavalid_out_0[2:2], rxdatavalid_out_0[0:0]};
  assign rx_serdes_header_int_core0_lane0 =  {rxheader_out_0[7:6], rxheader_out_0[1:0]};
  assign rx_serdes_headervalid_int_core0_lane0 =  {rxheadervalid_out_0[2:2], rxheadervalid_out_0[0:0]};
  //assign rxgearboxslip_in_int_0[1:0] =  rx_serdes_bitslip_core0_lane0;
  assign rxgearboxslip_in_0[1:0] =  rx_serdes_bitslip_core0_lane0;
  assign rx_serdes_data_int_core0_lane1 =   {rxdata_out_0[415:384],rxdata_out_0[287:256]};
  assign rx_serdes_datavalid_int_core0_lane1 =  {rxdatavalid_out_0[6:6], rxdatavalid_out_0[4:4]};
  assign rx_serdes_header_int_core0_lane1 =  {rxheader_out_0[19:18], rxheader_out_0[13:12]};
  assign rx_serdes_headervalid_int_core0_lane1 =  {rxheadervalid_out_0[6:6], rxheadervalid_out_0[4:4]};
  //assign rxgearboxslip_in_int_0[3:2] =  rx_serdes_bitslip_core0_lane1;
  assign rxgearboxslip_in_0[3:2] =  rx_serdes_bitslip_core0_lane1;

//  l_ethernet_0_retiming_sync
//  #(
//    .WIDTH        (4)
//  ) i_l_ethernet_0_rxgearboxslip_retiming_sync_0 (
//    .clk          (rx_serdes_clk_core_0),
//    .data_in      (rxgearboxslip_in_int_0),
//    .data_out     (rxgearboxslip_in_0)
//  );



  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (64)
  ) i_l_ethernet_0_rx_64bit_retiming_sync_serdes_data0_core0_lane0 (
    .clk          (rx_serdes_clk_core_0),
    .data_in      (rx_serdes_data_int_core0_lane0),
    .data_out     (rx_serdes_data_core0_lane0)
  );

  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (4)
  ) i_l_ethernet_0_rx_2bit_retiming_sync_serdes_header0_core0_lane0 (
    .clk          (rx_serdes_clk_core_0),
    .data_in      (rx_serdes_header_int_core0_lane0),
    .data_out     (rx_serdes_header_core0_lane0)
  );

  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (2)
  ) i_l_ethernet_0_rx_2bit_retiming_sync_serdes_data_valid0_core0_lane0 (
    .clk          (rx_serdes_clk_core_0),
    .data_in      (rx_serdes_datavalid_int_core0_lane0),
    .data_out     (rx_serdes_datavalid_core0_lane0)
  );

  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (2)
  ) i_l_ethernet_0_rx_2bit_retiming_sync_serdes_header_valid0_core0_lane0 (
    .clk          (rx_serdes_clk_core_0),
    .data_in      (rx_serdes_headervalid_int_core0_lane0),
    .data_out     (rx_serdes_headervalid_core0_lane0)
  );

  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (64)
  ) i_l_ethernet_0_rx_64bit_retiming_sync_serdes_data0_core0_lane1 (
    .clk          (rx_serdes_clk_core_0),
    .data_in      (rx_serdes_data_int_core0_lane1),
    .data_out     (rx_serdes_data_core0_lane1)
  );

  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (4)
  ) i_l_ethernet_0_rx_2bit_retiming_sync_serdes_header0_core0_lane1 (
    .clk          (rx_serdes_clk_core_0),
    .data_in      (rx_serdes_header_int_core0_lane1),
    .data_out     (rx_serdes_header_core0_lane1)
  );

  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (2)
  ) i_l_ethernet_0_rx_2bit_retiming_sync_serdes_data_valid0_core0_lane1 (
    .clk          (rx_serdes_clk_core_0),
    .data_in      (rx_serdes_datavalid_int_core0_lane1),
    .data_out     (rx_serdes_datavalid_core0_lane1)
  );

  l_ethernet_0_retiming_sync
  #(
    .WIDTH        (2)
  ) i_l_ethernet_0_rx_2bit_retiming_sync_serdes_header_valid0_core0_lane1 (
    .clk          (rx_serdes_clk_core_0),
    .data_in      (rx_serdes_headervalid_int_core0_lane1),
    .data_out     (rx_serdes_headervalid_core0_lane1)
  );


l_ethernet_0_top i_l_ethernet_0_top_0 (
  .tx_clk (gt_txusrclk2_0),
  .rx_clk (rx_core_clk_0),
  .tx_reset (tx_reset_done_async_0),
  .rx_reset (rx_reset_done_0),
  .tx_serdes_refclk (gt_txusrclk2_0),
  .tx_serdes_refclk_reset (tx_reset_done_async_0),
//// RX UserIF Signals
  .rx_axis_tvalid  (rx_axis_tvalid_0),
  .rx_axis_tdata   (rx_axis_tdata_0),
  .rx_axis_tkeep   (rx_axis_tkeep_0),
  .rx_axis_tuser   (rx_axis_tuser_0),
  .rx_axis_tlast   (rx_axis_tlast_0),
  .rx_preambleout (rx_preambleout_0),
//// RX Control Signals
  .ctl_rx_test_pattern (ctl_rx_test_pattern_0),
  .ctl_rx_enable (ctl_rx_enable_0),
  .ctl_rx_delete_fcs (ctl_rx_delete_fcs_0),
  .ctl_rx_ignore_fcs (ctl_rx_ignore_fcs_0),
  .ctl_rx_max_packet_len (ctl_rx_max_packet_len_0),
  .ctl_rx_min_packet_len (ctl_rx_min_packet_len_0),
  .ctl_rx_custom_preamble_enable (ctl_rx_custom_preamble_enable_0),
  .ctl_rx_check_sfd (ctl_rx_check_sfd_0),
  .ctl_rx_check_preamble (ctl_rx_check_preamble_0),
  .ctl_rx_process_lfi (ctl_rx_process_lfi_0),
  .ctl_rx_force_resync (ctl_rx_force_resync_0),
//// RX Stats Signals
  .stat_rx_block_lock (stat_rx_block_lock_0),
  .stat_rx_framing_err_valid_0 (stat_rx_framing_err_valid_0_0),
  .stat_rx_framing_err_0 (stat_rx_framing_err_0_0),
  .stat_rx_framing_err_valid_1 (stat_rx_framing_err_valid_1_0),
  .stat_rx_framing_err_1 (stat_rx_framing_err_1_0),
  .stat_rx_framing_err_valid_2 (stat_rx_framing_err_valid_2_0),
  .stat_rx_framing_err_2 (stat_rx_framing_err_2_0),
  .stat_rx_framing_err_valid_3 (stat_rx_framing_err_valid_3_0),
  .stat_rx_framing_err_3 (stat_rx_framing_err_3_0),
  .stat_rx_vl_demuxed (stat_rx_vl_demuxed_0),
  .stat_rx_vl_number_0 (stat_rx_vl_number_0_0),
  .stat_rx_vl_number_1 (stat_rx_vl_number_1_0),
  .stat_rx_vl_number_2 (stat_rx_vl_number_2_0),
  .stat_rx_vl_number_3 (stat_rx_vl_number_3_0),
  .stat_rx_synced (stat_rx_synced_0),
  .stat_rx_misaligned (stat_rx_misaligned_0),
  .stat_rx_aligned_err (stat_rx_aligned_err_0),
  .stat_rx_synced_err (stat_rx_synced_err_0),
  .stat_rx_mf_len_err (stat_rx_mf_len_err_0),
  .stat_rx_mf_repeat_err (stat_rx_mf_repeat_err_0),
  .stat_rx_mf_err (stat_rx_mf_err_0),
  .stat_rx_bip_err_0 (stat_rx_bip_err_0_0),
  .stat_rx_bip_err_1 (stat_rx_bip_err_1_0),
  .stat_rx_bip_err_2 (stat_rx_bip_err_2_0),
  .stat_rx_bip_err_3 (stat_rx_bip_err_3_0),
  .stat_rx_aligned (stat_rx_aligned_0),
  .stat_rx_hi_ber (stat_rx_hi_ber_0),
  .stat_rx_status (stat_rx_status_0),
  .stat_rx_bad_code (stat_rx_bad_code_0),
  .stat_rx_total_packets (stat_rx_total_packets_0),
  .stat_rx_total_good_packets (stat_rx_total_good_packets_0),
  .stat_rx_total_bytes (stat_rx_total_bytes_0),
  .stat_rx_total_good_bytes (stat_rx_total_good_bytes_0),
  .stat_rx_packet_small (stat_rx_packet_small_0),
  .stat_rx_jabber (stat_rx_jabber_0),
  .stat_rx_packet_large (stat_rx_packet_large_0),
  .stat_rx_oversize (stat_rx_oversize_0),
  .stat_rx_undersize (stat_rx_undersize_0),
  .stat_rx_toolong (stat_rx_toolong_0),
  .stat_rx_fragment (stat_rx_fragment_0),
  .stat_rx_packet_64_bytes (stat_rx_packet_64_bytes_0),
  .stat_rx_packet_65_127_bytes (stat_rx_packet_65_127_bytes_0),
  .stat_rx_packet_128_255_bytes (stat_rx_packet_128_255_bytes_0),
  .stat_rx_packet_256_511_bytes (stat_rx_packet_256_511_bytes_0),
  .stat_rx_packet_512_1023_bytes (stat_rx_packet_512_1023_bytes_0),
  .stat_rx_packet_1024_1518_bytes (stat_rx_packet_1024_1518_bytes_0),
  .stat_rx_packet_1519_1522_bytes (stat_rx_packet_1519_1522_bytes_0),
  .stat_rx_packet_1523_1548_bytes (stat_rx_packet_1523_1548_bytes_0),
  .stat_rx_bad_fcs (stat_rx_bad_fcs_0),
  .stat_rx_packet_bad_fcs (stat_rx_packet_bad_fcs_0),
  .stat_rx_stomped_fcs (stat_rx_stomped_fcs_0),
  .stat_rx_packet_1549_2047_bytes (stat_rx_packet_1549_2047_bytes_0),
  .stat_rx_packet_2048_4095_bytes (stat_rx_packet_2048_4095_bytes_0),
  .stat_rx_packet_4096_8191_bytes (stat_rx_packet_4096_8191_bytes_0),
  .stat_rx_packet_8192_9215_bytes (stat_rx_packet_8192_9215_bytes_0),
  .stat_rx_unicast (stat_rx_unicast_0),
  .stat_rx_multicast (stat_rx_multicast_0),
  .stat_rx_broadcast (stat_rx_broadcast_0),
  .stat_rx_vlan (stat_rx_vlan_0),
  .stat_rx_inrangeerr (stat_rx_inrangeerr_0),
  .stat_rx_bad_preamble (stat_rx_bad_preamble_0),
  .stat_rx_bad_sfd (stat_rx_bad_sfd_0),
  .stat_rx_got_signal_os (stat_rx_got_signal_os_0),
  .stat_rx_test_pattern_mismatch (stat_rx_test_pattern_mismatch_0),
  .stat_rx_truncated (stat_rx_truncated_0),
  .stat_rx_local_fault (stat_rx_local_fault_0),
  .stat_rx_remote_fault (stat_rx_remote_fault_0),
  .stat_rx_internal_local_fault (stat_rx_internal_local_fault_0),
  .stat_rx_received_local_fault (stat_rx_received_local_fault_0),
//// TX UserIF Signals
  .tx_axis_tready (tx_axis_tready_0),
  .tx_axis_tvalid (tx_axis_tvalid_0),
  .tx_axis_tdata  (tx_axis_tdata_0),
  .tx_axis_tlast  (tx_axis_tlast_0),
  .tx_axis_tkeep  (tx_axis_tkeep_0),
  .tx_axis_tuser  (tx_axis_tuser_0),
  .tx_unfout (tx_unfout_0),
  .tx_preamblein (tx_preamblein_0),
//// TX Control Signals
  .ctl_tx_test_pattern (ctl_tx_test_pattern_0),
  .ctl_tx_enable (ctl_tx_enable_0),
  .ctl_tx_fcs_ins_enable (ctl_tx_fcs_ins_enable_0),
  .ctl_tx_ipg_value (ctl_tx_ipg_value_0),
  .ctl_tx_send_lfi (ctl_tx_send_lfi_0),
  .ctl_tx_send_rfi (ctl_tx_send_rfi_0),
  .ctl_tx_send_idle (ctl_tx_send_idle_0),
  .ctl_tx_custom_preamble_enable (ctl_tx_custom_preamble_enable_0),
  .ctl_tx_ignore_fcs (ctl_tx_ignore_fcs_0),
//// TX Stats Signals
  .stat_tx_underflow_err (stat_tx_underflow_err_0),
  .stat_tx_overflow_err (stat_tx_overflow_err_0),
  .stat_tx_total_packets (stat_tx_total_packets_0),
  .stat_tx_total_bytes (stat_tx_total_bytes_0),
  .stat_tx_total_good_packets (stat_tx_total_good_packets_0),
  .stat_tx_total_good_bytes (stat_tx_total_good_bytes_0),
  .stat_tx_packet_64_bytes (stat_tx_packet_64_bytes_0),
  .stat_tx_packet_65_127_bytes (stat_tx_packet_65_127_bytes_0),
  .stat_tx_packet_128_255_bytes (stat_tx_packet_128_255_bytes_0),
  .stat_tx_packet_256_511_bytes (stat_tx_packet_256_511_bytes_0),
  .stat_tx_packet_512_1023_bytes (stat_tx_packet_512_1023_bytes_0),
  .stat_tx_packet_1024_1518_bytes (stat_tx_packet_1024_1518_bytes_0),
  .stat_tx_packet_1519_1522_bytes (stat_tx_packet_1519_1522_bytes_0),
  .stat_tx_packet_1523_1548_bytes (stat_tx_packet_1523_1548_bytes_0),
  .stat_tx_packet_small (stat_tx_packet_small_0),
  .stat_tx_packet_large (stat_tx_packet_large_0),
  .stat_tx_packet_1549_2047_bytes (stat_tx_packet_1549_2047_bytes_0),
  .stat_tx_packet_2048_4095_bytes (stat_tx_packet_2048_4095_bytes_0),
  .stat_tx_packet_4096_8191_bytes (stat_tx_packet_4096_8191_bytes_0),
  .stat_tx_packet_8192_9215_bytes (stat_tx_packet_8192_9215_bytes_0),
  .stat_tx_unicast (stat_tx_unicast_0),
  .stat_tx_multicast (stat_tx_multicast_0),
  .stat_tx_broadcast (stat_tx_broadcast_0),
  .stat_tx_vlan (stat_tx_vlan_0),
  .stat_tx_bad_fcs (stat_tx_bad_fcs_0),
  .stat_tx_frame_error (stat_tx_frame_error_0),
  .stat_tx_local_fault (stat_tx_local_fault_0),
  .tx_serdes_data0(tx_serdes_data_core0_lane0),
  .tx_serdes_data1(tx_serdes_data_core0_lane1),
  .tx_serdes_header0(tx_serdes_header_core0_lane0),
  .tx_serdes_header1(tx_serdes_header_core0_lane1),
  .tx_serdes_seq0(tx_serdes_seq_core0_lane0),
  .tx_serdes_seq1(tx_serdes_seq_core0_lane1),
  .rx_serdes_data0(rx_serdes_data_core0_lane0),
  .rx_serdes_data1(rx_serdes_data_core0_lane1),
  .rx_serdes_header0(rx_serdes_header_core0_lane0),
  .rx_serdes_header1(rx_serdes_header_core0_lane1),
  .rx_serdes_headervalid0(rx_serdes_headervalid_core0_lane0),
  .rx_serdes_headervalid1(rx_serdes_headervalid_core0_lane1),
  .rx_serdes_datavalid0(rx_serdes_datavalid_core0_lane0),
  .rx_serdes_datavalid1(rx_serdes_datavalid_core0_lane1),
  .rx_serdes_bitslip0(rx_serdes_bitslip_core0_lane0),
  .rx_serdes_bitslip1(rx_serdes_bitslip_core0_lane1),
  .rx_serdes_clk (rx_serdes_clk_core_0),
  .rx_serdes_reset ({2{rx_serdes_reset_done_core_0[0]}})
);


endmodule

(* DowngradeIPIdentifiedWarnings="yes" *)
  module l_ethernet_0_cdc_sync (
   input clk,
   input signal_in,
   output wire signal_out
  );
  
                               wire sig_in_cdc_from ;
      (* ASYNC_REG = "TRUE" *) reg  s_out_d2_cdc_to;
      (* ASYNC_REG = "TRUE" *) reg  s_out_d3;
      (* max_fanout = 500 *)   reg  s_out_d4;
      
// synthesis translate_off
      
      initial s_out_d2_cdc_to = 1'b0;
      initial s_out_d3        = 1'b0;
      initial s_out_d4        = 1'b0;
      
// synthesis translate_on   
   
      assign sig_in_cdc_from = signal_in;
      assign signal_out      = s_out_d4;
      
      always @(posedge clk) 
      begin
        s_out_d4         <= s_out_d3;
        s_out_d3         <= s_out_d2_cdc_to;
        s_out_d2_cdc_to  <= sig_in_cdc_from;
      end
  
  endmodule

  (* DowngradeIPIdentifiedWarnings="yes" *)
  module l_ethernet_0_multibit_cdc_sync (
   input clk,
   input [3:0] signal_in,
   output wire [3:0] signal_out
  );
                               wire [3:0] sig_in_cdc_from ;
      (* ASYNC_REG = "TRUE" *) reg [3:0] s_out_d2_cdc_to;
      (* ASYNC_REG = "TRUE" *) reg [3:0] s_out_d3;
                               reg [3:0] s_out_d4;
// synthesis translate_off
      initial s_out_d2_cdc_to = 4'b0;
      initial s_out_d3        = 4'b0;
      initial s_out_d4        = 4'b0;
// synthesis translate_on   
      assign sig_in_cdc_from = signal_in;
      assign signal_out      = s_out_d4;
      always @(posedge clk) 
      begin
        s_out_d4         <= s_out_d3;
        s_out_d3         <= s_out_d2_cdc_to;
        s_out_d2_cdc_to  <= sig_in_cdc_from;
      end
  endmodule
(* DowngradeIPIdentifiedWarnings="yes" *)
module l_ethernet_0_retiming_sync
#(
 parameter WIDTH  = 1
)
(
 input  clk,
 input  [WIDTH-1:0] data_in,
 output wire [WIDTH-1:0]  data_out
);
    
    (* shreg_extract = "no" *) reg  [WIDTH-1:0] data_out_1d;
    (* shreg_extract = "no" *) reg  [WIDTH-1:0] data_out_2d;
    
    assign data_out      = data_out_2d;
    
    always @(posedge clk) 
    begin
        data_out_2d      <= data_out_1d;
        data_out_1d      <= data_in;
    end

endmodule

