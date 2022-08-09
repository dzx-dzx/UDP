// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Sun Aug  7 12:24:35 2022
// Host        :  running 64-bit Linux Mint 20.3
// Command     : write_verilog -force -mode synth_stub ***/sources_1/ip/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xcvu13p-fhgb2104-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2019.1" *)
module ila_0(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[511:0],probe1[0:0],probe2[0:0],probe3[63:0],probe4[255:0],probe5[0:0],probe6[0:0],probe7[0:0],probe8[31:0],probe9[0:0]" */;
  input clk;
  input [511:0]probe0;
  input [0:0]probe1;
  input [0:0]probe2;
  input [63:0]probe3;
  input [255:0]probe4;
  input [0:0]probe5;
  input [0:0]probe6;
  input [0:0]probe7;
  input [31:0]probe8;
  input [0:0]probe9;
endmodule
