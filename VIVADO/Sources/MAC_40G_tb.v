`define SIM_SPEED_UP
`define  SIM
`timescale 1fs/1fs

module MAC_40G_tb
(
);



    reg             gt_ref_clk_p_40MAC_0;
    reg             gt_ref_clk_n_40MAC_0;
    reg             gt_ref_clk_p_40MAC_1;
    reg             gt_ref_clk_n_40MAC_1;
    reg             sys_reset;

    wire [3 :0]   gt_rxp_in_40MAC_0               ;
    wire [3 :0]   gt_rxn_in_40MAC_0               ;
    wire [3 :0]   gt_txp_out_40MAC_0              ;
    wire [3 :0]   gt_txn_out_40MAC_0              ;
    wire [3 :0]   gt_rxp_in_40MAC_1                ;
    wire [3 :0]   gt_rxn_in_40MAC_1                ;
    wire [3 :0]   gt_txp_out_40MAC_1               ;
    wire [3 :0]   gt_txn_out_40MAC_1               ;
    reg             sys_clk_n;
    reg            sys_clk_p;


  udp_40G_TOP inst_udp_40G_TOP(
      .gt_rxp_in_40MAC_0    (gt_txp_out_40MAC_0),
      .gt_rxn_in_40MAC_0    (gt_txn_out_40MAC_0),
      .gt_txp_out_40MAC_0   (gt_txp_out_40MAC_0),
      .gt_txn_out_40MAC_0   (gt_txn_out_40MAC_0),
      .gt_rxp_in_40MAC_1    (gt_txp_out_40MAC_1),
      .gt_rxn_in_40MAC_1    (gt_txn_out_40MAC_1),
      .gt_txp_out_40MAC_1   (gt_txp_out_40MAC_1),
      .gt_txn_out_40MAC_1   (gt_txn_out_40MAC_1),
      .sys_reset            (sys_reset),
      .gt_ref_clk_p_40MAC_0 (gt_ref_clk_p_40MAC_0),
      .gt_ref_clk_n_40MAC_0 (gt_ref_clk_n_40MAC_0),
      .gt_ref_clk_p_40MAC_1 (gt_ref_clk_p_40MAC_1),
      .gt_ref_clk_n_40MAC_1 (gt_ref_clk_n_40MAC_1),
      .sys_clk_p            (sys_clk_p),
      .sys_clk_n            (sys_clk_n)
    );

initial
    begin
      sys_reset  = 1; 
      repeat (60) @(posedge sys_clk_p);
      sys_reset = 0;
    end

 initial
    begin
        gt_ref_clk_p_40MAC_0 =1;
        forever #3200000.000   gt_ref_clk_p_40MAC_0 = ~ gt_ref_clk_p_40MAC_0;
    end

    initial
    begin
        gt_ref_clk_n_40MAC_0 =0;
        forever #3200000.000   gt_ref_clk_n_40MAC_0 = ~ gt_ref_clk_n_40MAC_0;
    end
 initial
    begin
        gt_ref_clk_p_40MAC_1 =1;
        forever #3200000.000   gt_ref_clk_p_40MAC_1 = ~ gt_ref_clk_p_40MAC_1;
    end

    initial
    begin
        gt_ref_clk_n_40MAC_1 =0;
        forever #3200000.000   gt_ref_clk_n_40MAC_1 = ~ gt_ref_clk_n_40MAC_1;
    end
 initial
    begin
        sys_clk_p =1;
        forever #1666666.667   sys_clk_p = ~ sys_clk_p;
    end

    initial
    begin
        sys_clk_n =0;
        forever #1666666.667    sys_clk_n = ~ sys_clk_n;
    end

endmodule
