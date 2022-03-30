set outputDir ./output             

file mkdir $outputDir

set_part xcvu13p-fhgb2104-2-i

read_verilog [glob ./Sources/*.v]
read_ip ./Sources/ip/axis_512to256/axis_512to256.xci
read_ip ./Sources/ip/axis_clock_converter/axis_clock_converter.xci
read_ip ./Sources/ip/ila_0/ila_0.xci
read_ip ./Sources/ip/axis_data_fifo_0/axis_data_fifo_0.xci
read_ip ./Sources/ip/axis_256to512/axis_256to512.xci
read_ip ./Sources/ip/vio_0/vio_0.xci
read_ip ./Sources/ip/clk_wiz_0/clk_wiz_0.xci
read_ip ./Sources/ip/l_ethernet_0/l_ethernet_0.xci
read_ip ./Sources/ip/l_ethernet_0_1/l_ethernet_0_1.xci
read_xdc ./Sources/40g_udp.xdc


synth_design -top udp_40G_TOP -part xcvu13p-fhgb2104-2-i
write_checkpoint -force $outputDir/post_synth
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_power -file $outputDir/post_synth_power.rpt


opt_design
place_design
phys_opt_design
write_checkpoint -force $outputDir/post_place
report_timing_summary -file $outputDir/post_place_timing_summary.rpt

route_design
write_checkpoint -force $outputDir/post_route
report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_timing -sort_by group -max_paths 100 -path_type summary -file $outputDir/post_route_timing.rpt
report_clock_utilization -file $outputDir/post_route_util.rpt
report_power -file $outputDir/post_imp_drc.rpt
report_drc -file $outputDir/post_impl_drc.rpt
write_verilog -force $outputDir/udp_40G_TOP_impl_netlist.v
write_xdc -no_fixed_only -force $outputDir/udp_40G_TOP_impl.xdc

write_bitstream -force outputDir/udp_40G_TOP.bit


save_project_as sim -force
set_property top MAC_40G_tb [get_fileset sim_1]
launch_simulation -simset sim_1 -mode behavioral
run 1000us
quit
