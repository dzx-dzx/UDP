 #################################################################################
 ##
 ## l_ethernet_0_everest_gt_reset_controller_0_ooc.xdc 
 ## This xdc is used in Out of Context mode, and currently is just a placeholder
 ##
 #################################################################################



create_clock -period 3.33 [get_ports gtwiz_reset_clk_freerun_in]
create_clock -period 3.33 [get_ports txusrclk2_in]
create_clock -period 3.33 [get_ports rxusrclk2_in]
