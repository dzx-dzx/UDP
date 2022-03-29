// Generator : SpinalHDL v1.6.1    git head : 3bf789d53b1b5a36974196e2d591342e15ddf28c
// Component : TxFsm

`timescale 1ns/1ps 

module TxFsm (
  output              io_dataOut_valid,
  input               io_dataOut_ready,
  output reg          io_dataOut_payload_last,
  output     [511:0]  io_dataOut_payload_fragment_data,
  output     [15:0]   io_dataOut_payload_fragment_byteNum,
  output     [63:0]   io_dataOut_payload_fragment_tkeep,
  input               clk,
  input               reset
);

  wire       [6:0]    _zz_dataCnt_valueNext;
  wire       [0:0]    _zz_dataCnt_valueNext_1;
  wire       [6:0]    _zz_io_dataOut_payload_fragment_data;
  reg                 dataCnt_willIncrement;
  wire                dataCnt_willClear;
  reg        [6:0]    dataCnt_valueNext;
  reg        [6:0]    dataCnt_value;
  wire                dataCnt_willOverflowIfInc;
  wire                dataCnt_willOverflow;
  wire                io_dataOut_fire;

  assign _zz_dataCnt_valueNext_1 = dataCnt_willIncrement;
  assign _zz_dataCnt_valueNext = {6'd0, _zz_dataCnt_valueNext_1};
  assign _zz_io_dataOut_payload_fragment_data = dataCnt_value;
  always @(*) begin
    dataCnt_willIncrement = 1'b0;
    if(io_dataOut_fire) begin
      dataCnt_willIncrement = 1'b1;
    end
  end

  assign dataCnt_willClear = 1'b0;
  assign dataCnt_willOverflowIfInc = (dataCnt_value == 7'h63);
  assign dataCnt_willOverflow = (dataCnt_willOverflowIfInc && dataCnt_willIncrement);
  always @(*) begin
    if(dataCnt_willOverflow) begin
      dataCnt_valueNext = 7'h0;
    end else begin
      dataCnt_valueNext = (dataCnt_value + _zz_dataCnt_valueNext);
    end
    if(dataCnt_willClear) begin
      dataCnt_valueNext = 7'h0;
    end
  end

  assign io_dataOut_payload_fragment_byteNum = 16'h0064;
  assign io_dataOut_valid = 1'b1;
  assign io_dataOut_payload_fragment_data = {505'd0, _zz_io_dataOut_payload_fragment_data};
  assign io_dataOut_payload_fragment_tkeep = 64'hffffffffffffffff;
  assign io_dataOut_fire = (io_dataOut_valid && io_dataOut_ready);
  always @(*) begin
    if(dataCnt_willOverflow) begin
      io_dataOut_payload_last = 1'b1;
    end else begin
      io_dataOut_payload_last = 1'b0;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      dataCnt_value <= 7'h0;
    end else begin
      dataCnt_value <= dataCnt_valueNext;
    end
  end


endmodule
