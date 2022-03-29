// Generator : SpinalHDL v1.6.1    git head : 3bf789d53b1b5a36974196e2d591342e15ddf28c
// Component : EthernetTx

`timescale 1ns/1ps 

module EthernetTx (
  input               io_dataIn_valid,
  output reg          io_dataIn_ready,
  input               io_dataIn_payload_last,
  input      [511:0]  io_dataIn_payload_fragment_data,
  input      [15:0]   io_dataIn_payload_fragment_byteNum,
  input      [63:0]   io_dataIn_payload_fragment_tkeep,
  output reg          io_dataOut_valid,
  input               io_dataOut_ready,
  output reg          io_dataOut_payload_last,
  output reg [511:0]  io_dataOut_payload_fragment_data,
  output reg [63:0]   io_dataOut_payload_fragment_tkeep,
  input               clk,
  input               reset
);
  localparam fsm_enumDef_BOOT = 2'd0;
  localparam fsm_enumDef_idle = 2'd1;
  localparam fsm_enumDef_stCheckSum = 2'd2;
  localparam fsm_enumDef_stTxData = 2'd3;

  wire       [15:0]   _zz_headBuffer;
  wire       [15:0]   _zz_headBuffer_1;
  wire       [15:0]   _zz_checkBuffer;
  wire       [15:0]   _zz_checkBuffer_1;
  wire       [15:0]   _zz_checkBuffer_2;
  wire       [15:0]   _zz_checkBuffer_3;
  wire       [15:0]   _zz_checkBuffer_4;
  wire       [15:0]   _zz_checkBuffer_5;
  wire       [15:0]   _zz_checkBuffer_6;
  wire       [15:0]   _zz_checkBuffer_7;
  wire       [15:0]   _zz_checkBuffer_8;
  wire       [15:0]   _zz_checkBuffer_9;
  reg        [511:0]  headBuffer;
  reg        [15:0]   identificationCnt;
  reg        [5:0]    checkCnt;
  reg        [31:0]   checkBuffer;
  reg        [15:0]   realTxDataNum;
  wire                when_EthernetTx_l62;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_EthernetTx_l109;
  wire                io_dataOut_fire;
  wire                when_EthernetTx_l121;
  wire                when_EthernetTx_l125;
  wire                when_EthernetTx_l127;
  wire                io_dataIn_fire;
  wire                when_EthernetTx_l151;
  wire                when_EthernetTx_l152;
  wire                when_StateMachine_l235;
  `ifndef SYNTHESIS
  reg [79:0] fsm_stateReg_string;
  reg [79:0] fsm_stateNext_string;
  `endif


  assign _zz_headBuffer = (io_dataIn_payload_fragment_byteNum + 16'h001c);
  assign _zz_headBuffer_1 = (io_dataIn_payload_fragment_byteNum + 16'h0008);
  assign _zz_checkBuffer = (_zz_checkBuffer_1 + headBuffer[191 : 176]);
  assign _zz_checkBuffer_1 = (_zz_checkBuffer_2 + headBuffer[207 : 192]);
  assign _zz_checkBuffer_2 = (_zz_checkBuffer_3 + headBuffer[223 : 208]);
  assign _zz_checkBuffer_3 = (_zz_checkBuffer_4 + headBuffer[239 : 224]);
  assign _zz_checkBuffer_4 = (_zz_checkBuffer_5 + headBuffer[255 : 240]);
  assign _zz_checkBuffer_5 = (_zz_checkBuffer_6 + headBuffer[271 : 256]);
  assign _zz_checkBuffer_6 = (_zz_checkBuffer_7 + headBuffer[287 : 272]);
  assign _zz_checkBuffer_7 = (_zz_checkBuffer_8 + headBuffer[303 : 288]);
  assign _zz_checkBuffer_8 = (headBuffer[335 : 320] + headBuffer[319 : 304]);
  assign _zz_checkBuffer_9 = (checkBuffer[31 : 16] + checkBuffer[15 : 0]);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_BOOT : fsm_stateReg_string = "BOOT      ";
      fsm_enumDef_idle : fsm_stateReg_string = "idle      ";
      fsm_enumDef_stCheckSum : fsm_stateReg_string = "stCheckSum";
      fsm_enumDef_stTxData : fsm_stateReg_string = "stTxData  ";
      default : fsm_stateReg_string = "??????????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_BOOT : fsm_stateNext_string = "BOOT      ";
      fsm_enumDef_idle : fsm_stateNext_string = "idle      ";
      fsm_enumDef_stCheckSum : fsm_stateNext_string = "stCheckSum";
      fsm_enumDef_stTxData : fsm_stateNext_string = "stTxData  ";
      default : fsm_stateNext_string = "??????????";
    endcase
  end
  `endif

  assign when_EthernetTx_l62 = (16'h0012 <= io_dataIn_payload_fragment_byteNum);
  always @(*) begin
    if(when_EthernetTx_l62) begin
      realTxDataNum = io_dataIn_payload_fragment_byteNum;
    end else begin
      realTxDataNum = 16'h0012;
    end
  end

  always @(*) begin
    io_dataIn_ready = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stCheckSum : begin
      end
      fsm_enumDef_stTxData : begin
        if(io_dataIn_valid) begin
          io_dataIn_ready = io_dataOut_ready;
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
      fsm_enumDef_stCheckSum : begin
        if(io_dataIn_valid) begin
          if(!when_EthernetTx_l109) begin
            if(!when_EthernetTx_l121) begin
              if(!when_EthernetTx_l125) begin
                if(when_EthernetTx_l127) begin
                  io_dataOut_valid = 1'b1;
                end
              end
            end
          end
        end
      end
      fsm_enumDef_stTxData : begin
        if(io_dataIn_valid) begin
          io_dataOut_valid = io_dataIn_valid;
        end
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
      fsm_enumDef_stCheckSum : begin
        if(io_dataIn_valid) begin
          if(!when_EthernetTx_l109) begin
            if(!when_EthernetTx_l121) begin
              if(!when_EthernetTx_l125) begin
                if(when_EthernetTx_l127) begin
                  io_dataOut_payload_fragment_data = headBuffer;
                end
              end
            end
          end
        end
      end
      fsm_enumDef_stTxData : begin
        if(io_dataIn_valid) begin
          io_dataOut_payload_fragment_data = io_dataIn_payload_fragment_data;
        end
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
      fsm_enumDef_stCheckSum : begin
      end
      fsm_enumDef_stTxData : begin
        if(io_dataIn_valid) begin
          io_dataOut_payload_last = io_dataIn_payload_last;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_dataOut_payload_fragment_tkeep = 64'h0;
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_stCheckSum : begin
        if(io_dataIn_valid) begin
          if(!when_EthernetTx_l109) begin
            if(!when_EthernetTx_l121) begin
              if(!when_EthernetTx_l125) begin
                if(when_EthernetTx_l127) begin
                  io_dataOut_payload_fragment_tkeep = {50'h3ffffffffffff,14'h0};
                end
              end
            end
          end
        end
      end
      fsm_enumDef_stTxData : begin
        if(io_dataIn_valid) begin
          io_dataOut_payload_fragment_tkeep = io_dataIn_payload_fragment_tkeep;
          if(when_EthernetTx_l151) begin
            if(when_EthernetTx_l152) begin
              io_dataOut_payload_fragment_tkeep = {18'h3ffff,46'h0};
            end
          end
        end
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
      fsm_enumDef_stCheckSum : begin
      end
      fsm_enumDef_stTxData : begin
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
        if(io_dataIn_valid) begin
          fsm_stateNext = fsm_enumDef_stCheckSum;
        end
      end
      fsm_enumDef_stCheckSum : begin
        if(io_dataIn_valid) begin
          if(!when_EthernetTx_l109) begin
            if(!when_EthernetTx_l121) begin
              if(!when_EthernetTx_l125) begin
                if(when_EthernetTx_l127) begin
                  if(io_dataOut_fire) begin
                    fsm_stateNext = fsm_enumDef_stTxData;
                  end
                end
              end
            end
          end
        end
      end
      fsm_enumDef_stTxData : begin
        if(io_dataIn_valid) begin
          if(when_EthernetTx_l151) begin
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

  assign when_EthernetTx_l109 = (checkCnt == 6'h0);
  assign io_dataOut_fire = (io_dataOut_valid && io_dataOut_ready);
  assign when_EthernetTx_l121 = ((checkCnt == 6'h01) || (checkCnt == 6'h02));
  assign when_EthernetTx_l125 = (checkCnt == 6'h03);
  assign when_EthernetTx_l127 = (checkCnt == 6'h04);
  assign io_dataIn_fire = (io_dataIn_valid && io_dataIn_ready);
  assign when_EthernetTx_l151 = (io_dataIn_payload_last && (io_dataIn_fire == 1'b1));
  assign when_EthernetTx_l152 = (io_dataIn_payload_fragment_byteNum < 16'h0012);
  assign when_StateMachine_l235 = ((! (fsm_stateReg == fsm_enumDef_stCheckSum)) && (fsm_stateNext == fsm_enumDef_stCheckSum));
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      headBuffer <= 512'h0;
      identificationCnt <= 16'h0;
      checkCnt <= 6'h0;
      checkBuffer <= 32'h0;
      fsm_stateReg <= fsm_enumDef_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
      case(fsm_stateReg)
        fsm_enumDef_idle : begin
          if(io_dataIn_valid) begin
            headBuffer[511 : 448] <= 64'h55555555555555d5;
            headBuffer[447 : 400] <= 48'h111111111111;
            headBuffer[399 : 352] <= 48'h111111111101;
            headBuffer[351 : 336] <= 16'h0800;
            headBuffer[335 : 328] <= 8'h45;
            headBuffer[327 : 320] <= 8'h0;
            headBuffer[319 : 304] <= _zz_headBuffer;
            headBuffer[303 : 288] <= identificationCnt;
            identificationCnt <= (identificationCnt + 16'h0001);
            headBuffer[287 : 272] <= 16'h4000;
            headBuffer[271 : 256] <= 16'h4011;
            headBuffer[255 : 240] <= 16'h0;
            headBuffer[239 : 208] <= 32'h11111111;
            headBuffer[207 : 176] <= 32'hc0a81f6e;
            headBuffer[175 : 160] <= 16'h9461;
            headBuffer[159 : 144] <= 16'h9460;
            headBuffer[143 : 128] <= _zz_headBuffer_1;
            headBuffer[127 : 0] <= 128'h0;
          end
        end
        fsm_enumDef_stCheckSum : begin
          if(io_dataIn_valid) begin
            checkCnt <= (checkCnt + 6'h01);
            if(when_EthernetTx_l109) begin
              checkBuffer <= {16'd0, _zz_checkBuffer};
            end else begin
              if(when_EthernetTx_l121) begin
                checkBuffer <= {16'd0, _zz_checkBuffer_9};
              end else begin
                if(when_EthernetTx_l125) begin
                  headBuffer[255 : 240] <= (~ checkBuffer[15 : 0]);
                end else begin
                  if(when_EthernetTx_l127) begin
                    checkCnt <= checkCnt;
                  end
                end
              end
            end
          end
        end
        fsm_enumDef_stTxData : begin
        end
        default : begin
        end
      endcase
      if(when_StateMachine_l235) begin
        checkCnt <= 6'h0;
        checkBuffer <= 32'h0;
      end
    end
  end


endmodule
