#------------------------------------------------------------------------------
#  (c) Copyright 2020-2021 Xilinx, Inc. All rights reserved.
#
#  This file contains confidential and proprietary information
#  of Xilinx, Inc. and is protected under U.S. and
#  international copyright and other intellectual property
#  laws.
#
#  DISCLAIMER
#  This disclaimer is not a license and does not grant any
#  rights to the materials distributed herewith. Except as
#  otherwise provided in a valid license issued to you by
#  Xilinx, and to the maximum extent permitted by applicable
#  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
#  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
#  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
#  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
#  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
#  (2) Xilinx shall not be liable (whether in contract or tort,
#  including negligence, or under any other theory of
#  liability) for any loss or damage of any kind or nature
#  related to, arising under or in connection with these
#  materials, including for any direct, or any indirect,
#  special, incidental, or consequential loss or damage
#  (including loss of data, profits, goodwill, or any type of
#  loss or damage suffered as a result of any action brought
#  by a third party) even if such damage or loss was
#  reasonably foreseeable or Xilinx had been advised of the
#  possibility of the same.
#
#  CRITICAL APPLICATIONS
#  Xilinx products are not designed or intended to be fail-
#  safe, or for use in any application requiring fail-safe
#  performance, such as life-support or safety devices or
#  systems, Class III medical devices, nuclear facilities,
#  applications related to the deployment of airbags, or any
#  other applications that could lead to death, personal
#  injury, or severe property or environmental damage
#  (individually and collectively, "Critical
#  Applications"). Customer assumes the sole risk and
#  liability of any use of Xilinx products in Critical
#  Applications, subject only to applicable laws and
#  regulations governing limitations on product liability.
#
#  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
#  PART OF THIS FILE AT ALL TIMES.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# L_Ethernet core-level XDC file
# ----------------------------------------------------------------------------------------------------------------------



create_clock -period 6.400 [get_ports gt_refclk_p]
set_false_path -to [get_pins -leaf -of_objects [get_cells -hier *cdc_to* -filter {is_sequential}] -filter {NAME=~*core_cdc*/*/D}]




## Following constraints are needed only for 2013.4 (or till the RX/TX helper clock modules is outside GT). When these modules move into GTWiz, these constraints will come from GT.xdc
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *bit_synchronizer*inst/i_in_meta_reg}]
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_*_reg}]
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *core_gtwiz_userclk_tx_inst_*/*gtwiz_userclk_tx_active_out_reg}]
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *core_gtwiz_userclk_rx_inst_*/*gtwiz_userclk_rx_active_out_reg}]

set_false_path -to [get_pins -of [get_cells -hierarchical -filter {NAME =~ */master_watchdog_*}] -filter {REF_PIN_NAME =~ S}]
set_false_path -to [get_pins -of [get_cells -hierarchical -filter {NAME =~ */master_watchdog_*}] -filter {REF_PIN_NAME =~ R}]

create_waiver -internal -scope -quiet -type CDC -id {CDC-10} -user "l_ethernet" -desc "The CDC-10 warning is waived as it is a level signal. This is safe to ignore" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*_cdc_sync_*reset*/s_out_d4_reg*}] -filter { name =~ *C } ]
set_max_delay -datapath_only -reset_path -from [get_clocks -of_objects [get_pins -of [get_cells -hier -filter {name =~ */gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST*}] -filter { name =~ *TXOUTCLK} ]]\
-to [get_clocks -of_objects [get_pins -of [get_cells -hier -filter {name =~ */gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST*}] -filter { name =~ *RXOUTCLK} ]] 3.2  -quiet
set_max_delay -datapath_only -reset_path -from [get_clocks -of_objects [get_pins -of [get_cells -hier -filter {name =~ */gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST*}] -filter { name =~ *RXOUTCLK} ]]\
-to [get_clocks -of_objects [get_pins -of [get_cells -hier -filter {name =~ */gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST*}] -filter { name =~ *TXOUTCLK} ]] 3.2  -quiet
create_waiver -internal -scope -quiet -type CDC -id {CDC-11} -user "l_ethernet" -desc "The reset signal is synced with different syncers where fan-out is expected and so can be waived" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */rx_reset_done_async_r_*_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*cdc_sync_*done*/s_out_d2_cdc_to_reg*}] -filter { name =~ *D } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-2} -user "l_ethernet" -desc "The CDC-2 warning is waived as it is a level signal. This is safe to ignore" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*_cdc_sync_*reset*/s_out_d4_reg*}] -filter { name =~ *C } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-1} -user "l_ethernet" -desc "This CDC-1 warning is waived as it is on the syncer bus to the watch dog reg, which changes only if a pm_tick is applied. This is safe to ignore" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */i_RX_LANE*/i_SYNC*/i_SYNCER_BUS/busout_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */master_watchdog_*_reg*}] -filter { name =~ * } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-1} -user "l_ethernet" -desc "This CDC-1 warning is waived as it is on the syncer bus to the watch dog reg, which changes only if a pm_tick is applied. This is safe to ignore" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */i_RX_LANE*/*_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */master_watchdog_*_reg*}] -filter { name =~ * } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-11} -user "l_ethernet" -desc "The rest signal is synced with different syncers where fan-out is expected and so can be waived" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */i_pif_registers/rx_reset_out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */reset_pipe_stretch_reg*}] -filter { name =~ *PRE } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/AXI_Reset_*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/*reset_*stretch_reg*}] -filter { name =~ *PRE } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/AXI_Reset*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/i_reset_pipe_*_hot/reset_flop_out_reg*}] -filter { name =~ *D } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/*/reset_flop_out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/*/reset_pipe_stretch_reg*}] -filter { name =~ *PRE } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/stat_*_r_out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/IP2Bus_Data_reg*}] -filter { name =~ *D } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/*_hot/reset_flop_out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/*_syncer/*_reg*}] -filter { name =~ *R } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/ctl_reg_write_hold_reg_inv*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/i_ctl_reg_*x_clk_write_hold_syncer/meta_reg*}] -filter { name =~ *D } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/*_syncer/*_event_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/*_syncer/i_syncpls_*/meta_reg*}] -filter { name =~ *D } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/*x_clk_statsreg_hold_d3_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/i_*x_clk_statsreg_hold_syncer/meta_reg*}] -filter { name =~ *D } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_RX_DESTRIPER/i_RX_VL_ALIGN_MUX/vl_*_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/i_reg_stat_rx_vl_*_syncer/meta_reg*}] -filter { name =~ *D } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/*_reset_out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */*_RESET_AXI_SYNCE*/reset_pipe_stretch_reg*}] -filter { name =~ *PRE } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/STAT_*_r_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/i_reg_STAT_*_syncer/meta_reg*}] -filter { name =~ *D } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/i_AXI_RESET_RX_SYNC/reset_pipe_out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/syncer_reset_from_rx_clk_to_Bus2IP_clk/reset_pipe_stretch_reg*}] -filter { name =~ *PRE } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_RX_LANE_ALIGNER/aligned_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */*_cdc_sync_stat_rx_aligned/s_out_d2_cdc_to_reg*}] -filter { name =~ *D } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/ctl_*x_*_r_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/i_reg_ctl_*x_*_syncer/meta_reg*}] -filter { name =~ *D } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/statsreg_*_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/i_statsreg_*_syncer/meta_reg*}] -filter { name =~ *D } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/i_stats_stat_*_accumulator/statsout_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/IP2Bus_Data_reg*}] -filter { name =~ *D } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */i_RX_DESTRIPER/i_RX_VL_ALIGN_MUX/vl_*_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/i_reg_stat_rx_vl_*_syncer/meta_reg*}] -filter { name =~ *D } ]

set_max_delay 10.000 -datapath_only -from [get_pins -of [get_cells -hier -filter { name =~ */reset_*/rst_in_out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */i_pif_registers/*_syncer/meta_reg*}] -filter { name =~ *D } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-11} -user "l_ethernet" -desc "The reset signal is synced with different syncers where fan-out is expected and so can be waived" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */i_pif_registers/i_reset_pipe_stat_*_hot/reset_flop_out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */i_pif_registers/i_reg_stat_*_syncer/met*_reg*}] -filter { name =~ *R } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-1} -user "l_ethernet" -desc "This CDC-1 warning is waived as it is on the accumulator output to the axi4Lite read data bus output which changes only if a pm_tick is applied. This is safe to ignore" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */i_pif_registers/i_stats_stat_*_accumulator/statsout_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */i_pif_registers/IP2Bus_Data_reg*}] -filter { name =~ *D } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-1} -user "l_ethernet" -desc "This CDC-1 warning is waived as it is on the reset flop logic to the syncer output. This is safe to ignore" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */i_pif_registers/i_reset_pipe_stat_*_hot/reset_flop_out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */i_pif_registers/i_reg_stat_*_syncer/dataout_reg_reg*}] -filter { name =~ *R } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-1} -user "l_ethernet" -desc "This CDC-1 warning is waived as it is on the Sataus to the axi4Lite read data bus output which changes only if a pm_tick is applied. This is safe to ignore" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */i_pif_registers/stat_*x_*_r_out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */i_pif_registers/IP2Bus_Data_reg*}] -filter { name =~ *D } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-1} -user "l_ethernet" -desc "The CDC-1 warning is waived as it is a level signal in reset path. This is safe to ignore" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */i_pif_registers/AXI_Reset_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */i_pif_registers/i_reset_pipe_stat_*_hot/reset_flop_out_reg*}] -filter { name =~ *D } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-11} -user "l_ethernet" -desc "The reset signal is synced with different syncers where fan-out is expected and so can be waived" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */i_RX_CORE/i_SRESETN/reset_pipe_out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */i_RX_CORE/i_LRESET/i_RESET_SYNC*/reset_pipe_stretch_reg*}] -filter { name =~ *PRE } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-10} -user "l_ethernet" -desc "The CDC-10 warning is waived as it is a level signal. This is safe to ignore" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*RX_RESET_AXI_SYNCER/reset_pipe_out_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */i_RX_CORE/i_RX_RESET_SERDES_SYNC/reset_pipe_stretch_reg*}] -filter { name =~ *PRE } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-11} -user "l_ethernet" -desc "The rest signal is synced with different syncers where fan-out is expected and so can be waived" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*cdc_sync_*reset*/s_out_d4_reg*}] -filter { name =~ *C } ]

create_waiver -internal -scope -quiet -type CDC -id {CDC-1} -user "l_ethernet" -desc "The CDC-1 warning is waived as it is a level signal in reset path. This is safe to ignore" -tags "11999"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*cdc_sync_*reset*/s_out_d4_reg*}] -filter { name =~ *C } ]








