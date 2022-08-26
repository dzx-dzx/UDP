`define SIM
module udp_40G_TOP
(
    input clk,
    input  [3 :0]   gt_rxp_in_40MAC_0               ,
    input  [3 :0]   gt_rxn_in_40MAC_0               ,
    output [3 :0]   gt_txp_out_40MAC_0              ,
    output [3 :0]   gt_txn_out_40MAC_0              ,
    output          rx_aligned_led                  ,
`ifdef SIM
    input sys_reset,
`endif 
    input           gt_ref_clk_p_40MAC_0            ,
    input           gt_ref_clk_n_40MAC_0            ,
                        
    input  wire     sys_clk_p,
    input  wire     sys_clk_n,
    output wire     pkt_clk,

    input              fsm_dataOut_valid_0,
    output             fsm_dataOut_ready_0,
    input              fsm_dataOut_payload_last_0,
    input     [511:0]  fsm_dataOut_payload_fragment_data_0,
    input     [15:0]   fsm_dataOut_payload_fragment_byteNum_0,
    input     [63:0]   fsm_dataOut_payload_fragment_tkeep_0,

    output             rx_dataOut_valid_0,
    input              rx_dataOut_ready_0,
    output             rx_dataOut_payload_last_0,
    output  [511:0]    rx_dataOut_payload_fragment_data_0,
    output  [15:0]     rx_dataOut_payload_fragment_byteNum_0,
    output  [15:0]     rx_dataOut_payload_fragment_errorCnt_0,
    output             rx_dataOut_payload_fragment_errorFlag_0,
    output  [63:0]     rx_dataOut_payload_fragment_tkeep_0
);

    wire dclk;
    // wire pkt_clk;
    wire locked;


    clk_wiz_0 U_clk_wiz_0(
    .clk_out1(dclk),     // 100MHZ
    .clk_out2(pkt_clk),     // 312.5MHZ
    
    .clk_in1_p(sys_clk_p),    // input clk_in1_p
    .clk_in1_n(sys_clk_n)
    );


`ifndef SIM
wire sys_reset;
    vio_0 u_vio (
      .clk(pkt_clk),                // input wire clk
      .probe_out0(sys_reset)  // output wire [0 : 0] probe_out0
    );
`endif

    wire           rx_core_clk_40MAC_0         ;
    wire           user_rx_reset_40MAC_0       ;


    wire           rx_axis_tvalid_40MAC_0      ;
    wire [255:0]   rx_axis_tdata_40MAC_0       ;
    wire           rx_axis_tlast_40MAC_0       ;
    wire [31:0]    rx_axis_tkeep_40MAC_0       ;
    wire           rx_axis_tuser_40MAC_0       ;
    wire           rx_axis_tready_40MAC_0      ;
   
    wire           tx_axis_tvalid_40MAC_0      ;
    wire  [255:0]  tx_axis_tdata_40MAC_0       ;
    wire           tx_axis_tlast_40MAC_0       ;
    wire  [31:0]   tx_axis_tkeep_40MAC_0       ;
    wire           tx_axis_tuser_40MAC_0       ;
    wire           tx_axis_tready_40MAC_0      ;


    assign tx_axis_tuser_40MAC_0 = 1'b0;

    l_ethernet_0_exdes inst_0_ethernet_0_exdes (
            .gt_rxp_in       (gt_rxp_in_40MAC_0),
            .gt_rxn_in       (gt_rxn_in_40MAC_0),
            .gt_txp_out      (gt_txp_out_40MAC_0),
            .gt_txn_out      (gt_txn_out_40MAC_0),
            .sys_reset       (sys_reset),
            .gt_refclk_p     (gt_ref_clk_p_40MAC_0),
            .gt_refclk_n     (gt_ref_clk_n_40MAC_0),
            .dclk            (dclk),
            .rx_core_clk_0   (rx_core_clk_40MAC_0),
            .user_rx_reset_0 (user_rx_reset_40MAC_0),
            .rx_axis_tvalid  (rx_axis_tvalid_40MAC_0),
            .rx_axis_tdata   (rx_axis_tdata_40MAC_0),
            .rx_axis_tlast   (rx_axis_tlast_40MAC_0),
            .rx_axis_tkeep   (rx_axis_tkeep_40MAC_0),
            .rx_axis_tuser   (rx_axis_tuser_40MAC_0),
            .tx_axis_tready  (tx_axis_tready_40MAC_0),
            .tx_axis_tvalid  (tx_axis_tvalid_40MAC_0),
            .tx_axis_tdata   (tx_axis_tdata_40MAC_0),
            .tx_axis_tlast   (tx_axis_tlast_40MAC_0),
            .tx_axis_tkeep   (tx_axis_tkeep_40MAC_0),
            .tx_axis_tuser   (tx_axis_tuser_40MAC_0),
            .rx_aligned_led  (rx_aligned_led)
        );



    // wire          fsm_dataOut_valid_0;
    // wire          fsm_dataOut_ready_0;
    // wire          fsm_dataOut_payload_last_0;
    // wire [511:0]  fsm_dataOut_payload_fragment_data_0;
    // wire [15:0]   fsm_dataOut_payload_fragment_byteNum_0;
    // wire [63:0]   fsm_dataOut_payload_fragment_tkeep_0;


    
    wire          udp_dataOut_valid_0;
    wire          udp_dataOut_ready_0;
    wire          udp_dataOut_payload_last_0;
    wire [511:0]  udp_dataOut_payload_fragment_data_0;
    wire [63:0]   udp_dataOut_payload_fragment_tkeep_0;


    wire              adapter_dataOut_valid_0;
    wire              adapter_dataOut_ready_0;
    wire              adapter_dataOut_payload_last_0;
    wire     [255:0]   adapter_dataOut_payload_fragment_data_0;
    wire     [31:0]    adapter_dataOut_payload_fragment_tkeep_0;



    // TxFsm inst_TxFsm_0(
    //   .io_dataOut_valid                    (fsm_dataOut_valid_0),
    //   .io_dataOut_ready                    (fsm_dataOut_ready_0),
    //   .io_dataOut_payload_last             (fsm_dataOut_payload_last_0),
    //   .io_dataOut_payload_fragment_data    (fsm_dataOut_payload_fragment_data_0),
    //   .io_dataOut_payload_fragment_byteNum (fsm_dataOut_payload_fragment_byteNum_0),
    //   .io_dataOut_payload_fragment_tkeep   (fsm_dataOut_payload_fragment_tkeep_0),
    //   .clk                                 (pkt_clk),
    //   .reset                               (sys_reset)
    // );

     EthernetTx inst_EthernetTx_0(
      .io_dataIn_valid                    (fsm_dataOut_valid_0),
      .io_dataIn_ready                    (fsm_dataOut_ready_0),
      .io_dataIn_payload_last             (fsm_dataOut_payload_last_0),
      .io_dataIn_payload_fragment_data    (fsm_dataOut_payload_fragment_data_0),
      .io_dataIn_payload_fragment_byteNum (fsm_dataOut_payload_fragment_byteNum_0),
      .io_dataIn_payload_fragment_tkeep   (fsm_dataOut_payload_fragment_tkeep_0),
      .io_dataOut_valid                   (udp_dataOut_valid_0),
      .io_dataOut_ready                   (udp_dataOut_ready_0),
      .io_dataOut_payload_last            (udp_dataOut_payload_last_0),
      .io_dataOut_payload_fragment_data   (udp_dataOut_payload_fragment_data_0),
      .io_dataOut_payload_fragment_tkeep  (udp_dataOut_payload_fragment_tkeep_0),
      .clk                                (pkt_clk),
      .reset                              (sys_reset)
    );


    axis_512to256 u_axis_512to256_0 (
      .aclk(pkt_clk),                    // input wire aclk
      .aresetn(~sys_reset),              // input wire aresetn
      .s_axis_tvalid(udp_dataOut_valid_0),  // input wire s_axis_tvalid
      .s_axis_tready(udp_dataOut_ready_0),  // output wire s_axis_tready
      .s_axis_tdata(udp_dataOut_payload_fragment_data_0),    // input wire [511 : 0] s_axis_tdata
      .s_axis_tkeep(udp_dataOut_payload_fragment_tkeep_0),    // input wire [63 : 0] s_axis_tkeep
      .s_axis_tlast(udp_dataOut_payload_last_0),    // input wire s_axis_tlast
      .m_axis_tvalid(adapter_dataOut_valid_0),  // output wire m_axis_tvalid
      .m_axis_tready(adapter_dataOut_ready_0),  // input wire m_axis_tready
      .m_axis_tdata(adapter_dataOut_payload_fragment_data_0),    // output wire [255 : 0] m_axis_tdata
      .m_axis_tkeep(adapter_dataOut_payload_fragment_tkeep_0),    // output wire [31 : 0] m_axis_tkeep
      .m_axis_tlast(adapter_dataOut_payload_last_0)    // output wire m_axis_tlast
    );



     axis_clock_converter tx_axis_clock_converter_0 (
      .s_axis_aresetn(~sys_reset),  // input wire s_axis_aresetn
      .m_axis_aresetn(~user_rx_reset_40MAC_0),  // input wire m_axis_aresetn
      .s_axis_aclk(pkt_clk),        // input wire s_axis_aclk
      .s_axis_tvalid(adapter_dataOut_valid_0),    // input wire s_axis_tvalid
      .s_axis_tready(adapter_dataOut_ready_0),    // output wire s_axis_tready
      .s_axis_tdata(adapter_dataOut_payload_fragment_data_0),      // input wire [255 : 0] s_axis_tdata
      .s_axis_tkeep(adapter_dataOut_payload_fragment_tkeep_0),      // input wire [31 : 0] s_axis_tkeep
      .s_axis_tlast(adapter_dataOut_payload_last_0),      // input wire s_axis_tlast
      .m_axis_aclk(rx_core_clk_40MAC_0),        // input wire m_axis_aclk
      .m_axis_tvalid(tx_axis_tvalid_40MAC_0),    // output wire m_axis_tvalid
      .m_axis_tready(tx_axis_tready_40MAC_0),    // input wire m_axis_tready
      .m_axis_tdata(tx_axis_tdata_40MAC_0),      // output wire [255 : 0] m_axis_tdata
      .m_axis_tkeep(tx_axis_tkeep_40MAC_0),      // output wire [31 : 0] m_axis_tkeep
      .m_axis_tlast(tx_axis_tlast_40MAC_0)      // output wire m_axis_tlast
    );
    


wire fifo_axis_tvalid_0;
wire fifo_axis_tready_0;
wire [255:0] fifo_axis_tdata_0 ;
wire [31:0] fifo_axis_tkeep_0  ;
wire fifo_axis_tlast_0 ;  

wire clock_axis_tvalid_0;
wire clock_axis_tready_0;
wire [255:0] clock_axis_tdata_0 ;
wire [31:0] clock_axis_tkeep_0  ;
wire clock_axis_tlast_0 ;  



wire dataCon_axis_tvalid_0;
wire dataCon_axis_tready_0;
wire [511 : 0] dataCon_axis_tdata_0 ;
wire [63 : 0] dataCon_axis_tkeep_0  ;
wire dataCon_axis_tlast_0 ;  


wire  rx_dataOut_valid_0;
wire  rx_dataOut_ready_0;
wire  rx_dataOut_payload_last_0;
wire [511:0] rx_dataOut_payload_fragment_data_0;
wire  [15:0] rx_dataOut_payload_fragment_byteNum_0;
wire  [15:0] rx_dataOut_payload_fragment_errorCnt_0;
wire  rx_dataOut_payload_fragment_errorFlag_0;
wire  [63:0] rx_dataOut_payload_fragment_tkeep_0;




  axis_clock_converter rx_axis_clock_converter_0 (
  .s_axis_aresetn(~user_rx_reset_40MAC_0),  // input wire s_axis_aresetn
  .m_axis_aresetn(~sys_reset),  // input wire m_axis_aresetn
  .s_axis_aclk(rx_core_clk_40MAC_0),        // input wire s_axis_aclk
  .s_axis_tvalid(rx_axis_tvalid_40MAC_0),    // input wire s_axis_tvalid
  .s_axis_tready(s_axis_tready_0),    // output wire s_axis_tready
  .s_axis_tdata(rx_axis_tdata_40MAC_0),      // input wire [63 : 0] s_axis_tdata
  .s_axis_tkeep(rx_axis_tkeep_40MAC_0),      // input wire [7 : 0] s_axis_tkeep
  .s_axis_tlast(rx_axis_tlast_40MAC_0),      // input wire s_axis_tlast
  .m_axis_aclk(pkt_clk),        // input wire m_axis_aclk
  .m_axis_tvalid(clock_axis_tvalid_0),    // output wire m_axis_tvalid
  .m_axis_tready(clock_axis_tready_0),    // input wire m_axis_tready
  .m_axis_tdata(clock_axis_tdata_0),      // output wire [63 : 0] m_axis_tdata
  .m_axis_tkeep(clock_axis_tkeep_0),      // output wire [7 : 0] m_axis_tkeep
  .m_axis_tlast(clock_axis_tlast_0)      // output wire m_axis_tlast
);




axis_data_fifo_0 u_axis_data_fifo_0 (
  .s_axis_aresetn(~sys_reset),  // input wire s_axis_aresetn
  .s_axis_aclk(pkt_clk),        // input wire s_axis_aclk
  .s_axis_tvalid(clock_axis_tvalid_0),    // input wire s_axis_tvalid
  .s_axis_tready(clock_axis_tready_0),    // output wire s_axis_tready
  .s_axis_tdata(clock_axis_tdata_0),      // input wire [63 : 0] s_axis_tdata
  .s_axis_tkeep(clock_axis_tkeep_0),      // input wire [7 : 0] s_axis_tkeep
  .s_axis_tlast(clock_axis_tlast_0),      // input wire s_axis_tlast
  .m_axis_tvalid(fifo_axis_tvalid_0),    // output wire m_axis_tvalid
  .m_axis_tready(fifo_axis_tready_0),    // input wire m_axis_tready
  .m_axis_tdata(fifo_axis_tdata_0),      // output wire [63 : 0] m_axis_tdata
  .m_axis_tkeep(fifo_axis_tkeep_0),      // output wire [7 : 0] m_axis_tkeep
  .m_axis_tlast(fifo_axis_tlast_0)      // output wire m_axis_tlast
);



axis_256to512 axis_256to512_0 (
  .aclk(pkt_clk),                    // input wire aclk
  .aresetn(~sys_reset),              // input wire aresetn
  .s_axis_tvalid(fifo_axis_tvalid_0),  // input wire s_axis_tvalid
  .s_axis_tready(fifo_axis_tready_0),  // output wire s_axis_tready
  .s_axis_tdata(fifo_axis_tdata_0),    // input wire [63 : 0] s_axis_tdata
  .s_axis_tkeep(fifo_axis_tkeep_0),    // input wire [7 : 0] s_axis_tkeep
  .s_axis_tlast(fifo_axis_tlast_0),    // input wire s_axis_tlast
  .m_axis_tvalid(dataCon_axis_tvalid_0),  // output wire m_axis_tvalid
  .m_axis_tready(dataCon_axis_tready_0),  // input wire m_axis_tready
  .m_axis_tdata(dataCon_axis_tdata_0),    // output wire [511 : 0] m_axis_tdata
  .m_axis_tkeep(dataCon_axis_tkeep_0),    // output wire [63 : 0] m_axis_tkeep
  .m_axis_tlast(dataCon_axis_tlast_0)    // output wire m_axis_tlast
);



  EthernetRx inst_EthernetRx_0(
      .io_dataIn_valid                       (dataCon_axis_tvalid_0),
      .io_dataIn_ready                       (dataCon_axis_tready_0),
      .io_dataIn_payload_last                (dataCon_axis_tlast_0),
      .io_dataIn_payload_fragment_data       (dataCon_axis_tdata_0),
      .io_dataIn_payload_fragment_tkeep      (dataCon_axis_tkeep_0),
      .io_dataOut_valid                      (rx_dataOut_valid_0),
      .io_dataOut_ready                      (rx_dataOut_ready_0),
      .io_dataOut_payload_last               (rx_dataOut_payload_last_0),
      .io_dataOut_payload_fragment_data      (rx_dataOut_payload_fragment_data_0),
      .io_dataOut_payload_fragment_byteNum   (rx_dataOut_payload_fragment_byteNum_0),
      .io_dataOut_payload_fragment_errorCnt  (rx_dataOut_payload_fragment_errorCnt_0),
      .io_dataOut_payload_fragment_errorFlag (rx_dataOut_payload_fragment_errorFlag_0),
      .io_dataOut_payload_fragment_tkeep     (rx_dataOut_payload_fragment_tkeep_0),
      .clk                                   (pkt_clk),
      .reset                                 (sys_reset)
    );


    assign rx_dataOut_ready_0 = 1'b1;

ila_0 u_ila_0 (
  .clk(dclk), // input wire clk


  .probe0(rx_dataOut_payload_fragment_data_0), // input wire [63:0]  probe0  
  .probe1(rx_dataOut_valid_0), // input wire [0:0]  probe1 
  .probe2(rx_dataOut_payload_last_0), // input wire [0:0]  probe2 
  .probe3(rx_dataOut_payload_fragment_tkeep_0), // input wire [0:0]  probe3 
  .probe4(tx_axis_tdata_40MAC_0), // input wire [63:0]  probe4 
  .probe5(tx_axis_tready_40MAC_0), // input wire [0:0]  probe5 tx_axis_tready_0
  .probe6(tx_axis_tvalid_40MAC_0), // input wire [0:0]  probe6 
  .probe7(tx_axis_tlast_40MAC_0), // input wire [0:0]  probe7 
  .probe8(tx_axis_tkeep_40MAC_0), // input wire [0:0]  probe8 
  .probe9(rx_dataOut_ready_0) // input wire [0:0]  probe9

);
endmodule



