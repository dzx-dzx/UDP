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



(* DowngradeIPIdentifiedWarnings="yes" *)

module  l_ethernet_0_mac_baser_syncer_reset
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

