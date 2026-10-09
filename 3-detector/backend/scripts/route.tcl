# route1.tcl

set CONSTRAINTS_FILE ./src/constraints.sdc
set LIB_FILE /vlsi/tech/nangate45/lib/NangateOpenCellLibrary_typical.lib
set RC_SCRIPT /vlsi/tech/nangate45/scripts/setRC.tcl

read_liberty $LIB_FILE
read_liberty iir/iir.lib 
read_liberty enfasi/enfasi.lib 

read_db results/cts.odb
read_sdc $CONSTRAINTS_FILE

source $RC_SCRIPT

# non uso metal 6-10 che implicano wires molto larghe 
set_routing_layers -signal metal1-metal5 -clock metal1-metal4
global_route -verbose

set_propagated_clock  [all_clocks]
estimate_parasitics -global_routing
report_checks -path_delay max -digits 3 -format full_clock_expanded
report_checks -path_delay min -digits 3 -format full_clock_expanded

# detailed routing
detailed_route -bottom_routing_layer metal1 -top_routing_layer metal5

filler_placement {FILLCELL_X1 FILLCELL_X2 FILLCELL_X4 FILLCELL_X8 FILLCELL_X16 FILLCELL_X32}
check_placement

drt::check_drc -output_file noname.txt

write_db results/routed.odb
gui::show

