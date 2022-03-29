`timescale 1fs/1fs

(* DowngradeIPIdentifiedWarnings="yes" *)
module l_ethernet_0_exdes_1
(
  input  wire [4-1:0] gt_rxp_in,
  input  wire [4-1:0] gt_rxn_in,
  output wire [4-1:0] gt_txp_out,
  output wire [4-1:0] gt_txn_out,
  // input wire send_continuous_pkts_0,
  //   output wire       rx_gt_locked_led,
  //   output wire       rx_aligned_led,
  //   output wire [4:0] completion_status,

    input             sys_reset,
    // input             restart_tx_rx,

    input             gt_refclk_p,
    input             gt_refclk_n,
    input             dclk,
    
    output            rx_core_clk_0,
    output            user_rx_reset_0 ,

    output            rx_axis_tvalid,
    output [255:0]    rx_axis_tdata,
    output            rx_axis_tlast,
    output [31:0]     rx_axis_tkeep,
    output            rx_axis_tuser,

    output            tx_axis_tready,
    input             tx_axis_tvalid,
    input  [255:0]    tx_axis_tdata,
    input             tx_axis_tlast,
    input  [31:0]     tx_axis_tkeep,
    input             tx_axis_tuser

);

`ifdef SIM_SPEED_UP
  parameter PKT_NUM         = 20;    //// Many Internal Counters are based on PKT_NUM = 20
`else
  parameter PKT_NUM         = 1000;    //// Many Internal Counters are based on PKT_NUM = 1000
`endif
  wire gt_refclk_out;

  wire gtwiz_reset_tx_datapath_0; 
  wire gtwiz_reset_rx_datapath_0; 
  assign gtwiz_reset_tx_datapath_0 = 1'b0; 
  assign gtwiz_reset_rx_datapath_0 = 1'b0; 
  wire rx_gt_locked_led_0;
  wire rx_aligned_led_0;

  //wire rx_core_clk_0;
  wire rx_clk_out_0;
  wire tx_clk_out_0;
  //assign rx_core_clk_0 = tx_clk_out_0;
  assign rx_core_clk_0 = tx_clk_out_0;

//// For other GT loopback options please change the value appropriately
//// For example, for internal loopback gt_loopback_in[2:0] = 3'b010;
//// For more information and settings on loopback, refer GT Transceivers user guide

  wire [11:0] gt_loopback_in_0;
  assign gt_loopback_in_0 = {4{3'b000}};

  wire sys_reset_out ;
//// RX_0 Signals
  wire rx_reset_0;
  //wire user_rx_reset_0;

//// RX_0 User Interface Signals
  wire rx_axis_tvalid_0;
  wire [255:0] rx_axis_tdata_0;
  wire [0:0] rx_axis_tuser_0;
  wire [31:0] rx_axis_tkeep_0;
  wire rx_axis_tlast_0;
  wire [55:0] rx_preambleout_0;

//// RX_0 Control Signals
  wire ctl_rx_test_pattern_0;
  wire ctl_rx_enable_0;
  wire ctl_rx_delete_fcs_0;
  wire ctl_rx_ignore_fcs_0;
  wire [14:0] ctl_rx_max_packet_len_0;
  wire [7:0] ctl_rx_min_packet_len_0;
  wire ctl_rx_check_sfd_0;
  wire ctl_rx_check_preamble_0;
  wire ctl_rx_process_lfi_0;
  wire ctl_rx_force_resync_0;


//// RX_0 Stats Signals
  wire [3:0] stat_rx_block_lock_0;
  wire stat_rx_framing_err_valid_0_0;
  wire stat_rx_framing_err_0_0;
  wire stat_rx_framing_err_valid_1_0;
  wire stat_rx_framing_err_1_0;
  wire stat_rx_framing_err_valid_2_0;
  wire stat_rx_framing_err_2_0;
  wire stat_rx_framing_err_valid_3_0;
  wire stat_rx_framing_err_3_0;
  wire [3:0] stat_rx_vl_demuxed_0;
  wire [1:0] stat_rx_vl_number_0_0;
  wire [1:0] stat_rx_vl_number_1_0;
  wire [1:0] stat_rx_vl_number_2_0;
  wire [1:0] stat_rx_vl_number_3_0;
  wire [3:0] stat_rx_synced_0;
  wire stat_rx_misaligned_0;
  wire stat_rx_aligned_err_0;
  wire [3:0] stat_rx_synced_err_0;
  wire [3:0] stat_rx_mf_len_err_0;
  wire [3:0] stat_rx_mf_repeat_err_0;
  wire [3:0] stat_rx_mf_err_0;
  wire stat_rx_bip_err_0_0;
  wire stat_rx_bip_err_1_0;
  wire stat_rx_bip_err_2_0;
  wire stat_rx_bip_err_3_0;
  wire stat_rx_aligned_0;
  wire stat_rx_hi_ber_0;
  wire stat_rx_status_0;
  wire [1:0] stat_rx_bad_code_0;
  wire [1:0] stat_rx_total_packets_0;
  wire stat_rx_total_good_packets_0;
  wire [5:0] stat_rx_total_bytes_0;
  wire [13:0] stat_rx_total_good_bytes_0;
  wire [1:0] stat_rx_packet_small_0;
  wire stat_rx_jabber_0;
  wire stat_rx_packet_large_0;
  wire stat_rx_oversize_0;
  wire [1:0] stat_rx_undersize_0;
  wire stat_rx_toolong_0;
  wire [1:0] stat_rx_fragment_0;
  wire stat_rx_packet_64_bytes_0;
  wire stat_rx_packet_65_127_bytes_0;
  wire stat_rx_packet_128_255_bytes_0;
  wire stat_rx_packet_256_511_bytes_0;
  wire stat_rx_packet_512_1023_bytes_0;
  wire stat_rx_packet_1024_1518_bytes_0;
  wire stat_rx_packet_1519_1522_bytes_0;
  wire stat_rx_packet_1523_1548_bytes_0;
  wire [1:0] stat_rx_bad_fcs_0;
  wire stat_rx_packet_bad_fcs_0;
  wire [1:0] stat_rx_stomped_fcs_0;
  wire stat_rx_packet_1549_2047_bytes_0;
  wire stat_rx_packet_2048_4095_bytes_0;
  wire stat_rx_packet_4096_8191_bytes_0;
  wire stat_rx_packet_8192_9215_bytes_0;
  wire stat_rx_bad_preamble_0;
  wire stat_rx_bad_sfd_0;
  wire stat_rx_got_signal_os_0;
  wire [1:0] stat_rx_test_pattern_mismatch_0;
  wire stat_rx_truncated_0;
  wire stat_rx_local_fault_0;
  wire stat_rx_remote_fault_0;
  wire stat_rx_internal_local_fault_0;
  wire stat_rx_received_local_fault_0;


//// TX_0 Signals
  wire tx_reset_0;
  wire user_tx_reset_0;

//// TX_0 User Interface Signals
  wire tx_axis_tready_0;
  wire tx_axis_tvalid_0;
  wire [255:0] tx_axis_tdata_0;
  wire [31:0] tx_axis_tkeep_0;
  wire [0:0] tx_axis_tuser_0;
  wire  tx_axis_tlast_0;
  wire tx_unfout_0;
  wire [55:0] tx_preamblein_0;

//// TX_0 Control Signals
  wire ctl_tx_test_pattern_0;
  wire ctl_tx_enable_0;
  wire ctl_tx_fcs_ins_enable_0;
  wire [3:0] ctl_tx_ipg_value_0;
  wire ctl_tx_send_lfi_0;
  wire ctl_tx_send_rfi_0;
  wire ctl_tx_send_idle_0;
  wire ctl_tx_custom_preamble_enable_0;
  wire ctl_tx_ignore_fcs_0;


//// TX_0 Stats Signals
  wire stat_tx_underflow_err_0;
  wire stat_tx_overflow_err_0;
  wire stat_tx_total_packets_0;
  wire [4:0] stat_tx_total_bytes_0;
  wire stat_tx_total_good_packets_0;
  wire [13:0] stat_tx_total_good_bytes_0;
  wire stat_tx_packet_64_bytes_0;
  wire stat_tx_packet_65_127_bytes_0;
  wire stat_tx_packet_128_255_bytes_0;
  wire stat_tx_packet_256_511_bytes_0;
  wire stat_tx_packet_512_1023_bytes_0;
  wire stat_tx_packet_1024_1518_bytes_0;
  wire stat_tx_packet_1519_1522_bytes_0;
  wire stat_tx_packet_1523_1548_bytes_0;
  wire stat_tx_packet_small_0;
  wire stat_tx_packet_large_0;
  wire stat_tx_packet_1549_2047_bytes_0;
  wire stat_tx_packet_2048_4095_bytes_0;
  wire stat_tx_packet_4096_8191_bytes_0;
  wire stat_tx_packet_8192_9215_bytes_0;
  wire stat_tx_bad_fcs_0;
  wire stat_tx_frame_error_0;
  wire stat_tx_local_fault_0;





  wire [4:0] completion_status_0;
  wire [3:0] rxrecclkout_0;
  wire [3:0] gtpowergood_out_0;
  wire [11:0] txoutclksel_in_0;
  wire [11:0] rxoutclksel_in_0;
  assign txoutclksel_in_0 = {4{3'b101}};     // This value should not be changed as per gtwizard 
  assign rxoutclksel_in_0 = {4{3'b101}};    // This value should not be changed as per gtwizard


  wire usr_fsm_clk;
 //  clk_wiz_0 i_CLK_GEN_0
 //   (
 //   //// Clock in ports
 //    .clk_in1    (dclk), 
 //    .clk_out1   (usr_fsm_clk),
 //    .reset      (1'b0),
 //    .locked     ()
 // );

l_ethernet_0_1 DUT
(
    .gt_rxp_in_0(gt_rxp_in[0]),                                            // input wire gt_rxp_in_0
    .gt_rxp_in_1(gt_rxp_in[1]),                                            // input wire gt_rxp_in_1
    .gt_rxp_in_2(gt_rxp_in[2]),                                            // input wire gt_rxp_in_2
    .gt_rxp_in_3(gt_rxp_in[3]),                                            // input wire gt_rxp_in_3
    .gt_rxn_in_0(gt_rxn_in[0]),                                            // input wire gt_rxn_in_0
    .gt_rxn_in_1(gt_rxn_in[1]),                                            // input wire gt_rxn_in_1
    .gt_rxn_in_2(gt_rxn_in[2]),                                            // input wire gt_rxn_in_2
    .gt_rxn_in_3(gt_rxn_in[3]),                                            // input wire gt_rxn_in_3
    .gt_txp_out_0(gt_txp_out[0]),                                          // output wire gt_txp_out_0
    .gt_txp_out_1(gt_txp_out[1]),                                          // output wire gt_txp_out_1
    .gt_txp_out_2(gt_txp_out[2]),                                          // output wire gt_txp_out_2
    .gt_txp_out_3(gt_txp_out[3]),                                          // output wire gt_txp_out_3
    .gt_txn_out_0(gt_txn_out[0]),                                          // output wire gt_txn_out_0
    .gt_txn_out_1(gt_txn_out[1]),                                          // output wire gt_txn_out_1
    .gt_txn_out_2(gt_txn_out[2]),                                          // output wire gt_txn_out_2
    .gt_txn_out_3(gt_txn_out[3]),                                          // output wire gt_txn_out_3

    .tx_clk_out_0 (tx_clk_out_0),
    .rx_core_clk_0 (rx_core_clk_0),
    .rx_clk_out_0 (rx_clk_out_0),
    .rxrecclkout_0 (rxrecclkout_0),

    .gt_loopback_in_0 (gt_loopback_in_0),
    .rx_reset_0 (/*rx_reset_0*/sys_reset_out),
    .user_rx_reset_0 (user_rx_reset_0),
//// RX User Interface Signals
    .rx_axis_tvalid_0 (rx_axis_tvalid),
    .rx_axis_tdata_0 (rx_axis_tdata),
    .rx_axis_tuser_0 (rx_axis_tuser),
    .rx_axis_tkeep_0 (rx_axis_tkeep),
    .rx_axis_tlast_0 (rx_axis_tlast),
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



    .tx_reset_0 (/*tx_reset_0*/sys_reset_out),
    .user_tx_reset_0 (user_tx_reset_0),
//// TX User Interface Signals
    .tx_axis_tready_0 (tx_axis_tready),
    .tx_axis_tvalid_0 (tx_axis_tvalid),
    .tx_axis_tdata_0 (tx_axis_tdata),
    .tx_axis_tuser_0 (tx_axis_tuser),
    .tx_unfout_0 (tx_unfout_0),
    .tx_axis_tkeep_0 (tx_axis_tkeep),
    .tx_axis_tlast_0 (tx_axis_tlast),
    .tx_preamblein_0 (/*tx_preamblein_0*/56'h0),


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




    .gtwiz_reset_tx_datapath_0 (gtwiz_reset_tx_datapath_0),
    .gtwiz_reset_rx_datapath_0 (gtwiz_reset_rx_datapath_0),
    .gtpowergood_out_0 (gtpowergood_out_0),
    .txoutclksel_in_0 (txoutclksel_in_0),
    .rxoutclksel_in_0 (rxoutclksel_in_0),
    .gt_refclk_p(gt_refclk_p),
    .gt_refclk_n(gt_refclk_n),
    .gt_refclk_out(gt_refclk_out),
    .sys_reset (sys_reset_out),
    .dclk (dclk)
);

l_ethernet_0_mac_baser_syncer_reset i_l_ethernet_0_reset(
    .clk         (dclk           ),    
    .reset_async (sys_reset      ),         
    .reset       (sys_reset_out  )  
  );

//TB
assign ctl_rx_test_pattern_0             =1'b0 ;
assign ctl_rx_enable_0                   =1'b1 ;
assign ctl_rx_delete_fcs_0               =1'b1 ;
assign ctl_rx_ignore_fcs_0               =1'b0 ;
assign ctl_rx_max_packet_len_0           =15'd9600 ;
assign ctl_rx_min_packet_len_0           =8'd64 ;
assign ctl_rx_check_sfd_0                =1'b1 ;
assign ctl_rx_check_preamble_0           =1'b1 ;
assign ctl_rx_process_lfi_0              =1'b0 ;
assign ctl_rx_force_resync_0             =1'b0 ;
assign ctl_rx_custom_preamble_enable_0   =1'b0 ;


assign ctl_tx_test_pattern_0           =1'b0 ;
assign ctl_tx_enable_0                 =1'b1 ;
assign ctl_tx_fcs_ins_enable_0         =1'b1 ;
assign ctl_tx_ipg_value_0              =4'd12 ;
assign ctl_tx_send_lfi_0               =1'b0 ;
assign ctl_tx_send_rfi_0               =1'b0 ;
assign ctl_tx_send_idle_0              =1'b0 ;
assign ctl_tx_custom_preamble_enable_0 =1'b0 ;
assign ctl_tx_ignore_fcs_0             =1'b0 ;



endmodule