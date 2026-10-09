# cts.tcl

set CONSTRAINTS_FILE ./src/constraints.sdc
set LIB_FILE /vlsi/tech/nangate45/lib/NangateOpenCellLibrary_typical.lib
set RC_SCRIPT /vlsi/tech/nangate45/scripts/setRC.tcl

read_liberty $LIB_FILE
read_db results/placement.odb
read_sdc $CONSTRAINTS_FILE
source $RC_SCRIPT

clock_tree_synthesis -buf_list {BUF_X8 BUF_X4 BUF_X2 BUF_X1} -root_buf BUF_X8
report_cts
report_clock_latency
report_clock_skew

estimate_parasitics -placement
set_propagated_clock clk
report_checks -path_delay min  -digits 3 -format full_clock_expanded

repair_timing -hold -hold_margin 0.10 -verbose
report_checks -path_delay min -digits 3 -format full_clock_expanded

# Ora devo piazzare definitivamente i buffers
detailed_placement
improve_placement -max_displacement 10
check_placement -verbose

write_db   results/cts.odb
gui::show
