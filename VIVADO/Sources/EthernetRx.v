// Generator : SpinalHDL v1.6.1    git head : 3bf789d53b1b5a36974196e2d591342e15ddf28c
// Component : EthernetRx

`timescale 1ns/1ps 

module EthernetRx (
  input               io_dataIn_valid,
  output reg          io_dataIn_ready,
  input               io_dataIn_payload_last,
  input      [511:0]  io_dataIn_payload_fragment_data,
  input      [63:0]   io_dataIn_payload_fragment_tkeep,
  output reg          io_dataOut_valid,
  input               io_dataOut_ready,
  output reg          io_dataOut_payload_last,
  output reg [511:0]  io_dataOut_payload_fragment_data,
  output     [15:0]   io_dataOut_payload_fragment_byteNum,
  output     [15:0]   io_dataOut_payload_fragment_errorCnt,
  output reg          io_dataOut_payload_fragment_errorFlag,
  output reg [63:0]   io_dataOut_payload_fragment_tkeep,
  input               clk,
  input               reset
);
  localparam fsm_enumDef_BOOT = 3'd0;
  localparam fsm_enumDef_idle = 3'd1;
  localparam fsm_enumDef_stIp = 3'd2;
  localparam fsm_enumDef_stUdp = 3'd3;
  localparam fsm_enumDef_stRxData = 3'd4;
  localparam fsm_enumDef_stRxEnd = 3'd5;

  reg        [15:0]   errorCnt;
  reg        [47:0]   destMac;
  reg        [15:0]   ethType;
  reg        [63:0]   preambleSdf;
  reg        [5:0]    ipHeadByteNum;
  reg        [31:0]   destIp;
  reg        [7:0]    protocol;
  reg        [15:0]   udpByteNum;
  reg        [15:0]   dataByteNum;
  reg        [15:0]   destPort;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [2:0]    fsm_stateReg;
  reg        [2:0]    fsm_stateNext;
  wire                when_EthernetRx_l91;
  wire                when_EthernetRx_l102;
  wire                when_EthernetRx_l129;
  wire                when_EthernetRx_l137;
  wire                when_EthernetRx_l157;
  wire                when_EthernetRx_l160;
  wire                io_dataIn_fire;
  wire                io_dataIn_fire_1;
  wire                when_EthernetRx_l190;
  wire                io_dataIn_fire_2;
  wire                when_EthernetRx_l202;
  `ifndef SYNTHESIS
  reg [63:0] fsm_stateReg_string;
  reg [63:0] fsm_stateNext_string;
  `endif


  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_BOOT : fsm_stateReg_string = "BOOT    ";
      fsm_enumDef_idle : fsm_stateReg_string = "idle    ";
      fsm_enumDef_stIp : fsm_stateReg_string = "stIp    ";
      fsm_enumDef_stUdp : fsm_stateReg_string = "stUdp   ";
      fsm_enumDef_stRxData : fsm_stateReg_string = "stRxData";
      fsm_enumDef_stRxEnd : fsm_stateReg_string = "stRxEnd ";
      default : fsm_stateReg_string = "????????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_BOOT : fsm_stateNext_string = "BOOT    ";
      fsm_enumDef_idle : fsm_stateNext_string = "idle    ";
      fsm_enumDef_stIp : fsm_stateNext_string = "stIp    ";
      fsm_enumDef_stUdp : fsm_stateNext_string = "stUdp   ";
      fsm_enumDef_stRxData : fsm_stateNext_string = "stRxData";
      fsm_enumDef_stRxEnd : fsm_stateNext_string = "stRxEnd ";
      default : fsm_stateNext_string = "????????";
    endcase
  end
  `endif

  always @(*) begin
    io_dataIn_ready = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
      end
      fsm_enumDef_stUdp : begin
        if(when_EthernetRx_l157) begin
          if(when_EthernetRx_l160) begin
            io_dataIn_ready = io_dataOut_ready;
          end
        end
      end
      fsm_enumDef_stRxData : begin
        if(io_dataIn_valid) begin
          io_dataIn_ready = io_dataOut_ready;
        end
      end
      fsm_enumDef_stRxEnd : begin
        if(io_dataIn_valid) begin
          io_dataIn_ready = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_dataOut_valid = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
      end
      fsm_enumDef_stUdp : begin
        if(when_EthernetRx_l157) begin
          if(when_EthernetRx_l160) begin
            io_dataOut_valid = io_dataIn_valid;
          end
        end
      end
      fsm_enumDef_stRxData : begin
        if(io_dataIn_valid) begin
          io_dataOut_valid = io_dataIn_valid;
        end
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_dataOut_payload_fragment_data = 512'h0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
      end
      fsm_enumDef_stUdp : begin
        if(when_EthernetRx_l157) begin
          if(when_EthernetRx_l160) begin
            io_dataOut_payload_fragment_data = io_dataIn_payload_fragment_data;
          end
        end
      end
      fsm_enumDef_stRxData : begin
        if(io_dataIn_valid) begin
          io_dataOut_payload_fragment_data = io_dataIn_payload_fragment_data;
        end
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_dataOut_payload_last = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
      end
      fsm_enumDef_stUdp : begin
      end
      fsm_enumDef_stRxData : begin
        if(io_dataIn_valid) begin
          io_dataOut_payload_last = io_dataIn_payload_last;
        end
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_dataOut_payload_fragment_errorFlag = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
      end
      fsm_enumDef_stUdp : begin
      end
      fsm_enumDef_stRxData : begin
      end
      fsm_enumDef_stRxEnd : begin
        if(io_dataIn_valid) begin
          io_dataOut_payload_fragment_errorFlag = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign io_dataOut_payload_fragment_byteNum = dataByteNum;
  assign io_dataOut_payload_fragment_errorCnt = errorCnt;
  always @(*) begin
    io_dataOut_payload_fragment_tkeep = 64'h0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
      end
      fsm_enumDef_stUdp : begin
        if(when_EthernetRx_l157) begin
          if(when_EthernetRx_l160) begin
            io_dataOut_payload_fragment_tkeep = {50'h0,io_dataIn_payload_fragment_tkeep[13 : 0]};
          end
        end
      end
      fsm_enumDef_stRxData : begin
        if(io_dataIn_valid) begin
          io_dataOut_payload_fragment_tkeep = io_dataIn_payload_fragment_tkeep;
        end
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    destMac = 48'h0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
        if(when_EthernetRx_l91) begin
          destMac = io_dataIn_payload_fragment_data[447 : 400];
        end
      end
      fsm_enumDef_stIp : begin
      end
      fsm_enumDef_stUdp : begin
      end
      fsm_enumDef_stRxData : begin
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ethType = 16'h0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
        if(when_EthernetRx_l91) begin
          ethType = io_dataIn_payload_fragment_data[351 : 336];
        end
      end
      fsm_enumDef_stIp : begin
      end
      fsm_enumDef_stUdp : begin
      end
      fsm_enumDef_stRxData : begin
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    preambleSdf = 64'h0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
        if(when_EthernetRx_l91) begin
          preambleSdf = io_dataIn_payload_fragment_data[511 : 448];
        end
      end
      fsm_enumDef_stIp : begin
      end
      fsm_enumDef_stUdp : begin
      end
      fsm_enumDef_stRxData : begin
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    ipHeadByteNum = 6'h0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
        if(when_EthernetRx_l129) begin
          ipHeadByteNum = {io_dataIn_payload_fragment_data[331 : 328],2'b00};
        end
      end
      fsm_enumDef_stUdp : begin
      end
      fsm_enumDef_stRxData : begin
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    protocol = 8'h0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
        if(when_EthernetRx_l129) begin
          protocol = io_dataIn_payload_fragment_data[263 : 256];
        end
      end
      fsm_enumDef_stUdp : begin
      end
      fsm_enumDef_stRxData : begin
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    destIp = 32'h0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
        if(when_EthernetRx_l129) begin
          destIp = io_dataIn_payload_fragment_data[207 : 176];
        end
      end
      fsm_enumDef_stUdp : begin
      end
      fsm_enumDef_stRxData : begin
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    destPort = 16'h0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
      end
      fsm_enumDef_stUdp : begin
        if(when_EthernetRx_l157) begin
          destPort = io_dataIn_payload_fragment_data[159 : 144];
        end
      end
      fsm_enumDef_stRxData : begin
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    udpByteNum = 16'h0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
        if(when_EthernetRx_l129) begin
          udpByteNum = io_dataIn_payload_fragment_data[143 : 128];
        end
      end
      fsm_enumDef_stUdp : begin
      end
      fsm_enumDef_stRxData : begin
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
      end
      fsm_enumDef_stUdp : begin
      end
      fsm_enumDef_stRxData : begin
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
        if(when_EthernetRx_l91) begin
          if(when_EthernetRx_l102) begin
            fsm_stateNext = fsm_enumDef_stIp;
          end else begin
            fsm_stateNext = fsm_enumDef_stRxEnd;
          end
        end
      end
      fsm_enumDef_stIp : begin
        if(when_EthernetRx_l129) begin
          if(when_EthernetRx_l137) begin
            fsm_stateNext = fsm_enumDef_stUdp;
          end else begin
            fsm_stateNext = fsm_enumDef_stRxEnd;
          end
        end else begin
          fsm_stateNext = fsm_enumDef_stRxEnd;
        end
      end
      fsm_enumDef_stUdp : begin
        if(when_EthernetRx_l157) begin
          if(when_EthernetRx_l160) begin
            if(io_dataIn_fire) begin
              fsm_stateNext = fsm_enumDef_stRxData;
            end else begin
              fsm_stateNext = fsm_enumDef_stUdp;
            end
          end else begin
            fsm_stateNext = fsm_enumDef_stRxEnd;
          end
        end else begin
          fsm_stateNext = fsm_enumDef_stRxEnd;
        end
      end
      fsm_enumDef_stRxData : begin
        if(io_dataIn_valid) begin
          if(when_EthernetRx_l190) begin
            fsm_stateNext = fsm_enumDef_idle;
          end
        end
      end
      fsm_enumDef_stRxEnd : begin
        if(io_dataIn_valid) begin
          if(when_EthernetRx_l202) begin
            fsm_stateNext = fsm_enumDef_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_BOOT;
    end
  end

  assign when_EthernetRx_l91 = (io_dataIn_valid && (io_dataIn_payload_fragment_tkeep[63 : 14] == 50'h3ffffffffffff));
  assign when_EthernetRx_l102 = (((preambleSdf == 64'h55555555555555d5) && ((destMac == 48'h111111111111) || (destMac == 48'hffffffffffff))) && (ethType == 16'h0800));
  assign when_EthernetRx_l129 = (io_dataIn_valid && (io_dataIn_payload_fragment_tkeep[63 : 14] == 50'h3ffffffffffff));
  assign when_EthernetRx_l137 = ((protocol == 8'h11) && (destIp == 32'hc0a81f6e));
  assign when_EthernetRx_l157 = (io_dataIn_valid && (io_dataIn_payload_fragment_tkeep[63 : 14] == 50'h3ffffffffffff));
  assign when_EthernetRx_l160 = (destPort == 16'h9460);
  assign io_dataIn_fire = (io_dataIn_valid && io_dataIn_ready);
  assign io_dataIn_fire_1 = (io_dataIn_valid && io_dataIn_ready);
  assign when_EthernetRx_l190 = (io_dataIn_payload_last && (io_dataIn_fire_1 == 1'b1));
  assign io_dataIn_fire_2 = (io_dataIn_valid && io_dataIn_ready);
  assign when_EthernetRx_l202 = (io_dataIn_payload_last && (io_dataIn_fire_2 == 1'b1));
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      errorCnt <= 16'h0;
      fsm_stateReg <= fsm_enumDef_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
      case(fsm_stateReg)
        fsm_enumDef_idle : begin
          if(when_EthernetRx_l91) begin
            if(!when_EthernetRx_l102) begin
              errorCnt <= (errorCnt + 16'h0001);
            end
          end
        end
        fsm_enumDef_stIp : begin
          if(when_EthernetRx_l129) begin
            if(!when_EthernetRx_l137) begin
              errorCnt <= (errorCnt + 16'h0001);
            end
          end else begin
            errorCnt <= (errorCnt + 16'h0001);
          end
        end
        fsm_enumDef_stUdp : begin
          if(when_EthernetRx_l157) begin
            if(!when_EthernetRx_l160) begin
              errorCnt <= (errorCnt + 16'h0001);
            end
          end else begin
            errorCnt <= (errorCnt + 16'h0001);
          end
        end
        fsm_enumDef_stRxData : begin
        end
        fsm_enumDef_stRxEnd : begin
        end
        default : begin
        end
      endcase
    end
  end

  always @(posedge clk) begin
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stIp : begin
        if(when_EthernetRx_l129) begin
          dataByteNum <= (udpByteNum - 16'h0008);
        end
      end
      fsm_enumDef_stUdp : begin
      end
      fsm_enumDef_stRxData : begin
      end
      fsm_enumDef_stRxEnd : begin
      end
      default : begin
      end
    endcase
  end


endmodule
