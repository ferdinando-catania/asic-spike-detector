# final.tcl

set CONSTRAINTS_FILE ./src/constraints.sdc
set LIB_FILE /vlsi/tech/nangate45/lib/NangateOpenCellLibrary_typical.lib
set RC_SCRIPT /vlsi/tech/nangate45/scripts/setRC.tcl
set RCX_FILE /vlsi/tech/nangate45/scripts/rcx_patterns.rules

read_liberty $LIB_FILE
read_db  results/routed.odb
read_sdc $CONSTRAINTS_FILE
source $RC_SCRIPT

extract_parasitics -ext_model_file $RCX_FILE
write_spef results/final.spef
read_spef results/final.spef
report_checks -path_delay max -digits 3 -format full_clock_expanded
report_checks -path_delay min -digits 3 -format full_clock_expanded
report_power

write_def results/iir.def
write_timing_model results/iir.lib
write_abstract_lef results/iir.lef
write_verilog results/iir.v

set a [exec /vlsi/tools/scripts/OpenRoad/lef_patch results/iir.lef results/iir_final.lef]
puts $a
