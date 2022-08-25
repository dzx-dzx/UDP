//------------------------------------------------------------------------------
//  (c) Copyright 2017-2018 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE \"AS IS\" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, \"Critical
//  Applications\"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES.
//------------------------------------------------------------------------------



`timescale 1ns/1ps

module l_ethernet_0_everest_gt_reset_controller_0_inst # (

  parameter integer MASTER_RESET_EN       = 0,
  parameter real    P_FREERUN_FREQUENCY       = 200,
//  parameter integer P_USE_CPLL_CAL            = 0,
  parameter integer P_TX_PLL_TYPE             = 0,
  parameter integer P_RX_PLL_TYPE             = 0,
  parameter real    P_RX_LINE_RATE            = 10.3125

)(



  // User interface ports
  input  wire gtwiz_reset_clk_freerun_in,
  input  wire gtwiz_reset_all_in,
  input  wire gtwiz_reset_tx_pll_and_datapath_in,
  input  wire gtwiz_reset_tx_datapath_in,
  input  wire gtwiz_reset_rx_pll_and_datapath_in,
  input  wire gtwiz_reset_rx_datapath_in,
  output wire gtwiz_reset_rx_cdr_stable_out,
  output wire gtwiz_reset_tx_done_out,
  output wire gtwiz_reset_rx_done_out,
  input  wire gtwiz_reset_userclk_tx_active_in,
  input  wire gtwiz_reset_userclk_rx_active_in,

  // Transceiver interface ports
  input  wire gtpowergood_in,
  input  wire txusrclk2_in,
  input  wire ilo_reset_done,
  input  wire plllock_tx_in,
  input  wire txresetdone_in,
  input  wire rxusrclk2_in,
  input  wire plllock_rx_in,
  input  wire rxcdrlock_in,
  input  wire rxresetdone_in,
  output wire  pllreset_tx_out ,
  output wire txprogdivreset_out,
  output wire iloreset_out ,
  output wire  gttxreset_out      ,
  output wire  txuserrdy_out      ,
  output wire  pllreset_rx_out,
  output wire  rxprogdivreset_out ,
  output wire  gtrxreset_out      ,
  output wire  rxuserrdy_out      ,


  output reg mst_tx_reset = 1'b1,
  output reg mst_rx_reset = 1'b1,
  output reg mst_tx_dp_reset = 1'b0,
  output reg mst_rx_dp_reset = 1'b0,

  input  wire mst_tx_resetdone,
  input  wire mst_rx_resetdone,

  input  wire pcie_enable,
  output wire pcie_rstb_out ,

  // Tie-offs based on core configuration
  input  wire tx_enabled_tie_in,
  input  wire rx_enabled_tie_in,
  input  wire shared_pll_tie_in
  

);


reg pllreset_tx_out_int = 1'b0;
reg  txprogdivreset_out_int = 1'b0;
reg iloreset_out_int_tx = 1'b0;
reg iloreset_out_int_rx = 1'b0;
wire iloreset_out_int = (tx_enabled_tie_in == 1'b1) ? iloreset_out_int_tx :  iloreset_out_int_rx ;
reg gttxreset_out_int      = 1'b0;
reg txuserrdy_out_int      = 1'b0;
reg  pllreset_rx_out_int = 1'b0;
reg rxprogdivreset_out_int = 1'b0;
reg gtrxreset_out_int = 1'b0;
reg rxuserrdy_out_int = 1'b0;


assign   pllreset_tx_out    = (pcie_enable == 1'b1) ? 1'b0 :  pllreset_tx_out_int   ;  
assign   txprogdivreset_out = (pcie_enable == 1'b1) ? 1'b0 :  txprogdivreset_out_int;  
assign   iloreset_out       = (pcie_enable == 1'b1) ? 1'b0 :  iloreset_out_int      ;  
assign   gttxreset_out      = (pcie_enable == 1'b1) ? 1'b0 :  gttxreset_out_int     ; 
//assign   txuserrdy_out      = txuserrdy_out_int     ; 
assign   pllreset_rx_out    = (pcie_enable == 1'b1) ? 1'b0 :  pllreset_rx_out_int   ;  
assign   rxprogdivreset_out = (pcie_enable == 1'b1) ? 1'b0 :  rxprogdivreset_out_int;  
assign   gtrxreset_out      = (pcie_enable == 1'b1) ? 1'b0 :  gtrxreset_out_int     ;   



assign   pcie_rstb_out         = (pcie_enable == 1'b1) ? !pllreset_tx_out_int :  1'b1     ;
// Synchronize the TX user clock active indicator
  wire gtwiz_reset_userclk_tx_active_sync;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_gtwiz_reset_userclk_tx_active_inst (
  .src_rst  (gtwiz_reset_userclk_tx_active_in),
  .dest_rst (gtwiz_reset_userclk_tx_active_sync),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);

 // Synchronize the RX user clock active indicator
  wire gtwiz_reset_userclk_rx_active_sync;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_gtwiz_reset_rx_active_inst (
  .src_rst  (gtwiz_reset_userclk_rx_active_in),
  .dest_rst (gtwiz_reset_userclk_rx_active_sync),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);


generate
 if (MASTER_RESET_EN == 1) begin : use_master_reset

  wire gtwiz_reset_sync_master;
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_master_reset_synchronizer_gtwiz_reset_all_inst (
  .src_arst  (gtwiz_reset_all_in),
  .dest_arst (gtwiz_reset_sync_master),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);

  wire gtwiz_tx_dp_reset_sync_master;
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_master_reset_synchronizer_gtwiz_reset_all_inst_tx_dp (
  .src_arst  (gtwiz_reset_tx_datapath_in),
  .dest_arst (gtwiz_tx_dp_reset_sync_master),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);

  wire gtwiz_tx_reset_sync_master;
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_master_reset_synchronizer_gtwiz_reset_all_inst_tx (
  .src_arst  (gtwiz_reset_tx_pll_and_datapath_in),
  .dest_arst (gtwiz_tx_reset_sync_master),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);

  wire gtwiz_rx_dp_reset_sync_master;
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_master_reset_synchronizer_gtwiz_reset_all_inst_rx_dp (
  .src_arst  (gtwiz_reset_rx_datapath_in),
  .dest_arst (gtwiz_rx_dp_reset_sync_master),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);

  wire gtwiz_rx_reset_sync_master;
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_master_reset_synchronizer_gtwiz_reset_all_inst_rx (
  .src_arst  (gtwiz_reset_rx_pll_and_datapath_in),
  .dest_arst (gtwiz_rx_reset_sync_master),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);

// Synchronize the transceiver power good indicator
  wire gtpowergood_sync_master;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_master_bit_synchronizer_gtpowergood_inst (
  .src_rst  (gtpowergood_in),
  .dest_rst (gtpowergood_sync_master),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);

  reg       sm_reset_all_timer_clr_master_tx = 1'b1;
  reg [2:0] sm_reset_all_timer_ctr_master_tx = 3'd0;
  reg       sm_reset_all_timer_sat_master_tx = 1'b0;
  wire mst_tx_resetdone_sync;
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_master_reset_synchronizer_gtwiz_reset_all_inst_tx_1 (
  .src_arst  (mst_tx_resetdone),
  .dest_arst (mst_tx_resetdone_sync),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);

  wire mst_rx_resetdone_sync;
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_master_reset_synchronizer_gtwiz_reset_all_inst_rx_1 (
  .src_arst  (mst_rx_resetdone),
  .dest_arst (mst_rx_resetdone_sync),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);
  wire mst_resetdone_tx = mst_tx_resetdone_sync;
  assign   txuserrdy_out      = txuserrdy_out_int    && gtwiz_reset_userclk_tx_active_sync     ;
  
  assign gtwiz_reset_tx_done_out = mst_tx_resetdone_sync;

  // Generate a small "reset all" state machine reset timer, used to stall certain states to guarantee that their
  // synchronized input values are being used at the appropriate time
  always @(posedge gtwiz_reset_clk_freerun_in) begin
    if (sm_reset_all_timer_clr_master_tx) begin
      sm_reset_all_timer_ctr_master_tx <= 3'd0;
      sm_reset_all_timer_sat_master_tx <= 1'b0;
    end
    else begin
      if (sm_reset_all_timer_ctr_master_tx != 3'd7)
        sm_reset_all_timer_ctr_master_tx <= sm_reset_all_timer_ctr_master_tx + 3'd1;
      else
        sm_reset_all_timer_sat_master_tx <= 1'b1;
    end
  end

  localparam [2:0] ST_MASTER_RESET_MST_INIT_TX      = 3'd0;
  localparam [2:0] ST_MASTER_RESET_MST_ASSERT_TX    = 3'd1;
  localparam [2:0] ST_MASTER_RESET_WAIT_PMA_TX      = 3'd2;
  localparam [2:0] ST_MASTER_RESET_ASSERT_USRRDY_TX = 3'd3;
  localparam [2:0] ST_MASTER_RESET_RESET_DONE_TX    = 3'd4;
  localparam [2:0] ST_MASTER_RESET_DP_INIT_TX       = 3'd5;
  localparam [2:0] ST_MASTER_RESET_DP_ASSERT_TX     = 3'd6;

  reg        [2:0] sm_reset_all_master_tx            = ST_MASTER_RESET_MST_INIT_TX;

  always @(posedge gtwiz_reset_clk_freerun_in)
  begin
     if (gtwiz_tx_reset_sync_master || gtwiz_reset_sync_master) 
     begin
         sm_reset_all_master_tx  <= ST_MASTER_RESET_MST_INIT_TX;
     end
     else
     begin
        case (sm_reset_all_master_tx)
           ST_MASTER_RESET_MST_INIT_TX :
           begin
              sm_reset_all_timer_clr_master_tx <= 1'b1;
              if (gtpowergood_sync_master)
                sm_reset_all_master_tx <=  ST_MASTER_RESET_MST_ASSERT_TX;
              else
                sm_reset_all_master_tx <= ST_MASTER_RESET_MST_INIT_TX;
           end
           ST_MASTER_RESET_MST_ASSERT_TX :
           begin
              sm_reset_all_timer_clr_master_tx <= 1'b0;
              if (~sm_reset_all_timer_clr_master_tx && sm_reset_all_timer_sat_master_tx )
              begin
                 sm_reset_all_master_tx <= ST_MASTER_RESET_WAIT_PMA_TX;
                 sm_reset_all_timer_clr_master_tx      <= 1'b1;
              end
           end
           ST_MASTER_RESET_WAIT_PMA_TX :
           begin
              sm_reset_all_timer_clr_master_tx <= 1'b1;
              if (~mst_resetdone_tx && gtwiz_reset_userclk_tx_active_sync)
              begin
                 sm_reset_all_master_tx <= ST_MASTER_RESET_ASSERT_USRRDY_TX;
              end
           end
           ST_MASTER_RESET_ASSERT_USRRDY_TX :
           begin
              sm_reset_all_timer_clr_master_tx <= 1'b1;
              if (mst_resetdone_tx)
              begin
                 sm_reset_all_master_tx <= ST_MASTER_RESET_RESET_DONE_TX;
              end
           end
           ST_MASTER_RESET_RESET_DONE_TX :
           begin
              sm_reset_all_timer_clr_master_tx <= 1'b1;
              if (gtwiz_tx_dp_reset_sync_master)
              begin
                 sm_reset_all_master_tx <= ST_MASTER_RESET_DP_INIT_TX;
              end
           end
           ST_MASTER_RESET_DP_INIT_TX :
           begin
              sm_reset_all_timer_clr_master_tx <= 1'b1;
             if (!gtwiz_tx_dp_reset_sync_master)
             begin
                sm_reset_all_master_tx <= ST_MASTER_RESET_DP_ASSERT_TX;
             end
           end
           ST_MASTER_RESET_DP_ASSERT_TX :
           begin
              sm_reset_all_timer_clr_master_tx <= 1'b0;
              if (~sm_reset_all_timer_clr_master_tx && sm_reset_all_timer_sat_master_tx )
              begin
                 sm_reset_all_master_tx <= ST_MASTER_RESET_WAIT_PMA_TX;
                 sm_reset_all_timer_clr_master_tx      <= 1'b1;
              end
           end
           default :
           begin
              sm_reset_all_timer_clr_master_tx <= 1'b0;
              sm_reset_all_master_tx  <= ST_MASTER_RESET_MST_INIT_TX;
           end
        endcase
     end
  end

  always @(*)
  begin
     case (sm_reset_all_master_tx)
        ST_MASTER_RESET_MST_INIT_TX :
        begin
           mst_tx_reset      <= 1'b1;
           mst_tx_dp_reset   <= 1'b0;
           txuserrdy_out_int <= 1'b0;
        end
        ST_MASTER_RESET_MST_ASSERT_TX :
        begin
           mst_tx_reset      <= 1'b1;
           mst_tx_dp_reset   <= 1'b0;
           txuserrdy_out_int <= 1'b0;
        end
        ST_MASTER_RESET_WAIT_PMA_TX :
        begin
           mst_tx_reset      <= 1'b0;
           mst_tx_dp_reset   <= 1'b0;
           txuserrdy_out_int <= 1'b0;
        end
        ST_MASTER_RESET_ASSERT_USRRDY_TX :
        begin
           mst_tx_reset      <= 1'b0;
           mst_tx_dp_reset   <= 1'b0;
           txuserrdy_out_int <= 1'b1;
        end
        ST_MASTER_RESET_RESET_DONE_TX :
        begin
           mst_tx_reset      <= 1'b0;
           mst_tx_dp_reset   <= 1'b0;
           txuserrdy_out_int <= 1'b1;
        end
        ST_MASTER_RESET_DP_INIT_TX :
        begin
           mst_tx_reset      <= 1'b0;
           mst_tx_dp_reset   <= 1'b1;
           txuserrdy_out_int <= 1'b0;
        end
        ST_MASTER_RESET_DP_ASSERT_TX :
        begin
           mst_tx_reset      <= 1'b0;
           mst_tx_dp_reset   <= 1'b1;
           txuserrdy_out_int <= 1'b0;
        end
        default:
        begin
           mst_tx_reset      <= 1'b0;
           mst_tx_dp_reset   <= 1'b0;
           txuserrdy_out_int <= 1'b0;
        end
     endcase
  end

  reg       sm_reset_all_timer_clr_master_rx = 1'b1;
  reg [2:0] sm_reset_all_timer_ctr_master_rx = 3'd0;
  reg       sm_reset_all_timer_sat_master_rx = 1'b0;
  wire mst_resetdone_rx = mst_rx_resetdone_sync;
  assign   rxuserrdy_out      = rxuserrdy_out_int    && gtwiz_reset_userclk_rx_active_sync     ;

  assign gtwiz_reset_rx_done_out = mst_rx_resetdone_sync;
  
  // Generate a small "reset all" state machine reset timer, used to stall certain states to guarantee that their
  // synchronized input values are being used at the appropriate time
  always @(posedge gtwiz_reset_clk_freerun_in) begin
    if (sm_reset_all_timer_clr_master_rx) begin
      sm_reset_all_timer_ctr_master_rx <= 3'd0;
      sm_reset_all_timer_sat_master_rx <= 1'b0;
    end
    else begin
      if (sm_reset_all_timer_ctr_master_rx != 3'd7)
        sm_reset_all_timer_ctr_master_rx <= sm_reset_all_timer_ctr_master_rx + 3'd1;
      else
        sm_reset_all_timer_sat_master_rx <= 1'b1;
    end
  end

  localparam [2:0] ST_MASTER_RESET_MST_INIT_RX      = 3'd0;
  localparam [2:0] ST_MASTER_RESET_MST_ASSERT_RX    = 3'd1;
  localparam [2:0] ST_MASTER_RESET_WAIT_PMA_RX      = 3'd2;
  localparam [2:0] ST_MASTER_RESET_ASSERT_USRRDY_RX = 3'd3;
  localparam [2:0] ST_MASTER_RESET_RESET_DONE_RX    = 3'd4;
  localparam [2:0] ST_MASTER_RESET_DP_INIT_RX       = 3'd5;
  localparam [2:0] ST_MASTER_RESET_DP_ASSERT_RX     = 3'd6;

  reg        [2:0] sm_reset_all_master_rx            = ST_MASTER_RESET_MST_INIT_RX;

  always @(posedge gtwiz_reset_clk_freerun_in)
  begin
     if (gtwiz_rx_reset_sync_master || gtwiz_reset_sync_master) 
     begin
         sm_reset_all_master_rx  <= ST_MASTER_RESET_MST_INIT_RX;
     end
     else
     begin
        case (sm_reset_all_master_rx)
           ST_MASTER_RESET_MST_INIT_RX :
           begin
              sm_reset_all_timer_clr_master_rx <= 1'b1;
              if (gtpowergood_sync_master)
                sm_reset_all_master_rx <=  ST_MASTER_RESET_MST_ASSERT_RX;
              else
                sm_reset_all_master_rx <= ST_MASTER_RESET_MST_INIT_RX;
           end
           ST_MASTER_RESET_MST_ASSERT_RX :
           begin
              sm_reset_all_timer_clr_master_rx <= 1'b0;
              if (~sm_reset_all_timer_clr_master_rx && sm_reset_all_timer_sat_master_rx )
              begin
                 sm_reset_all_master_rx <= ST_MASTER_RESET_WAIT_PMA_RX;
                 sm_reset_all_timer_clr_master_rx      <= 1'b1;
              end
           end
           ST_MASTER_RESET_WAIT_PMA_RX :
           begin
              sm_reset_all_timer_clr_master_rx <= 1'b1;
              if (~mst_resetdone_rx && gtwiz_reset_userclk_rx_active_sync)
              begin
                 sm_reset_all_master_rx <= ST_MASTER_RESET_ASSERT_USRRDY_RX;
              end
           end
           ST_MASTER_RESET_ASSERT_USRRDY_RX :
           begin
              sm_reset_all_timer_clr_master_rx <= 1'b1;
              if (mst_resetdone_rx)
              begin
                 sm_reset_all_master_rx <= ST_MASTER_RESET_RESET_DONE_RX;
              end
           end
           ST_MASTER_RESET_RESET_DONE_RX :
           begin
              sm_reset_all_timer_clr_master_rx <= 1'b1;
              if (gtwiz_rx_dp_reset_sync_master)
              begin
                 sm_reset_all_master_rx <= ST_MASTER_RESET_DP_INIT_RX;
              end
           end
           ST_MASTER_RESET_DP_INIT_RX :
           begin
              sm_reset_all_timer_clr_master_rx <= 1'b1;
             if (!gtwiz_rx_dp_reset_sync_master)
             begin
                sm_reset_all_master_rx <= ST_MASTER_RESET_DP_ASSERT_RX;
             end
           end
           ST_MASTER_RESET_DP_ASSERT_RX :
           begin
              sm_reset_all_timer_clr_master_rx <= 1'b0;
              if (~sm_reset_all_timer_clr_master_rx && sm_reset_all_timer_sat_master_rx )
              begin
                 sm_reset_all_master_rx <= ST_MASTER_RESET_WAIT_PMA_RX;
                 sm_reset_all_timer_clr_master_rx      <= 1'b1;
              end
           end
           default :
           begin
              sm_reset_all_timer_clr_master_rx <= 1'b1;
              sm_reset_all_master_rx  <= ST_MASTER_RESET_MST_INIT_RX;
           end
        endcase
     end
  end

  always @(*)
  begin
     case (sm_reset_all_master_rx)
        ST_MASTER_RESET_MST_INIT_RX :
        begin
           mst_rx_reset      <= 1'b1;
           mst_rx_dp_reset   <= 1'b0;
           rxuserrdy_out_int <= 1'b0;
        end
        ST_MASTER_RESET_MST_ASSERT_RX :
        begin
           mst_rx_reset      <= 1'b1;
           mst_rx_dp_reset   <= 1'b0;
           rxuserrdy_out_int <= 1'b0;
        end
        ST_MASTER_RESET_WAIT_PMA_RX :
        begin
           mst_rx_reset      <= 1'b0;
           mst_rx_dp_reset   <= 1'b0;
           rxuserrdy_out_int <= 1'b0;
        end
        ST_MASTER_RESET_ASSERT_USRRDY_RX :
        begin
           mst_rx_reset      <= 1'b0;
           mst_rx_dp_reset   <= 1'b0;
           rxuserrdy_out_int <= 1'b1;
        end
        ST_MASTER_RESET_RESET_DONE_RX :
        begin
           mst_rx_reset      <= 1'b0;
           mst_rx_dp_reset   <= 1'b0;
           rxuserrdy_out_int <= 1'b1;
        end
        ST_MASTER_RESET_DP_INIT_RX :
        begin
           mst_rx_reset      <= 1'b0;
           mst_rx_dp_reset   <= 1'b1;
           rxuserrdy_out_int <= 1'b0;
        end
        ST_MASTER_RESET_DP_ASSERT_RX :
        begin
           mst_rx_reset      <= 1'b0;
           mst_rx_dp_reset   <= 1'b1;
           rxuserrdy_out_int <= 1'b0;
        end
        default: 
        begin
           mst_rx_reset      <= 1'b0;
           mst_rx_dp_reset   <= 1'b0;
           rxuserrdy_out_int <= 1'b0;
        end
     endcase
  end

 end
endgenerate

generate 
 if (MASTER_RESET_EN == 0) begin : use_fsm

localparam [0:0] P_USE_CPLL_CAL = 1'd0;

  // -------------------------------------------------------------------------------------------------------------------
  // "Reset all" state machine
  // -------------------------------------------------------------------------------------------------------------------

  // The "reset all" state machine responds to the synchronized gtwiz_reset_all_in input by resetting the enabled PLLs
  // and data paths of those transceiver resources to which the reset helper block is connected. It does so by guiding
  // the independent transmitter and receiver reset state machines, which are also user-accessible. The path through the
  // "reset all" state machine is a function of module input tie-offs, which depend on the core configuration.

  // Synchronize the "reset all" input signal into the free-running clock domain
  wire gtwiz_reset_all_sync;

always @(posedge gtwiz_reset_clk_freerun_in)
begin
   mst_tx_reset <= 1'b0;
   mst_rx_reset <= 1'b0;
   mst_tx_dp_reset = 1'b0;
   mst_rx_dp_reset = 1'b0;
end

xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_reset_synchronizer_gtwiz_reset_all_inst (
  .src_arst  (gtwiz_reset_all_in),
  .dest_arst (gtwiz_reset_all_sync),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);


  // Synchronize the transceiver power good indicator
  wire gtpowergood_sync;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_gtpowergood_inst (
  .src_rst  (gtpowergood_in),
  .dest_rst (gtpowergood_sync),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);


  wire rxresetdone_in_sync;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_rxresetdone_inst (
  .src_rst  (rxresetdone_in),
  .dest_rst (rxresetdone_in_sync),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);

  wire txresetdone_in_sync;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_txresetdone_inst (
  .src_rst  (txresetdone_in),
  .dest_rst (txresetdone_in_sync),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);



  assign   rxuserrdy_out      = rxuserrdy_out_int    && gtwiz_reset_userclk_rx_active_sync      ;
  assign   txuserrdy_out      = txuserrdy_out_int    && gtwiz_reset_userclk_tx_active_sync   ; 

  // Declare the "reset all" state machine reset timer registers
  reg       sm_reset_all_timer_clr = 1'b1;
  reg [2:0] sm_reset_all_timer_ctr = 3'd0;
  reg       sm_reset_all_timer_sat = 1'b0;

  // Declare local parameters used to represent both static and variable state machine state values
  localparam [2:0] ST_RESET_ALL_INIT        = 3'd0;
  localparam [2:0] ST_RESET_ALL_BRANCH      = 3'd1;
  localparam [2:0] ST_RESET_ALL_TX_PLL      = 3'd2;
  localparam [2:0] ST_RESET_ALL_TX_PLL_WAIT = 3'd3;
  localparam [2:0] ST_RESET_ALL_RX_DP       = 3'd4;
  localparam [2:0] ST_RESET_ALL_RX_PLL      = 3'd5;
  localparam [2:0] ST_RESET_ALL_RX_WAIT     = 3'd6;
  localparam [2:0] ST_RESET_ALL_DONE        = 3'd7;
  reg        [2:0] sm_reset_all             = ST_RESET_ALL_INIT;

  // Declare relevant internal control and status registers of this and other state machines
  reg gtwiz_reset_tx_pll_and_datapath_int = 1'b0;
  reg gtwiz_reset_tx_done_int             = 1'b0;
  reg gtwiz_reset_rx_pll_and_datapath_int = 1'b0;
  reg gtwiz_reset_rx_datapath_int         = 1'b0;
  reg gtwiz_reset_rx_done_int             = 1'b0;

  // Implement the "reset all" state machine control and its outputs as a single sequential process. The state machine
  // is reset by the synchronized gtwiz_reset_all_sync input.
  always @(posedge gtwiz_reset_clk_freerun_in) begin
    if (gtwiz_reset_all_sync) begin
      gtwiz_reset_tx_pll_and_datapath_int <= 1'b0;
      gtwiz_reset_rx_pll_and_datapath_int <= 1'b0;
      gtwiz_reset_rx_datapath_int         <= 1'b0;
      sm_reset_all_timer_clr              <= 1'b1;
      sm_reset_all                        <= ST_RESET_ALL_INIT;
    end
    else begin
      case (sm_reset_all)

        // Upon initial configuration, check or wait for the transceiver power good indicator to be asserted before
        // proceeding with the sequence automatically
        ST_RESET_ALL_INIT: begin
          if (gtpowergood_sync)
            sm_reset_all <= ST_RESET_ALL_BRANCH;
        end

        // If the transmitter is enabled, begin by resetting the TX PLL. If the transmitter is disabled, begin by
        // resetting the RX PLL.
        ST_RESET_ALL_BRANCH: begin
          if (tx_enabled_tie_in)
            sm_reset_all <= ST_RESET_ALL_TX_PLL;
          else
            sm_reset_all <= ST_RESET_ALL_RX_PLL;
          sm_reset_all_timer_clr <= 1'b1;
        end

        // Force the transmitter reset state machine to reset the TX PLL and data path
        ST_RESET_ALL_TX_PLL: begin
          gtwiz_reset_tx_pll_and_datapath_int <= 1'b1;
          sm_reset_all                        <= ST_RESET_ALL_TX_PLL_WAIT;
        end

        // Await completion of the TX PLL and data path reset sequence. Then, if the receiver is enabled, continue by
        // either resetting just the RX data path (if the receiver and transmitter share a PLL) or the RX PLL (if the
        // receiver and transmitter PLLs are indepdendent). If the receiver is disabled, complete the sequence.
        ST_RESET_ALL_TX_PLL_WAIT: begin
          gtwiz_reset_tx_pll_and_datapath_int <= 1'b0;
          sm_reset_all_timer_clr              <= 1'b0;
          if (gtwiz_reset_tx_done_int && (~sm_reset_all_timer_clr) && sm_reset_all_timer_sat) begin
            if (rx_enabled_tie_in) begin
              if (shared_pll_tie_in)
                sm_reset_all <= ST_RESET_ALL_RX_DP;
              else
                sm_reset_all <= ST_RESET_ALL_RX_PLL;
            end
            else
              sm_reset_all <= ST_RESET_ALL_DONE;
            sm_reset_all_timer_clr <= 1'b1;
          end
        end

        // Force the receiver reset state machine to reset the RX data path
        ST_RESET_ALL_RX_DP: begin
          gtwiz_reset_rx_datapath_int <= 1'b1;
          sm_reset_all                <= ST_RESET_ALL_RX_WAIT;
        end

        // Force the receiver reset state machine to reset the RX PLL and data path
        ST_RESET_ALL_RX_PLL: begin
          gtwiz_reset_rx_pll_and_datapath_int <= 1'b1;
          sm_reset_all                        <= ST_RESET_ALL_RX_WAIT;
        end

        // Await completion of whichever RX reset sequence was performed
        ST_RESET_ALL_RX_WAIT: begin
          gtwiz_reset_rx_datapath_int         <= 1'b0;
          sm_reset_all_timer_clr              <= 1'b0;
          gtwiz_reset_rx_pll_and_datapath_int <= 1'b0;
          if (gtwiz_reset_rx_done_int && (~sm_reset_all_timer_clr) && sm_reset_all_timer_sat) begin
            sm_reset_all           <= ST_RESET_ALL_DONE;
            sm_reset_all_timer_clr <= 1'b1;
          end
        end

      endcase
    end
  end

  // Generate a small "reset all" state machine reset timer, used to stall certain states to guarantee that their
  // synchronized input values are being used at the appropriate time
  always @(posedge gtwiz_reset_clk_freerun_in) begin
    if (sm_reset_all_timer_clr) begin
      sm_reset_all_timer_ctr <= 3'd0;
      sm_reset_all_timer_sat <= 1'b0;
    end
    else begin
      if (sm_reset_all_timer_ctr != 3'd7)
        sm_reset_all_timer_ctr <= sm_reset_all_timer_ctr + 3'd1;
      else
        sm_reset_all_timer_sat <= 1'b1;
    end
  end


  // -------------------------------------------------------------------------------------------------------------------
  // Transmitter reset state machine
  // -------------------------------------------------------------------------------------------------------------------

  // The transmitter reset state machine responds to various synchronized inputs by resetting enabled transmitter-
  // related transceiver resources to which the reset helper block is connected. Various entry points to the sequential
  // reset sequence are available.

  // Synchronize the OR of all user input and internal TX reset signals for use in resetting the TX reset state machine
  wire gtwiz_reset_tx_any;
  wire gtwiz_reset_tx_any_sync;
  assign gtwiz_reset_tx_any = gtwiz_reset_tx_pll_and_datapath_in  ||
                              gtwiz_reset_tx_pll_and_datapath_int ||
                              gtwiz_reset_tx_datapath_in;

xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_reset_synchronizer_gtwiz_reset_tx_any_inst (
  .src_arst  (gtwiz_reset_tx_any),
  .dest_arst (gtwiz_reset_tx_any_sync),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);



  // Synchronize the OR of the user input and internal TX PLL and data path reset signals
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_reset_synchronizer_gtwiz_reset_tx_pll_and_datapath_inst (
  .src_arst  (gtwiz_reset_tx_pll_and_datapath_in || gtwiz_reset_tx_pll_and_datapath_int),
  .dest_arst (gtwiz_reset_tx_pll_and_datapath_sync),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);


  // Use another synchronizer to delay the above signal for purposes of its detection following reset
  wire gtwiz_reset_tx_pll_and_datapath_dly;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_gtwiz_reset_tx_pll_and_datapath_dly_inst (
  .src_rst  (gtwiz_reset_tx_pll_and_datapath_sync),
  .dest_rst (gtwiz_reset_tx_pll_and_datapath_dly),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);


  // Synchronize the TX data path reset user input
  wire gtwiz_reset_tx_datapath_sync;
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_reset_synchronizer_gtwiz_reset_tx_datapath_inst (
  .src_arst  (gtwiz_reset_tx_datapath_in),
  .dest_arst (gtwiz_reset_tx_datapath_sync),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);

  // Use another synchronizer to delay the above signal for purposes of its detection following reset
  wire gtwiz_reset_tx_datapath_dly;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_gtwiz_reset_tx_datapath_dly_inst (
  .src_rst  (gtwiz_reset_tx_datapath_sync),
  .dest_rst (gtwiz_reset_tx_datapath_dly),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);

  

  // Synchronize the TX PLL lock indicator
  wire plllock_tx_sync;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_plllock_tx_inst (
  .src_rst  (plllock_tx_in),
  .dest_rst (plllock_tx_sync),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);



  wire ilo_reset_done_sync;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_ilo_reset_inst (
  .src_rst  (ilo_reset_done),
  .dest_rst (ilo_reset_done_sync),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);


  // Declare the TX state machine reset timer registers
  reg       sm_reset_tx_timer_clr = 1'b1;
  reg [2:0] sm_reset_tx_timer_ctr = 3'd0;
  reg       sm_reset_tx_timer_sat = 1'b0;

  // Declare the TX state machine PLL reset timer registers
  localparam [9:0] P_TX_PLL_RESET_FREERUN_CYC = (P_TX_PLL_TYPE == 2 && P_USE_CPLL_CAL == 0) ?
                                                (2 * P_FREERUN_FREQUENCY) + 2 : 7;
  reg        sm_reset_tx_pll_timer_clr = 1'b1;
  reg  [9:0] sm_reset_tx_pll_timer_ctr = 10'd0;
  reg        sm_reset_tx_pll_timer_sat = 1'b0;
  wire [9:0] p_tx_pll_reset_freerun_cyc_int = P_TX_PLL_RESET_FREERUN_CYC;

  // Declare local parameters for TX reset state machine state values
  localparam [3:0] ST_RESET_TX_BRANCH         = 4'd0;
  localparam [3:0] ST_RESET_TX_PLL            = 4'd1;
  localparam [3:0] ST_RESET_TX_DATAPATH       = 4'd2;
  localparam [3:0] ST_RESET_TX_WAIT_LOCK      = 4'd3;
  localparam [3:0] ST_RESET_TX_ILO_RESET         = 4'd4;
  localparam [3:0] ST_RESET_TX_ILO_RESETDONE_WAIT     = 4'd5;
  localparam [3:0] ST_RESET_TX_WAIT_USERRDY   = 4'd6;
  localparam [3:0] ST_RESET_TX_WAIT_RESETDONE = 4'd7;
  localparam [3:0] ST_RESET_TX_IDLE           = 4'd8;
  reg        [3:0] sm_reset_tx                = ST_RESET_TX_BRANCH;

  // Implementation of transmitter reset state machine synchronous process
  always @(posedge gtwiz_reset_clk_freerun_in) begin

    // The state machine is synchronously reset by the synchronized OR of all user input and internal TX reset signals
    if (gtwiz_reset_tx_any_sync) begin
      gtwiz_reset_tx_done_int   <= 1'b0;
      sm_reset_tx_timer_clr     <= 1'b1;
      sm_reset_tx_pll_timer_clr <= 1'b1;
      sm_reset_tx               <= ST_RESET_TX_BRANCH;
    end
    else begin
      case (sm_reset_tx)

        // Once released from reset, branch to the reset control state indicated by the highest-priority synchronized
        // signal (which remains asserted due to its long synchronizer chain)
        ST_RESET_TX_BRANCH: begin
          if (gtwiz_reset_tx_pll_and_datapath_dly)
            sm_reset_tx <= ST_RESET_TX_PLL;
          else if (gtwiz_reset_tx_datapath_dly)
            sm_reset_tx <= ST_RESET_TX_DATAPATH;
          sm_reset_tx_timer_clr     <= 1'b1;
          sm_reset_tx_pll_timer_clr <= 1'b1;
        end

        // Assert the TX PLL and TX data path reset outputs
        ST_RESET_TX_PLL: begin
          pllreset_tx_out_int           <= 1'b1;
          gttxreset_out_int             <= 1'b1;
          txprogdivreset_out_int        <= 1'b1;
          txuserrdy_out_int             <= 1'b0;
          sm_reset_tx_pll_timer_clr <= 1'b0;
          if ((~sm_reset_tx_pll_timer_clr) && sm_reset_tx_pll_timer_sat) begin
            sm_reset_tx_pll_timer_clr <= 1'b1;
            sm_reset_tx               <= ST_RESET_TX_WAIT_LOCK;
          end
        end

        // Assert the TX data path reset output
        ST_RESET_TX_DATAPATH: begin
          gttxreset_out_int         <= 1'b1;
          txprogdivreset_out_int        <= 1'b1;
          txuserrdy_out_int         <= 1'b0;
          sm_reset_tx_timer_clr <= 1'b0;
          if ((~sm_reset_tx_timer_clr) && sm_reset_tx_timer_sat) begin
            sm_reset_tx_timer_clr <= 1'b1;
            sm_reset_tx           <= ST_RESET_TX_WAIT_LOCK;
          end
        end

        // De-assert the TX PLL reset output, and await the TX PLL lock indicator before de-asserting the TX data path
        // reset output
        ST_RESET_TX_WAIT_LOCK: begin
          pllreset_tx_out_int       <= 1'b0;
          sm_reset_tx_timer_clr <= 1'b0;
          if (plllock_tx_sync && (~sm_reset_tx_timer_clr) && sm_reset_tx_timer_sat) begin
            gttxreset_out_int         <= 1'b0;
            txprogdivreset_out_int        <= 1'b0;
            sm_reset_tx_timer_clr <= 1'b1;
            sm_reset_tx           <= ST_RESET_TX_ILO_RESET;
          end
        end

        ST_RESET_TX_ILO_RESET: begin
          iloreset_out_int_tx       <= 1'b1;
          sm_reset_tx_timer_clr <= 1'b0;
          if ((~sm_reset_tx_timer_clr) && sm_reset_tx_timer_sat) begin
            gttxreset_out_int         <= 1'b0;
            sm_reset_tx_timer_clr <= 1'b1;
            sm_reset_tx           <= ST_RESET_TX_ILO_RESETDONE_WAIT;
          end
        end

        ST_RESET_TX_ILO_RESETDONE_WAIT: begin
          iloreset_out_int_tx       <= 1'b0;
          sm_reset_tx_timer_clr <= 1'b0;
          if (ilo_reset_done_sync && (~sm_reset_tx_timer_clr) && sm_reset_tx_timer_sat) begin
            gttxreset_out_int         <= 1'b0;
            sm_reset_tx_timer_clr <= 1'b1;
            sm_reset_tx           <= ST_RESET_TX_WAIT_USERRDY;
          end
        end



        // Await the TX user clock active indicator from the TX user clocking helper block before asserting the TX user
        // ready output
        ST_RESET_TX_WAIT_USERRDY: begin
          sm_reset_tx_timer_clr <= 1'b0;
          if (gtwiz_reset_userclk_tx_active_sync && (~sm_reset_tx_timer_clr) && sm_reset_tx_timer_sat) begin
            txuserrdy_out_int         <= 1'b1;
            sm_reset_tx_timer_clr <= 1'b1;
            sm_reset_tx           <= ST_RESET_TX_WAIT_RESETDONE;
          end
        end

        // Await the TX reset done indicator before asserting the reset helper block TX reset done user output
        ST_RESET_TX_WAIT_RESETDONE: begin
          sm_reset_tx_timer_clr <= 1'b0;
          if (txresetdone_in_sync && (~sm_reset_tx_timer_clr) && sm_reset_tx_timer_sat) begin
            gtwiz_reset_tx_done_int <= 1'b1;
            sm_reset_tx_timer_clr   <= 1'b1;
            sm_reset_tx             <= ST_RESET_TX_IDLE;
          end
        end

        // While idle, de-assert the reset helper block TX reset done user output if PLL lock is lost, signaling the
        // need for user intervention
        ST_RESET_TX_IDLE: begin
          if (!plllock_tx_sync)
            gtwiz_reset_tx_done_int <= 1'b0;
        end

        // Encountering the default case indicates a state register error, so de-assert the reset helper block TX
        // reset done user output, signaling the need for user intervention
        default: begin
          gtwiz_reset_tx_done_int <= 1'b0;
        end

      endcase
    end
  end

  // Generate a small TX state machine reset timer, used to stall certain states to guarantee that their synchronized
  // input values are being used at the appropriate time
  always @(posedge gtwiz_reset_clk_freerun_in) begin
    if (sm_reset_tx_timer_clr) begin
      sm_reset_tx_timer_ctr <= 3'd0;
      sm_reset_tx_timer_sat <= 1'b0;
    end
    else begin
      if (sm_reset_tx_timer_ctr != 3'd7)
        sm_reset_tx_timer_ctr <= sm_reset_tx_timer_ctr + 3'd1;
      else
        sm_reset_tx_timer_sat <= 1'b1;
    end
  end

  // Generate an TX PLL reset timer, used to indicate when the specified minimum TX PLL reset duration has expired. This
  // is used by the TX state machine to proceed beyond the ST_RESET_TX_PLL wait state.
  always @(posedge gtwiz_reset_clk_freerun_in) begin
    if (sm_reset_tx_pll_timer_clr) begin
      sm_reset_tx_pll_timer_ctr <= 10'd0;
      sm_reset_tx_pll_timer_sat <= 1'b0;
    end
    else begin
      if (sm_reset_tx_pll_timer_ctr != p_tx_pll_reset_freerun_cyc_int)
        sm_reset_tx_pll_timer_ctr <= sm_reset_tx_pll_timer_ctr + 10'd1;
      else
        sm_reset_tx_pll_timer_sat <= 1'b1;
    end
  end

  // Hold the TX programmable divider in reset until the TX PLL has locked
//xpm_cdc_async_rst # (
// .DEST_SYNC_FF (3),
// .RST_ACTIVE_HIGH (1)
//
//) l_ethernet_0_everest_gt_reset_controller_0_reset_synchronizer_txprogdivreset_inst (
//  .src_arst  (~plllock_tx_in),
//  .dest_arst (txprogdivreset_out_int),
//  .dest_clk  (gtwiz_reset_clk_freerun_in)
//);



  // Synchronize the reset helper block TX reset done user output into the TXUSRCLK2 domain for user consumption
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_reset_synchronizer_tx_done_inst (
  .src_arst  (gtwiz_reset_tx_done_int),
  .dest_arst (gtwiz_reset_tx_done_out),
  .dest_clk  (txusrclk2_in)
);



  // -------------------------------------------------------------------------------------------------------------------
  // Receiver reset state machine
  // -------------------------------------------------------------------------------------------------------------------

  // The receiver reset state machine responds to various synchronized inputs by resetting enabled receiver-
  // related transceiver resources to which the reset helper block is connected. Various entry points to the sequential
  // reset sequence are available.

  // Initialize (for both synthesis and simulation) the RX PLL reset output flip-flop to 0 if the TX and RX PLLs are
  // shared upon device configuration, so as to not block TX PLL reset; or to 1 if the PLLs are independent, for
  // consistency with TX PLL initialization
  initial begin
    if (P_TX_PLL_TYPE == P_RX_PLL_TYPE)
      pllreset_rx_out_int = 1'b0;
    else
      pllreset_rx_out_int = 1'b0;
  end

  // Synchronize the OR of all user input and internal RX reset signals for use in resetting the RX reset state machine
  wire gtwiz_reset_rx_any;
  wire gtwiz_reset_rx_any_sync;
  assign gtwiz_reset_rx_any = gtwiz_reset_rx_pll_and_datapath_in  ||
                              gtwiz_reset_rx_pll_and_datapath_int ||
                              gtwiz_reset_rx_datapath_in          ||
                              gtwiz_reset_rx_datapath_int;
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_reset_synchronizer_gtwiz_reset_rx_any_inst (
  .src_arst  (gtwiz_reset_rx_any),
  .dest_arst (gtwiz_reset_rx_any_sync),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);



  // Synchronize the OR of the user input and internal RX PLL and data path reset signals
  wire gtwiz_reset_rx_pll_and_datapath_sync;
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_reset_synchronizer_gtwiz_reset_rx_pll_and_datapath_inst (
  .src_arst  (gtwiz_reset_rx_pll_and_datapath_in || gtwiz_reset_rx_pll_and_datapath_int),
  .dest_arst (gtwiz_reset_rx_pll_and_datapath_sync),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);


  // Use another synchronizer to delay the above signal for purposes of its detection following reset
  wire gtwiz_reset_rx_pll_and_datapath_dly;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_gtwiz_reset_rx_pll_and_datapath_dly_inst (
  .src_rst  (gtwiz_reset_rx_pll_and_datapath_sync),
  .dest_rst (gtwiz_reset_rx_pll_and_datapath_dly),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);


  // Synchronize the RX data path reset user input
  wire gtwiz_reset_rx_datapath_sync;
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_reset_synchronizer_gtwiz_reset_rx_datapath_inst (
  .src_arst  (gtwiz_reset_rx_datapath_in || gtwiz_reset_rx_datapath_int),
  .dest_arst (gtwiz_reset_rx_datapath_sync),
  .dest_clk  (gtwiz_reset_clk_freerun_in)
);


  // Use another synchronizer to delay the above signal for purposes of its detection following reset
  wire gtwiz_reset_rx_datapath_dly;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_gtwiz_reset_rx_datapath_dly_inst (
  .src_rst  (gtwiz_reset_rx_datapath_sync),
  .dest_rst (gtwiz_reset_rx_datapath_dly),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);



  // Synchronize the RX PLL lock indicator
  wire plllock_rx_sync;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_plllock_rx_inst (
  .src_rst  (plllock_rx_in),
  .dest_rst (plllock_rx_sync),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);



  // Synchronize the RX CDR lock indicator
  wire rxcdrlock_sync;
xpm_cdc_sync_rst # (
 .DEST_SYNC_FF (3),
 .INIT          (0)

) l_ethernet_0_everest_gt_reset_controller_0_bit_synchronizer_rxcdrlock_inst (
  .src_rst  (rxcdrlock_in),
  .dest_rst (rxcdrlock_sync),
  .dest_clk (gtwiz_reset_clk_freerun_in)
);


  // Declare the RX state machine reset timer registers
  reg       sm_reset_rx_timer_clr = 1'b1;
  reg [2:0] sm_reset_rx_timer_ctr = 3'd0;
  reg       sm_reset_rx_timer_sat = 1'b0;

  // Declare the RX state machine PLL reset timer registers
  localparam [25:0]  P_CDR_TIMEOUT_FREERUN_CYC = (37000 * P_FREERUN_FREQUENCY) / P_RX_LINE_RATE;
  localparam [9:0] P_RX_PLL_RESET_FREERUN_CYC = (P_RX_PLL_TYPE == 2 && P_USE_CPLL_CAL == 0) ?
                                                (2 * P_FREERUN_FREQUENCY) + 2 : 7;
  reg        sm_reset_rx_pll_timer_clr = 1'b1;
  reg  [9:0] sm_reset_rx_pll_timer_ctr = 10'd0;
  reg        sm_reset_rx_pll_timer_sat = 1'b0;
  wire [9:0] p_rx_pll_reset_freerun_cyc_int = P_RX_PLL_RESET_FREERUN_CYC;

  // Declare the RX state machine CDR lock timeout counter
  reg         sm_reset_rx_cdr_to_clr = 1'b1;
  reg  [25:0] sm_reset_rx_cdr_to_ctr = 26'd0;
  reg         sm_reset_rx_cdr_to_sat = 1'b0;
  wire [25:0] p_cdr_timeout_freerun_cyc_int = P_CDR_TIMEOUT_FREERUN_CYC;

  // Declare local parameters for RX reset state machine state values
  localparam [3:0] ST_RESET_RX_BRANCH         = 4'd0;
  localparam [3:0] ST_RESET_RX_PLL            = 4'd1;
  localparam [3:0] ST_RESET_RX_DATAPATH       = 4'd2;
  localparam [3:0] ST_RESET_RX_WAIT_LOCK      = 4'd3;
  localparam [3:0] ST_RESET_RX_ILO_RESET         = 4'd4;
  localparam [3:0] ST_RESET_RX_ILO_RESETDONE_WAIT     = 4'd5;
  localparam [3:0] ST_RESET_RX_WAIT_CDR       = 4'd6;
  localparam [3:0] ST_RESET_RX_WAIT_USERRDY   = 4'd7;
  localparam [3:0] ST_RESET_RX_WAIT_RESETDONE = 4'd8;
  localparam [3:0] ST_RESET_RX_IDLE           = 4'd9;
  reg        [3:0] sm_reset_rx                = ST_RESET_RX_BRANCH;

  // Implementation of receiver reset state machine synchronous process
  always @(posedge gtwiz_reset_clk_freerun_in) begin

    // The state machine is synchronously reset by the synchronized OR of all user input and internal RX reset signals
    if (gtwiz_reset_rx_any_sync) begin
      gtwiz_reset_rx_done_int   <= 1'b0;
      sm_reset_rx_timer_clr     <= 1'b1;
      sm_reset_rx_pll_timer_clr <= 1'b1;
      sm_reset_rx_cdr_to_clr    <= 1'b1;
      sm_reset_rx               <= ST_RESET_RX_BRANCH;
    end
    else begin
      case (sm_reset_rx)

        // Once released from reset, branch to the reset control state indicated by the highest-priority synchronized
        // signal (which remains asserted due to its long synchronizer chain)
        ST_RESET_RX_BRANCH: begin
          if (gtwiz_reset_rx_pll_and_datapath_dly)
            sm_reset_rx <= ST_RESET_RX_PLL;
          else if (gtwiz_reset_rx_datapath_dly)
            sm_reset_rx <= ST_RESET_RX_DATAPATH;
          sm_reset_rx_timer_clr     <= 1'b1;
          sm_reset_rx_pll_timer_clr <= 1'b1;
          sm_reset_rx_cdr_to_clr    <= 1'b1;
        end

        // Assert the RX PLL, RX programmable divider, and RX data path reset outputs
        ST_RESET_RX_PLL: begin
          pllreset_rx_out_int           <= 1'b1;
          rxprogdivreset_out_int        <= 1'b1;
          gtrxreset_out_int             <= 1'b1;
          rxuserrdy_out_int             <= 1'b0;
          sm_reset_rx_pll_timer_clr <= 1'b0;
          if ((~sm_reset_rx_pll_timer_clr) && sm_reset_rx_pll_timer_sat) begin
            sm_reset_rx_pll_timer_clr <= 1'b1;
            sm_reset_rx               <= ST_RESET_RX_WAIT_LOCK;
          end
        end

        // Assert the RX data path and RX programmable divider reset outputs
        ST_RESET_RX_DATAPATH: begin
          rxprogdivreset_out_int    <= 1'b1;
          gtrxreset_out_int         <= 1'b1;
          rxuserrdy_out_int         <= 1'b0;
          sm_reset_rx_timer_clr <= 1'b0;
          if ((~sm_reset_rx_timer_clr) && sm_reset_rx_timer_sat) begin
            sm_reset_rx_timer_clr <= 1'b1;
            sm_reset_rx           <= ST_RESET_RX_WAIT_LOCK;
          end
        end

        // De-assert the RX PLL reset output, and await the RX PLL lock indicator before de-asserting the RX data path
        // reset output
        ST_RESET_RX_WAIT_LOCK: begin
          pllreset_rx_out_int       <= 1'b0;
          sm_reset_rx_timer_clr <= 1'b0;
          if (plllock_rx_sync && (~sm_reset_rx_timer_clr) && sm_reset_rx_timer_sat) begin
            gtrxreset_out_int          <= 1'b0;
            sm_reset_rx_timer_clr  <= 1'b1;
            sm_reset_rx_cdr_to_clr <= 1'b0;
            if (tx_enabled_tie_in) begin
              sm_reset_rx            <= ST_RESET_RX_WAIT_CDR;
            end else begin
              sm_reset_rx            <= ST_RESET_RX_ILO_RESET;
            end
          end
        end

      ST_RESET_RX_ILO_RESET: begin
          iloreset_out_int_rx       <= 1'b1;
          sm_reset_rx_timer_clr <= 1'b0;
          if ((~sm_reset_rx_timer_clr) && sm_reset_rx_timer_sat) begin
            sm_reset_rx_timer_clr <= 1'b1;
            sm_reset_rx           <= ST_RESET_RX_ILO_RESETDONE_WAIT;
          end
        end

        ST_RESET_RX_ILO_RESETDONE_WAIT: begin
          iloreset_out_int_rx       <= 1'b0;
          sm_reset_rx_timer_clr <= 1'b0;
          if (ilo_reset_done_sync && (~sm_reset_rx_timer_clr) && sm_reset_rx_timer_sat) begin
            sm_reset_rx_timer_clr <= 1'b1;
            sm_reset_rx            <= ST_RESET_RX_WAIT_CDR;
          end
        end


        // Await an indication of CDR stability (either the direct transceiver RXCDRLOCK output, or expiration of the
        // specified maximum CDR locking time, whichever occurs first) before removing the RX programmable divider reset
        // and proceeding
        ST_RESET_RX_WAIT_CDR: begin
          if (rxcdrlock_sync || sm_reset_rx_cdr_to_sat) begin
            rxprogdivreset_out_int     <= 1'b0;
            sm_reset_rx_cdr_to_clr <= 1'b1;
            sm_reset_rx            <= ST_RESET_RX_WAIT_USERRDY;
          end
        end

        // Await the RX user clock active indicator from the RX user clocking helper block before asserting the RX user
        // ready output
        ST_RESET_RX_WAIT_USERRDY: begin
          sm_reset_rx_timer_clr <= 1'b0;
          if (gtwiz_reset_userclk_rx_active_sync && (~sm_reset_rx_timer_clr) && sm_reset_rx_timer_sat) begin
            rxuserrdy_out_int         <= 1'b1;
            sm_reset_rx_timer_clr <= 1'b1;
            sm_reset_rx           <= ST_RESET_RX_WAIT_RESETDONE;
          end
        end

        // Await the RX reset done indicator before asserting the reset helper block RX reset done user output
        ST_RESET_RX_WAIT_RESETDONE: begin
          sm_reset_rx_timer_clr <= 1'b0;
          if (rxresetdone_in_sync && (~sm_reset_rx_timer_clr) && sm_reset_rx_timer_sat)
          begin
            gtwiz_reset_rx_done_int <= 1'b1;
            sm_reset_rx_timer_clr   <= 1'b1;
            sm_reset_rx             <= ST_RESET_RX_IDLE;
          end
        end

        // While idle, de-assert the reset helper block RX reset done user output if PLL lock is lost, signaling the
        // need for user intervention
        ST_RESET_RX_IDLE: begin
          if (!plllock_rx_sync)
            gtwiz_reset_rx_done_int <= 1'b0;
        end

      endcase
    end
  end

  // Generate a small RX state machine reset timer, used to stall certain states to guarantee that their synchronized
  // input values are being used at the appropriate time
  always @(posedge gtwiz_reset_clk_freerun_in) begin
    if (sm_reset_rx_timer_clr) begin
      sm_reset_rx_timer_ctr <= 3'd0;
      sm_reset_rx_timer_sat <= 1'b0;
    end
    else begin
      if (sm_reset_rx_timer_ctr != 3'd7)
        sm_reset_rx_timer_ctr <= sm_reset_rx_timer_ctr + 3'd1;
      else
        sm_reset_rx_timer_sat <= 1'b1;
    end
  end

  // Generate an RX PLL reset timer, used to indicate when the specified minimum RX PLL reset duration has expired. This
  // is used by the RX state machine to proceed beyond the ST_RESET_RX_PLL wait state.
  always @(posedge gtwiz_reset_clk_freerun_in) begin
    if (sm_reset_rx_pll_timer_clr) begin
      sm_reset_rx_pll_timer_ctr <= 10'd0;
      sm_reset_rx_pll_timer_sat <= 1'b0;
    end
    else begin
      if (sm_reset_rx_pll_timer_ctr != p_rx_pll_reset_freerun_cyc_int)
        sm_reset_rx_pll_timer_ctr <= sm_reset_rx_pll_timer_ctr + 10'd1;
      else
        sm_reset_rx_pll_timer_sat <= 1'b1;
    end
  end

  // Generate a CDR lock timeout timer, used to indicate when the specified maximum CDR locking time has expired. This
  // is used by the RX state machine to proceed beyond the ST_RESET_RX_WAIT_CDR wait state in the event that the
  // transceiver RXCDRLOCK output does not assert within that time period.
  always @(posedge gtwiz_reset_clk_freerun_in) begin
    if (sm_reset_rx_cdr_to_clr) begin
      sm_reset_rx_cdr_to_ctr <= 26'd0;
      sm_reset_rx_cdr_to_sat <= 1'b0;
    end
    else begin
      if (sm_reset_rx_cdr_to_ctr != p_cdr_timeout_freerun_cyc_int)
        sm_reset_rx_cdr_to_ctr <= sm_reset_rx_cdr_to_ctr + 26'd1;
      else
        sm_reset_rx_cdr_to_sat <= 1'b1;
    end
  end

  // Assign the RX CDR stable user indicator to the transceiver RXCDRLOCK output
  assign gtwiz_reset_rx_cdr_stable_out = rxcdrlock_sync;

  // Synchronize the reset helper block RX reset done user output into the RXUSRCLK2 domain for user consumption
xpm_cdc_async_rst # (
 .DEST_SYNC_FF (3),
 .RST_ACTIVE_HIGH (1)

) l_ethernet_0_everest_gt_reset_controller_0_reset_synchronizer_rx_done_inst (
  .src_arst  (gtwiz_reset_rx_done_int),
  .dest_arst (gtwiz_reset_rx_done_out),
  .dest_clk  (rxusrclk2_in)
);

 end
endgenerate

endmodule


