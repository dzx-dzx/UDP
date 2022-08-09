////------------------------------------------------------------------------------
//// Copyright 2015 Xilinx, Inc. All rights reserved.
//// This file contains confidential and proprietary information of Xilinx, Inc.
//// and is protected under U.S. and international copyright and other
//// intellectual property laws.
////
////  DISCLAIMER
////  This disclaimer is not a license and does not grant any
////  rights to the materials distributed herewith. Except as
////  otherwise provided in a valid license issued to you by
////  Xilinx, and to the maximum extent permitted by applicable
////  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
////  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
////  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
////  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
////  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
////  (2) Xilinx shall not be liable (whether in contract or tort,
////  including negligence, or under any other theory of
////  liability) for any loss or damage of any kind or nature
////  related to, arising under or in connection with these
////  materials, including for any direct, or any indirect,
////  special, incidental, or consequential loss or damage
////  (including loss of data, profits, goodwill, or any type of
////  loss or damage suffered as a result of any action brought
////  by a third party) even if such damage or loss was
////  reasonably foreseeable or Xilinx had been advised of the
////  possibility of the same.
////
////  CRITICAL APPLICATIONS
////  Xilinx products are not designed or intended to be fail-
////  safe, or for use in any application requiring fail-safe
////  performance, such as life-support or safety devices or
////  systems, Class III medical devices, nuclear facilities,
////  applications related to the deployment of airbags, or any
////  other applications that could lead to death, personal
////  injury, or severe property or environmental damage
////  (individually and collectively, "Critical
////  Applications"). Customer assumes the sole risk and
////  liability of any use of Xilinx products in Critical
////  Applications, subject only to applicable laws and
////  regulations governing limitations on product liability.
////
////  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
////  PART OF THIS FILE AT ALL TIMES.
////------------------------------------------------------------------------------


`timescale 1fs/1fs

(* DowngradeIPIdentifiedWarnings="yes" *)
module l_ethernet_0_1_top #(
  parameter SERDES_WIDTH = 64,
  parameter TIMESTAMP_WIDTH = 80
)(
  //// #-------------------
  //// # Clocks and Resets
  //// #-------------------
  input  wire tx_clk,
  input  wire rx_clk,
  input  wire tx_reset,
  input  wire rx_reset,
  input  wire tx_serdes_refclk,
  input  wire tx_serdes_refclk_reset,


  //// #-----------------------
  //// # RX Control Interface
  //// #-----------------------
  input  wire ctl_rx_test_pattern,
  input  wire ctl_rx_enable,
  input  wire ctl_rx_delete_fcs,
  input  wire ctl_rx_ignore_fcs,
  input  wire [14:0] ctl_rx_max_packet_len,
  input  wire [7:0] ctl_rx_min_packet_len,
  input  wire ctl_rx_custom_preamble_enable,
  input  wire ctl_rx_check_sfd,
  input  wire ctl_rx_check_preamble,
  input  wire ctl_rx_process_lfi,
  input  wire ctl_rx_force_resync,

  //// #-----------------------
  //// # TX Control Interface
  //// #-----------------------
  input  wire ctl_tx_test_pattern,
  input  wire ctl_tx_enable,
  input  wire ctl_tx_fcs_ins_enable,
  input  wire [3:0] ctl_tx_ipg_value,
  input  wire ctl_tx_send_lfi,
  input  wire ctl_tx_send_rfi,
  input  wire ctl_tx_send_idle,
  input  wire ctl_tx_custom_preamble_enable,
  input  wire ctl_tx_ignore_fcs,

 


  //// #---------------------
  //// # Stats Interface
  //// #---------------------
  output wire [3:0] stat_rx_block_lock,
  output wire stat_rx_framing_err_valid_0,
  output wire stat_rx_framing_err_0,
  output wire stat_rx_framing_err_valid_1,
  output wire stat_rx_framing_err_1,
  output wire stat_rx_framing_err_valid_2,
  output wire stat_rx_framing_err_2,
  output wire stat_rx_framing_err_valid_3,
  output wire stat_rx_framing_err_3,
  output wire [3:0] stat_rx_vl_demuxed,
  output wire [1:0] stat_rx_vl_number_0,
  output wire [1:0] stat_rx_vl_number_1,
  output wire [1:0] stat_rx_vl_number_2,
  output wire [1:0] stat_rx_vl_number_3,
  output wire [3:0] stat_rx_synced,
  output wire stat_rx_misaligned,
  output wire stat_rx_aligned_err,
  output wire [3:0] stat_rx_synced_err,
  output wire [3:0] stat_rx_mf_len_err,
  output wire [3:0] stat_rx_mf_repeat_err,
  output wire [3:0] stat_rx_mf_err,
  output wire stat_rx_bip_err_0,
  output wire stat_rx_bip_err_1,
  output wire stat_rx_bip_err_2,
  output wire stat_rx_bip_err_3,
  output wire stat_rx_aligned,
  output wire stat_rx_hi_ber,
  output wire stat_rx_status,
  output wire [1:0] stat_rx_bad_code,
  output wire [1:0] stat_rx_total_packets,
  output wire stat_rx_total_good_packets,
  output wire [5:0] stat_rx_total_bytes,
  output wire [13:0] stat_rx_total_good_bytes,
  output wire [1:0] stat_rx_packet_small,
  output wire stat_rx_jabber,
  output wire stat_rx_packet_large,
  output wire stat_rx_oversize,
  output wire [1:0] stat_rx_undersize,
  output wire stat_rx_toolong,
  output wire [1:0] stat_rx_fragment,
  output wire stat_rx_packet_64_bytes,
  output wire stat_rx_packet_65_127_bytes,
  output wire stat_rx_packet_128_255_bytes,
  output wire stat_rx_packet_256_511_bytes,
  output wire stat_rx_packet_512_1023_bytes,
  output wire stat_rx_packet_1024_1518_bytes,
  output wire stat_rx_packet_1519_1522_bytes,
  output wire stat_rx_packet_1523_1548_bytes,
  output wire [1:0] stat_rx_bad_fcs,
  output wire stat_rx_packet_bad_fcs,
  output wire [1:0] stat_rx_stomped_fcs,
  output wire stat_rx_packet_1549_2047_bytes,
  output wire stat_rx_packet_2048_4095_bytes,
  output wire stat_rx_packet_4096_8191_bytes,
  output wire stat_rx_packet_8192_9215_bytes,
  output wire stat_rx_bad_preamble,
  output wire stat_rx_bad_sfd,
  output wire stat_rx_got_signal_os,
  output wire [1:0] stat_rx_test_pattern_mismatch,
  output wire stat_rx_truncated,
  output wire stat_rx_local_fault,
  output wire stat_rx_remote_fault,
  output wire stat_rx_internal_local_fault,
  output wire stat_rx_received_local_fault,
  output wire stat_tx_underflow_err,
  output wire stat_tx_overflow_err,
  output wire stat_tx_total_packets,
  output wire [4:0] stat_tx_total_bytes,
  output wire stat_tx_total_good_packets,
  output wire [13:0] stat_tx_total_good_bytes,
  output wire stat_tx_packet_64_bytes,
  output wire stat_tx_packet_65_127_bytes,
  output wire stat_tx_packet_128_255_bytes,
  output wire stat_tx_packet_256_511_bytes,
  output wire stat_tx_packet_512_1023_bytes,
  output wire stat_tx_packet_1024_1518_bytes,
  output wire stat_tx_packet_1519_1522_bytes,
  output wire stat_tx_packet_1523_1548_bytes,
  output wire stat_tx_packet_small,
  output wire stat_tx_packet_large,
  output wire stat_tx_packet_1549_2047_bytes,
  output wire stat_tx_packet_2048_4095_bytes,
  output wire stat_tx_packet_4096_8191_bytes,
  output wire stat_tx_packet_8192_9215_bytes,
  output wire stat_tx_bad_fcs,
  output wire stat_tx_frame_error,
  output wire stat_tx_local_fault,



  //// #-------------------
  //// # User Interface
  //// #-------------------
  output wire rx_axis_tvalid,
  output wire [255:0] rx_axis_tdata,
  output wire rx_axis_tlast,
  output wire [31:0] rx_axis_tkeep,
  output wire rx_axis_tuser,
  output wire [55:0] rx_preambleout,
  output wire tx_axis_tready,
  input  wire tx_axis_tvalid,
  input  wire [255:0] tx_axis_tdata,
  input  wire tx_axis_tlast,
  input  wire [31:0] tx_axis_tkeep,
  input  wire tx_axis_tuser,
  output wire tx_unfout,
  input  wire [55:0] tx_preamblein,


  //// #---------------------
  //// # Tx/Rx Serdes Interface
  //// #---------------------
  output wire [63:0] tx_serdes_data0,
  output wire [3:0] tx_serdes_header0,
  output wire [5:0] tx_serdes_seq0,
  output wire [63:0] tx_serdes_data1,
  output wire [3:0] tx_serdes_header1,
  output wire [5:0] tx_serdes_seq1,

  //// #---------------------
  //// # Rx Serdes Interface
  //// #---------------------
  input  wire [63:0] rx_serdes_data0,
  input  wire [3:0] rx_serdes_header0,
  input  wire [1:0] rx_serdes_headervalid0,
  input  wire [1:0] rx_serdes_datavalid0,
  output wire [1:0] rx_serdes_bitslip0,
  input  wire [63:0] rx_serdes_data1,
  input  wire [3:0] rx_serdes_header1,
  input  wire [1:0] rx_serdes_headervalid1,
  input  wire [1:0] rx_serdes_datavalid1,
  output wire [1:0] rx_serdes_bitslip1,

  input  wire rx_serdes_clk,
  input  wire [1:0]rx_serdes_reset

);

  wire ctl_rx_forward_control = 1'b0;
  wire ctl_rx_check_ack = 0;
  wire [8:0] ctl_rx_pause_enable = 9'b0;
  wire ctl_rx_enable_gcp = 1'b0;
  wire ctl_rx_check_mcast_gcp = 1'b0;
  wire ctl_rx_check_ucast_gcp = 1'b0;
  wire [47:0] ctl_rx_pause_da_ucast = 48'h0;
  wire ctl_rx_check_sa_gcp = 1'b0;
  wire [47:0] ctl_rx_pause_sa = 48'h0;
  wire ctl_rx_check_etype_gcp = 1'b0;
  wire [15:0] ctl_rx_etype_gcp = 16'h0;
  wire ctl_rx_check_opcode_gcp = 1'b0;
  wire [15:0] ctl_rx_opcode_min_gcp = 16'h0;
  wire [15:0] ctl_rx_opcode_max_gcp = 16'h0;
  wire ctl_rx_enable_pcp = 1'b0;
  wire ctl_rx_check_mcast_pcp = 1'b0;
  wire ctl_rx_check_ucast_pcp = 1'b0;
  wire [47:0] ctl_rx_pause_da_mcast = 48'h0;
  wire ctl_rx_check_sa_pcp = 1'b0;
  wire ctl_rx_check_etype_pcp = 1'b0;
  wire [15:0] ctl_rx_etype_pcp = 16'h0;
  wire ctl_rx_check_opcode_pcp = 1'b0;
  wire [15:0] ctl_rx_opcode_min_pcp = 16'h0;
  wire [15:0] ctl_rx_opcode_max_pcp = 16'h0;
  wire ctl_rx_enable_gpp = 1'b0;
  wire ctl_rx_check_mcast_gpp = 1'b0;
  wire ctl_rx_check_ucast_gpp = 1'b0;
  wire ctl_rx_check_sa_gpp = 1'b0;
  wire ctl_rx_check_etype_gpp = 1'b0;
  wire [15:0] ctl_rx_etype_gpp = 16'h0;
  wire ctl_rx_check_opcode_gpp = 1'b0;
  wire [15:0] ctl_rx_opcode_gpp = 16'h0;
  wire ctl_rx_enable_ppp = 1'b0;
  wire ctl_rx_check_mcast_ppp = 1'b0;
  wire ctl_rx_check_ucast_ppp = 1'b0;
  wire ctl_rx_check_sa_ppp = 1'b0;
  wire ctl_rx_check_etype_ppp = 1'b0;
  wire [15:0] ctl_rx_etype_ppp = 16'h0;
  wire ctl_rx_check_opcode_ppp = 1'b0;
  wire [15:0] ctl_rx_opcode_ppp = 16'h0;
  wire [8:0] ctl_rx_pause_ack = 9'b0;
  wire stat_rx_unicast;
  wire stat_rx_multicast;
  wire stat_rx_broadcast;
  wire stat_rx_vlan;
  wire stat_rx_pause;
  wire stat_rx_user_pause;
  wire stat_rx_inrangeerr;
  wire [8:0] stat_rx_pause_valid;
  wire [15:0] stat_rx_pause_quanta0;
  wire [15:0] stat_rx_pause_quanta1;
  wire [15:0] stat_rx_pause_quanta2;
  wire [15:0] stat_rx_pause_quanta3;
  wire [15:0] stat_rx_pause_quanta4;
  wire [15:0] stat_rx_pause_quanta5;
  wire [15:0] stat_rx_pause_quanta6;
  wire [15:0] stat_rx_pause_quanta7;
  wire [15:0] stat_rx_pause_quanta8;
  wire [8:0] stat_rx_pause_req;
  wire [8:0] ctl_tx_pause_enable = 9'b0;
  wire [15:0] ctl_tx_pause_quanta0 = 16'b0;
  wire [15:0] ctl_tx_pause_refresh_timer0 = 16'b0;
  wire [15:0] ctl_tx_pause_quanta1 = 16'b0;
  wire [15:0] ctl_tx_pause_refresh_timer1 = 16'b0;
  wire [15:0] ctl_tx_pause_quanta2 = 16'b0;
  wire [15:0] ctl_tx_pause_refresh_timer2 = 16'b0;
  wire [15:0] ctl_tx_pause_quanta3 = 16'b0;
  wire [15:0] ctl_tx_pause_refresh_timer3 = 16'b0;
  wire [15:0] ctl_tx_pause_quanta4 = 16'b0;
  wire [15:0] ctl_tx_pause_refresh_timer4 = 16'b0;
  wire [15:0] ctl_tx_pause_quanta5 = 16'b0;
  wire [15:0] ctl_tx_pause_refresh_timer5 = 16'b0;
  wire [15:0] ctl_tx_pause_quanta6 = 16'b0;
  wire [15:0] ctl_tx_pause_refresh_timer6 = 16'b0;
  wire [15:0] ctl_tx_pause_quanta7 = 16'b0;
  wire [15:0] ctl_tx_pause_refresh_timer7 = 16'b0;
  wire [15:0] ctl_tx_pause_quanta8 = 16'b0;
  wire [15:0] ctl_tx_pause_refresh_timer8 = 16'b0;
  wire [47:0] ctl_tx_da_gpp = 48'h0;
  wire [47:0] ctl_tx_sa_gpp = 48'h0;
  wire [15:0] ctl_tx_ethertype_gpp = 16'h0;
  wire [15:0] ctl_tx_opcode_gpp = 16'h0;
  wire [47:0] ctl_tx_da_ppp = 8'h40;
  wire [47:0] ctl_tx_sa_ppp = 48'h0;
  wire [15:0] ctl_tx_ethertype_ppp = 16'h0;
  wire [15:0] ctl_tx_opcode_ppp = 16'h0;
  wire [8:0] ctl_tx_pause_req = 9'b0;
  wire ctl_tx_resend_pause = 1'b0;
  wire stat_tx_unicast;
  wire stat_tx_multicast;
  wire stat_tx_broadcast;
  wire stat_tx_vlan;
  wire stat_tx_pause;
  wire stat_tx_user_pause;
  wire [8:0] stat_tx_pause_valid;


  wire [15:0] ctl_tx_vl_length_minus1;
  wire [15:0] ctl_rx_vl_length_minus1;
  wire [63:0] ctl_tx_vl_marker_id0;// = 64'h907647336F89B8CC;
  wire [63:0] ctl_tx_vl_marker_id1;// = 64'hF0C4E6330F3B19CC;
  wire [63:0] ctl_tx_vl_marker_id2;// = 64'hC5659B333A9A64CC;
  wire [63:0] ctl_tx_vl_marker_id3;// = 64'hA2793D335D86C2CC;

  wire [63:0] ctl_rx_vl_marker_id0;// = 64'h907647336F89B8CC;
  wire [63:0] ctl_rx_vl_marker_id1;// = 64'hF0C4E6330F3B19CC;
  wire [63:0] ctl_rx_vl_marker_id2;// = 64'hC5659B333A9A64CC;
  wire [63:0] ctl_rx_vl_marker_id3;// = 64'hA2793D335D86C2CC;

  assign ctl_rx_vl_marker_id0 = {24'h907647, 8'h00, ~24'h907647, 8'h00};
  assign ctl_rx_vl_marker_id1 = {24'hF0C4E6, 8'h00, ~24'hF0C4E6, 8'h00};
  assign ctl_rx_vl_marker_id2 = {24'hC5659B, 8'h00, ~24'hC5659B, 8'h00};
  assign ctl_rx_vl_marker_id3 = {24'hA2793D, 8'h00, ~24'hA2793D, 8'h00};
  
  assign ctl_tx_vl_marker_id0 = {24'h907647, 8'h00, ~24'h907647, 8'h00};
  assign ctl_tx_vl_marker_id1 = {24'hF0C4E6, 8'h00, ~24'hF0C4E6, 8'h00};
  assign ctl_tx_vl_marker_id2 = {24'hC5659B, 8'h00, ~24'hC5659B, 8'h00};
  assign ctl_tx_vl_marker_id3 = {24'hA2793D, 8'h00, ~24'hA2793D, 8'h00};

`ifdef SIM_SPEED_UP
  assign ctl_rx_vl_length_minus1 = 16'h003F;
`else
  assign ctl_rx_vl_length_minus1 = 16'h3FFF;
`endif


`ifdef SIM_SPEED_UP
  assign ctl_tx_vl_length_minus1 = 16'h003F;
`else
  assign ctl_tx_vl_length_minus1 = 16'h3FFF;
`endif


  wire [79:0] ctl_rx_systemtimerin = 80'h0;
  wire [79:0] ctl_tx_systemtimerin = 80'h0;
  wire [1:0] tx_ptp_1588op_in = 2'b0;
  wire [15:0] tx_ptp_tag_field_in = 16'b0;

  wire stat_tx_ptp_fifo_read_error;
  wire stat_tx_ptp_fifo_write_error;
  wire tx_ptp_tstamp_valid_out;
  wire rx_ptp_tstamp_valid_out;
  wire [15:0] tx_ptp_tstamp_tag_out;
  wire [79:0] tx_ptp_tstamp_out;
  wire [79:0] rx_ptp_tstamp_out;
  wire [1:0] tx_ptp_pcslane_out;
  wire [1:0] rx_ptp_pcslane_out;
  wire [6:0] rx_lane_aligner_fill_0;
  wire [6:0] rx_lane_aligner_fill_1;
  wire [6:0] rx_lane_aligner_fill_2;
  wire [6:0] rx_lane_aligner_fill_3;

  wire ctl_rate_mode;
  assign ctl_rate_mode    = 1'b1;

  wire internal_ctl_tx_send_lfi;
  wire internal_ctl_tx_send_rfi;
  wire internal_ctl_tx_send_idle;

  assign internal_ctl_tx_send_lfi = ctl_tx_send_lfi;
  assign internal_ctl_tx_send_rfi = ctl_tx_send_rfi;
  assign internal_ctl_tx_send_idle = ctl_tx_send_idle;

wire stat_core_speed;
assign stat_core_speed = 1'b1;


  wire [63:0] internal_tx_serdes_data0;
  wire [3:0] internal_tx_serdes_header0;
  wire [5:0] internal_tx_serdes_seq0;
  wire [63:0] internal_tx_serdes_data1;
  wire [3:0] internal_tx_serdes_header1;
  wire [5:0] internal_tx_serdes_seq1;
  wire [63:0] internal_rx_serdes_data0;
  wire [3:0] internal_rx_serdes_header0;
  wire [1:0] internal_rx_serdes_headervalid0;
  wire [1:0] internal_rx_serdes_datavalid0;
  wire [1:0] internal_rx_serdes_bitslip0;
  wire [63:0] internal_rx_serdes_data1;
  wire [3:0] internal_rx_serdes_header1;
  wire [1:0] internal_rx_serdes_headervalid1;
  wire [1:0] internal_rx_serdes_datavalid1;
  wire [1:0] internal_rx_serdes_bitslip1;
  wire [63:0] hsec_tx_serdes_data0;
  wire [3:0] hsec_tx_serdes_header0;
  wire [5:0] hsec_tx_serdes_seq0;
  wire [63:0] hsec_tx_serdes_data1;
  wire [3:0] hsec_tx_serdes_header1;
  wire [5:0] hsec_tx_serdes_seq1;
  wire [63:0] hsec_rx_serdes_data0;
  wire [3:0] hsec_rx_serdes_header0;
  wire [1:0] hsec_rx_serdes_headervalid0;
  wire [1:0] hsec_rx_serdes_datavalid0;
  wire [1:0] hsec_rx_serdes_bitslip0;
  wire [63:0] hsec_rx_serdes_data1;
  wire [3:0] hsec_rx_serdes_header1;
  wire [1:0] hsec_rx_serdes_headervalid1;
  wire [1:0] hsec_rx_serdes_datavalid1;
  wire [1:0] hsec_rx_serdes_bitslip1;

  assign hsec_rx_serdes_data0 = internal_rx_serdes_data0;
  assign hsec_rx_serdes_header0 = internal_rx_serdes_header0;
  assign hsec_rx_serdes_datavalid0 = internal_rx_serdes_datavalid0;
  assign hsec_rx_serdes_headervalid0 = internal_rx_serdes_headervalid0;
  assign hsec_rx_serdes_data1 = internal_rx_serdes_data1;
  assign hsec_rx_serdes_header1 = internal_rx_serdes_header1;
  assign hsec_rx_serdes_datavalid1 = internal_rx_serdes_datavalid1;
  assign hsec_rx_serdes_headervalid1 = internal_rx_serdes_headervalid1;

  assign internal_tx_serdes_data0 = hsec_tx_serdes_data0;
  assign internal_tx_serdes_header0 = hsec_tx_serdes_header0;

  assign internal_rx_serdes_bitslip0 = hsec_rx_serdes_bitslip0;
  assign internal_tx_serdes_seq0 = hsec_tx_serdes_seq0;
  assign internal_tx_serdes_data1 = hsec_tx_serdes_data1;
  assign internal_tx_serdes_header1 = hsec_tx_serdes_header1;

  assign internal_rx_serdes_bitslip1 = hsec_rx_serdes_bitslip1;
  assign internal_tx_serdes_seq1 = hsec_tx_serdes_seq1;

  //// #---------------------------------------------------------
  //// #                      Core
  //// #---------------------------------------------------------

  l_ethernet_v2_5_0_mac_baser_256_hsec_cores #(

    .SERDES_WIDTH                   (SERDES_WIDTH),
    .TIMESTAMP_WIDTH                (TIMESTAMP_WIDTH)

  ) i_HSEC_CORES (

    .clk (tx_clk),
    .tx_serdes_refclk (tx_serdes_refclk),
    .tx_serdes_refclk_reset (tx_serdes_refclk_reset),
    .rx_serdes_clk (rx_serdes_clk),

    .tx_reset (tx_reset),
    .rx_reset (rx_reset),
    .rx_serdes_reset ( rx_serdes_reset),
    .ctl_tx_vl_length_minus1 (ctl_tx_vl_length_minus1),
    .ctl_tx_test_pattern (ctl_tx_test_pattern),
    .ctl_tx_fcs_ins_enable (ctl_tx_fcs_ins_enable),
    .ctl_tx_ipg_value (ctl_tx_ipg_value),
    .ctl_tx_custom_preamble_enable (ctl_tx_custom_preamble_enable),
    .ctl_tx_ignore_fcs (ctl_tx_ignore_fcs),
    .ctl_tx_da_gpp (ctl_tx_da_gpp),
    .ctl_tx_sa_gpp (ctl_tx_sa_gpp),
    .ctl_tx_ethertype_gpp (ctl_tx_ethertype_gpp),
    .ctl_tx_opcode_gpp (ctl_tx_opcode_gpp),
    .ctl_tx_da_ppp (ctl_tx_da_ppp),
    .ctl_tx_sa_ppp (ctl_tx_sa_ppp),
    .ctl_tx_ethertype_ppp (ctl_tx_ethertype_ppp),
    .ctl_tx_opcode_ppp (ctl_tx_opcode_ppp),
    .ctl_tx_vl_marker_id0 (ctl_tx_vl_marker_id0),
    .ctl_tx_vl_marker_id1 (ctl_tx_vl_marker_id1),
    .ctl_tx_vl_marker_id2 (ctl_tx_vl_marker_id2),
    .ctl_tx_vl_marker_id3 (ctl_tx_vl_marker_id3),
    .ctl_tx_enable (ctl_tx_enable),
    .ctl_tx_pause_req (ctl_tx_pause_req),
    .ctl_tx_pause_enable (ctl_tx_pause_enable),
    .ctl_tx_resend_pause (ctl_tx_resend_pause),
    .ctl_tx_systemtimerin (ctl_tx_systemtimerin),
    .ctl_tx_pause_quanta0 (ctl_tx_pause_quanta0),
    .ctl_tx_pause_refresh_timer0 (ctl_tx_pause_refresh_timer0),
    .ctl_tx_pause_quanta1 (ctl_tx_pause_quanta1),
    .ctl_tx_pause_refresh_timer1 (ctl_tx_pause_refresh_timer1),
    .ctl_tx_pause_quanta2 (ctl_tx_pause_quanta2),
    .ctl_tx_pause_refresh_timer2 (ctl_tx_pause_refresh_timer2),
    .ctl_tx_pause_quanta3 (ctl_tx_pause_quanta3),
    .ctl_tx_pause_refresh_timer3 (ctl_tx_pause_refresh_timer3),
    .ctl_tx_pause_quanta4 (ctl_tx_pause_quanta4),
    .ctl_tx_pause_refresh_timer4 (ctl_tx_pause_refresh_timer4),
    .ctl_tx_pause_quanta5 (ctl_tx_pause_quanta5),
    .ctl_tx_pause_refresh_timer5 (ctl_tx_pause_refresh_timer5),
    .ctl_tx_pause_quanta6 (ctl_tx_pause_quanta6),
    .ctl_tx_pause_refresh_timer6 (ctl_tx_pause_refresh_timer6),
    .ctl_tx_pause_quanta7 (ctl_tx_pause_quanta7),
    .ctl_tx_pause_refresh_timer7 (ctl_tx_pause_refresh_timer7),
    .ctl_tx_pause_quanta8 (ctl_tx_pause_quanta8),
    .ctl_tx_pause_refresh_timer8 (ctl_tx_pause_refresh_timer8),

    .ctl_rx_vl_length_minus1 (ctl_rx_vl_length_minus1),
    .ctl_rx_delete_fcs (ctl_rx_delete_fcs),
    .ctl_rx_ignore_fcs (ctl_rx_ignore_fcs),
    .ctl_rx_max_packet_len (ctl_rx_max_packet_len),
    .ctl_rx_min_packet_len (ctl_rx_min_packet_len),
    .ctl_rx_custom_preamble_enable (ctl_rx_custom_preamble_enable),
    .ctl_rx_check_sfd (ctl_rx_check_sfd),
    .ctl_rx_check_preamble (ctl_rx_check_preamble),
    .ctl_rx_process_lfi (ctl_rx_process_lfi),
    .ctl_rx_force_resync (ctl_rx_force_resync),
    .ctl_rx_forward_control (ctl_rx_forward_control),
    .ctl_rx_check_ack (ctl_rx_check_ack),
    .ctl_rx_pause_da_ucast (ctl_rx_pause_da_ucast),
    .ctl_rx_pause_sa (ctl_rx_pause_sa),
    .ctl_rx_etype_gcp (ctl_rx_etype_gcp),
    .ctl_rx_opcode_min_gcp (ctl_rx_opcode_min_gcp),
    .ctl_rx_opcode_max_gcp (ctl_rx_opcode_max_gcp),
    .ctl_rx_pause_da_mcast (ctl_rx_pause_da_mcast),
    .ctl_rx_etype_pcp (ctl_rx_etype_pcp),
    .ctl_rx_opcode_min_pcp (ctl_rx_opcode_min_pcp),
    .ctl_rx_opcode_max_pcp (ctl_rx_opcode_max_pcp),
    .ctl_rx_etype_gpp (ctl_rx_etype_gpp),
    .ctl_rx_opcode_gpp (ctl_rx_opcode_gpp),
    .ctl_rx_etype_ppp (ctl_rx_etype_ppp),
    .ctl_rx_opcode_ppp (ctl_rx_opcode_ppp),
    .ctl_rx_vl_marker_id0 (ctl_rx_vl_marker_id0),
    .ctl_rx_vl_marker_id1 (ctl_rx_vl_marker_id1),
    .ctl_rx_vl_marker_id2 (ctl_rx_vl_marker_id2),
    .ctl_rx_vl_marker_id3 (ctl_rx_vl_marker_id3),
    .ctl_rx_test_pattern (ctl_rx_test_pattern),
    .ctl_rx_enable (ctl_rx_enable),
    .ctl_rx_pause_ack (ctl_rx_pause_ack),
    .ctl_rx_pause_enable (ctl_rx_pause_enable),
    .ctl_rx_systemtimerin (ctl_rx_systemtimerin),
    .ctl_rx_enable_gcp (ctl_rx_enable_gcp),
    .ctl_rx_check_mcast_gcp (ctl_rx_check_mcast_gcp),
    .ctl_rx_check_ucast_gcp (ctl_rx_check_ucast_gcp),
    .ctl_rx_check_sa_gcp (ctl_rx_check_sa_gcp),
    .ctl_rx_check_etype_gcp (ctl_rx_check_etype_gcp),
    .ctl_rx_check_opcode_gcp (ctl_rx_check_opcode_gcp),
    .ctl_rx_enable_pcp (ctl_rx_enable_pcp),
    .ctl_rx_check_mcast_pcp (ctl_rx_check_mcast_pcp),
    .ctl_rx_check_ucast_pcp (ctl_rx_check_ucast_pcp),
    .ctl_rx_check_sa_pcp (ctl_rx_check_sa_pcp),
    .ctl_rx_check_etype_pcp (ctl_rx_check_etype_pcp),
    .ctl_rx_check_opcode_pcp (ctl_rx_check_opcode_pcp),
    .ctl_rx_enable_gpp (ctl_rx_enable_gpp),
    .ctl_rx_check_mcast_gpp (ctl_rx_check_mcast_gpp),
    .ctl_rx_check_ucast_gpp (ctl_rx_check_ucast_gpp),
    .ctl_rx_check_sa_gpp (ctl_rx_check_sa_gpp),
    .ctl_rx_check_etype_gpp (ctl_rx_check_etype_gpp),
    .ctl_rx_check_opcode_gpp (ctl_rx_check_opcode_gpp),
    .ctl_rx_enable_ppp (ctl_rx_enable_ppp),
    .ctl_rx_check_mcast_ppp (ctl_rx_check_mcast_ppp),
    .ctl_rx_check_ucast_ppp (ctl_rx_check_ucast_ppp),
    .ctl_rx_check_sa_ppp (ctl_rx_check_sa_ppp),
    .ctl_rx_check_etype_ppp (ctl_rx_check_etype_ppp),
    .ctl_rx_check_opcode_ppp (ctl_rx_check_opcode_ppp),


    .ctl_data_rate (ctl_rate_mode),
    .ctl_tx_send_lfi (internal_ctl_tx_send_lfi),
    .ctl_tx_send_rfi (internal_ctl_tx_send_rfi),
    .ctl_tx_send_idle (internal_ctl_tx_send_idle),

    .tx_axis_tready (tx_axis_tready),
    .tx_axis_tvalid (tx_axis_tvalid),
    .tx_axis_tdata (tx_axis_tdata),
    .tx_axis_tlast (tx_axis_tlast),
    .tx_axis_tuser (tx_axis_tuser),
    .tx_axis_tkeep (tx_axis_tkeep),
    .tx_unfout (tx_unfout),
    .tx_preamblein (tx_preamblein),
    .tx_ptp_tstamp_valid_out (tx_ptp_tstamp_valid_out),
    .rx_ptp_tstamp_valid_out (rx_ptp_tstamp_valid_out),
    .tx_ptp_tstamp_tag_out (tx_ptp_tstamp_tag_out),
    .tx_ptp_tstamp_out (tx_ptp_tstamp_out),
    .tx_ptp_pcslane_out (tx_ptp_pcslane_out),
    .tx_ptp_1588op_in (tx_ptp_1588op_in),
    .tx_ptp_tag_field_in (tx_ptp_tag_field_in),

    .rx_axis_tvalid (rx_axis_tvalid),
    .rx_axis_tdata (rx_axis_tdata),
    .rx_axis_tuser (rx_axis_tuser),
    .rx_axis_tlast (rx_axis_tlast),
    .rx_axis_tkeep (rx_axis_tkeep),
    .rx_preambleout (rx_preambleout),
    .rx_lane_aligner_fill_0 (rx_lane_aligner_fill_0),
    .rx_lane_aligner_fill_1 (rx_lane_aligner_fill_1),
    .rx_lane_aligner_fill_2 (rx_lane_aligner_fill_2),
    .rx_lane_aligner_fill_3 (rx_lane_aligner_fill_3),
    .rx_ptp_tstamp_out (rx_ptp_tstamp_out),
    .rx_ptp_pcslane_out (rx_ptp_pcslane_out),

    .tx_serdes_data0 (hsec_tx_serdes_data0),
    .tx_serdes_header0 (hsec_tx_serdes_header0),
    .tx_serdes_seq0 (hsec_tx_serdes_seq0),
    .tx_serdes_data1 (hsec_tx_serdes_data1),
    .tx_serdes_header1 (hsec_tx_serdes_header1),
    .tx_serdes_seq1 (hsec_tx_serdes_seq1),
    .rx_serdes_data0 (hsec_rx_serdes_data0),
    .rx_serdes_header0 (hsec_rx_serdes_header0),
    .rx_serdes_headervalid0 (hsec_rx_serdes_headervalid0),
    .rx_serdes_datavalid0 (hsec_rx_serdes_datavalid0),
    .rx_serdes_bitslip0 (hsec_rx_serdes_bitslip0),
    .rx_serdes_data1 (hsec_rx_serdes_data1),
    .rx_serdes_header1 (hsec_rx_serdes_header1),
    .rx_serdes_headervalid1 (hsec_rx_serdes_headervalid1),
    .rx_serdes_datavalid1 (hsec_rx_serdes_datavalid1),
    .rx_serdes_bitslip1 (hsec_rx_serdes_bitslip1),

    .stat_tx_ptp_fifo_read_error (stat_tx_ptp_fifo_read_error),
    .stat_tx_ptp_fifo_write_error (stat_tx_ptp_fifo_write_error),
    .stat_tx_total_packets (stat_tx_total_packets),
    .stat_tx_total_bytes (stat_tx_total_bytes),
    .stat_tx_total_good_packets (stat_tx_total_good_packets),
    .stat_tx_total_good_bytes (stat_tx_total_good_bytes),
    .stat_tx_packet_64_bytes (stat_tx_packet_64_bytes),
    .stat_tx_packet_65_127_bytes (stat_tx_packet_65_127_bytes),
    .stat_tx_packet_128_255_bytes (stat_tx_packet_128_255_bytes),
    .stat_tx_packet_256_511_bytes (stat_tx_packet_256_511_bytes),
    .stat_tx_packet_512_1023_bytes (stat_tx_packet_512_1023_bytes),
    .stat_tx_packet_1024_1518_bytes (stat_tx_packet_1024_1518_bytes),
    .stat_tx_packet_1519_1522_bytes (stat_tx_packet_1519_1522_bytes),
    .stat_tx_packet_1523_1548_bytes (stat_tx_packet_1523_1548_bytes),
    .stat_tx_packet_small (stat_tx_packet_small),
    .stat_tx_packet_large (stat_tx_packet_large),
    .stat_tx_packet_1549_2047_bytes (stat_tx_packet_1549_2047_bytes),
    .stat_tx_packet_2048_4095_bytes (stat_tx_packet_2048_4095_bytes),
    .stat_tx_packet_4096_8191_bytes (stat_tx_packet_4096_8191_bytes),
    .stat_tx_packet_8192_9215_bytes (stat_tx_packet_8192_9215_bytes),
    .stat_tx_unicast (stat_tx_unicast),
    .stat_tx_multicast (stat_tx_multicast),
    .stat_tx_broadcast (stat_tx_broadcast),
    .stat_tx_vlan (stat_tx_vlan),
    .stat_tx_pause (stat_tx_pause),
    .stat_tx_user_pause (stat_tx_user_pause),
    .stat_tx_bad_fcs (stat_tx_bad_fcs),
    .stat_tx_frame_error (stat_tx_frame_error),
    .stat_tx_local_fault (stat_tx_local_fault),
    .stat_tx_pause_valid (stat_tx_pause_valid),

    .stat_rx_block_lock (stat_rx_block_lock),
    .stat_rx_framing_err_valid_0 (stat_rx_framing_err_valid_0),
    .stat_rx_framing_err_0 (stat_rx_framing_err_0),
    .stat_rx_framing_err_valid_1 (stat_rx_framing_err_valid_1),
    .stat_rx_framing_err_1 (stat_rx_framing_err_1),
    .stat_rx_framing_err_valid_2 (stat_rx_framing_err_valid_2),
    .stat_rx_framing_err_2 (stat_rx_framing_err_2),
    .stat_rx_framing_err_valid_3 (stat_rx_framing_err_valid_3),
    .stat_rx_framing_err_3 (stat_rx_framing_err_3),
    .stat_rx_vl_demuxed (stat_rx_vl_demuxed),
    .stat_rx_vl_number_0 (stat_rx_vl_number_0),
    .stat_rx_vl_number_1 (stat_rx_vl_number_1),
    .stat_rx_vl_number_2 (stat_rx_vl_number_2),
    .stat_rx_vl_number_3 (stat_rx_vl_number_3),
    .stat_rx_synced (stat_rx_synced),
    .stat_rx_synced_err (stat_rx_synced_err),
    .stat_rx_mf_len_err (stat_rx_mf_len_err),
    .stat_rx_mf_repeat_err (stat_rx_mf_repeat_err),
    .stat_rx_mf_err (stat_rx_mf_err),
    .stat_rx_bip_err_0 (stat_rx_bip_err_0),
    .stat_rx_bip_err_1 (stat_rx_bip_err_1),
    .stat_rx_bip_err_2 (stat_rx_bip_err_2),
    .stat_rx_bip_err_3 (stat_rx_bip_err_3),
    .stat_rx_total_packets (stat_rx_total_packets),
    .stat_rx_total_good_packets (stat_rx_total_good_packets),
    .stat_rx_total_bytes (stat_rx_total_bytes),
    .stat_rx_total_good_bytes (stat_rx_total_good_bytes),
    .stat_rx_packet_small (stat_rx_packet_small),
    .stat_rx_jabber (stat_rx_jabber),
    .stat_rx_packet_large (stat_rx_packet_large),
    .stat_rx_oversize (stat_rx_oversize),
    .stat_rx_undersize (stat_rx_undersize),
    .stat_rx_toolong (stat_rx_toolong),
    .stat_rx_fragment (stat_rx_fragment),
    .stat_rx_packet_64_bytes (stat_rx_packet_64_bytes),
    .stat_rx_packet_65_127_bytes (stat_rx_packet_65_127_bytes),
    .stat_rx_packet_128_255_bytes (stat_rx_packet_128_255_bytes),
    .stat_rx_packet_256_511_bytes (stat_rx_packet_256_511_bytes),
    .stat_rx_packet_512_1023_bytes (stat_rx_packet_512_1023_bytes),
    .stat_rx_packet_1024_1518_bytes (stat_rx_packet_1024_1518_bytes),
    .stat_rx_packet_1519_1522_bytes (stat_rx_packet_1519_1522_bytes),
    .stat_rx_packet_1523_1548_bytes (stat_rx_packet_1523_1548_bytes),
    .stat_rx_bad_fcs (stat_rx_bad_fcs),
    .stat_rx_packet_bad_fcs (stat_rx_packet_bad_fcs),
    .stat_rx_stomped_fcs (stat_rx_stomped_fcs),
    .stat_rx_packet_1549_2047_bytes (stat_rx_packet_1549_2047_bytes),
    .stat_rx_packet_2048_4095_bytes (stat_rx_packet_2048_4095_bytes),
    .stat_rx_packet_4096_8191_bytes (stat_rx_packet_4096_8191_bytes),
    .stat_rx_packet_8192_9215_bytes (stat_rx_packet_8192_9215_bytes),
    .stat_rx_unicast (stat_rx_unicast),
    .stat_rx_multicast (stat_rx_multicast),
    .stat_rx_broadcast (stat_rx_broadcast),
    .stat_rx_vlan (stat_rx_vlan),
    .stat_rx_pause (stat_rx_pause),
    .stat_rx_user_pause (stat_rx_user_pause),
    .stat_rx_inrangeerr (stat_rx_inrangeerr),
    .stat_rx_bad_preamble (stat_rx_bad_preamble),
    .stat_rx_bad_sfd (stat_rx_bad_sfd),
    .stat_rx_got_signal_os (stat_rx_got_signal_os),
    .stat_rx_test_pattern_mismatch (stat_rx_test_pattern_mismatch),
    .stat_rx_pause_req (stat_rx_pause_req),
    .stat_rx_local_fault (stat_rx_local_fault),
    .stat_rx_remote_fault (stat_rx_remote_fault),
    .stat_rx_internal_local_fault (stat_rx_internal_local_fault),
    .stat_rx_received_local_fault (stat_rx_received_local_fault),
    .stat_rx_misaligned (stat_rx_misaligned),
    .stat_rx_aligned_err (stat_rx_aligned_err),
    .stat_rx_aligned (stat_rx_aligned),
    .stat_rx_hi_ber (stat_rx_hi_ber),
    .stat_rx_status (stat_rx_status),
    .stat_rx_bad_code (stat_rx_bad_code),
    .stat_tx_underflow_err (stat_tx_underflow_err),
    .stat_tx_overflow_err (stat_tx_overflow_err),
    .stat_rx_truncated (stat_rx_truncated),
    .stat_rx_pause_valid (stat_rx_pause_valid),
    .stat_rx_pause_quanta0 (stat_rx_pause_quanta0),
    .stat_rx_pause_quanta1 (stat_rx_pause_quanta1),
    .stat_rx_pause_quanta2 (stat_rx_pause_quanta2),
    .stat_rx_pause_quanta3 (stat_rx_pause_quanta3),
    .stat_rx_pause_quanta4 (stat_rx_pause_quanta4),
    .stat_rx_pause_quanta5 (stat_rx_pause_quanta5),
    .stat_rx_pause_quanta6 (stat_rx_pause_quanta6),
    .stat_rx_pause_quanta7 (stat_rx_pause_quanta7),
    .stat_rx_pause_quanta8 (stat_rx_pause_quanta8)
  );  // i_HSEC_CORES

// mrpcs_rsfec inst

  assign internal_rx_serdes_data0          = rx_serdes_data0;
  assign internal_rx_serdes_header0        = rx_serdes_header0;
  assign internal_rx_serdes_headervalid0   = rx_serdes_headervalid0;
  assign internal_rx_serdes_datavalid0     = rx_serdes_datavalid0;

  assign internal_rx_serdes_data1          = rx_serdes_data1;
  assign internal_rx_serdes_header1        = rx_serdes_header1;
  assign internal_rx_serdes_headervalid1   = rx_serdes_headervalid1;
  assign internal_rx_serdes_datavalid1     = rx_serdes_datavalid1;

  assign tx_serdes_data1      = internal_tx_serdes_data1;
  assign tx_serdes_header1    = internal_tx_serdes_header1;
  assign rx_serdes_bitslip1   = internal_rx_serdes_bitslip1;
  assign tx_serdes_seq1       = internal_tx_serdes_seq1;
  assign tx_serdes_data0      = internal_tx_serdes_data0;
  assign tx_serdes_header0    = internal_tx_serdes_header0;
  assign rx_serdes_bitslip0   = internal_rx_serdes_bitslip0;
  assign tx_serdes_seq0       = internal_tx_serdes_seq0;




endmodule

(* DowngradeIPIdentifiedWarnings="yes" *)

module  l_ethernet_0_1_mac_baser_syncer_reset
#(
  parameter RESET_PIPE_LEN = 3
 )
(
  input  wire clk,
  input  wire reset_async,
  output wire reset
);

  (* ASYNC_REG = "TRUE" *) reg  [2:0] reset_pipe_stretch;
  (* ASYNC_REG = "TRUE" *) reg  [RESET_PIPE_LEN-1:0] reset_pipe_retime;
  (* max_fanout = 500 *) reg  reset_pipe_out;

// pragma translate_off

  initial reset_pipe_stretch = {2{1'b1}};
  initial reset_pipe_retime  = {RESET_PIPE_LEN{1'b1}};
  initial reset_pipe_out     = 1'b1;

// pragma translate_on

  always @(posedge clk or posedge reset_async)
    begin
      if (reset_async == 1'b1)
        begin
          reset_pipe_stretch <= {3{1'b1}};
        end
      else
        begin
          reset_pipe_stretch <= {reset_pipe_stretch[1:0], 1'b0};
        end
    end

  always @(posedge clk)
    begin
      reset_pipe_retime <= {reset_pipe_retime[RESET_PIPE_LEN-2:0], reset_pipe_stretch[2]};
      reset_pipe_out    <= reset_pipe_retime[RESET_PIPE_LEN-1];
    end

  assign reset = reset_pipe_out;

endmodule

