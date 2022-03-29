set_property PACKAGE_PIN H19 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_p]

set_property PACKAGE_PIN M11 [get_ports gt_ref_clk_p_40MAC_0]
##set_property PACKAGE_PIN T11 [get_ports gt_ref_clk_p_40MAC_0]
create_clock -period 6.400 [get_ports gt_ref_clk_p_40MAC_0]

##40GMAC_1

##set_property PACKAGE_PIN H19 [get_ports sys_clk_p_40MAC_1]
##set_property PACKAGE_PIN H18 [get_ports sys_clk_n_40MAC_1]
##set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_p_40MAC_1]
##set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_n_40MAC_1]

set_property PACKAGE_PIN Y11 [get_ports gt_ref_clk_p_40MAC_1]
##set_property PACKAGE_PIN Y10 [get_ports gt_ref_clk_n_40MAC_1]
create_clock -period 6.400 [get_ports gt_ref_clk_p_40MAC_1]

set_clock_groups -asynchronous -group [get_clocks  -include_generated_clocks sys_clk_p]  -group [get_clocks -include_generated_clocks gt_ref_clk_p_40MAC_0] -group [get_clocks -include_generated_clocks gt_ref_clk_p_40MAC_1] -group [get_clocks *clk_out1*] -group [get_clocks *clk_out2*]

set_property PACKAGE_PIN P2 [get_ports {gt_rxp_in_40MAC_0[3]}]
set_property PACKAGE_PIN P1 [get_ports {gt_rxn_in_40MAC_0[3]}]
set_property PACKAGE_PIN P7 [get_ports {gt_txp_out_40MAC_0[3]}]
set_property PACKAGE_PIN P6 [get_ports {gt_txn_out_40MAC_0[3]}]

set_property PACKAGE_PIN R4 [get_ports {gt_rxp_in_40MAC_0[2]}]
set_property PACKAGE_PIN R3 [get_ports {gt_rxn_in_40MAC_0[2]}]
set_property PACKAGE_PIN R9 [get_ports {gt_txp_out_40MAC_0[2]}]
set_property PACKAGE_PIN R8 [get_ports {gt_txn_out_40MAC_0[2]}]


set_property PACKAGE_PIN T2 [get_ports {gt_rxp_in_40MAC_0[1]}]
set_property PACKAGE_PIN T1 [get_ports {gt_rxn_in_40MAC_0[1]}]
set_property PACKAGE_PIN T7 [get_ports {gt_txp_out_40MAC_0[1]}]
set_property PACKAGE_PIN T6 [get_ports {gt_txn_out_40MAC_0[1]}]

set_property PACKAGE_PIN U4 [get_ports {gt_rxp_in_40MAC_0[0]}]
set_property PACKAGE_PIN U3 [get_ports {gt_rxn_in_40MAC_0[0]}]
set_property PACKAGE_PIN U9 [get_ports {gt_txp_out_40MAC_0[0]}]
set_property PACKAGE_PIN U8 [get_ports {gt_txn_out_40MAC_0[0]}]


##40GAMC_1

set_property PACKAGE_PIN V2 [get_ports {gt_rxp_in_40MAC_1[3]}]
set_property PACKAGE_PIN V1 [get_ports {gt_rxn_in_40MAC_1[3]}]
set_property PACKAGE_PIN V7 [get_ports {gt_txp_out_40MAC_1[3]}]
set_property PACKAGE_PIN V6 [get_ports {gt_txn_out_40MAC_1[3]}]

set_property PACKAGE_PIN W4 [get_ports {gt_rxp_in_40MAC_1[2]}]
set_property PACKAGE_PIN W3 [get_ports {gt_rxn_in_40MAC_1[2]}]
set_property PACKAGE_PIN W9 [get_ports {gt_txp_out_40MAC_1[2]}]
set_property PACKAGE_PIN W8 [get_ports {gt_txn_out_40MAC_1[2]}]

set_property PACKAGE_PIN Y2 [get_ports {gt_rxp_in_40MAC_1[1]}]
set_property PACKAGE_PIN Y1 [get_ports {gt_rxn_in_40MAC_1[1]}]
set_property PACKAGE_PIN Y7 [get_ports {gt_txp_out_40MAC_1[1]}]
set_property PACKAGE_PIN Y6 [get_ports {gt_txn_out_40MAC_1[1]}]

set_property PACKAGE_PIN AA4 [get_ports {gt_rxp_in_40MAC_1[0]}]
set_property PACKAGE_PIN AA3 [get_ports {gt_rxn_in_40MAC_1[0]}]
set_property PACKAGE_PIN AA9 [get_ports {gt_txp_out_40MAC_1[0]}]
set_property PACKAGE_PIN AA8 [get_ports {gt_txn_out_40MAC_1[0]}]