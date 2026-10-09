# final.tcl

set CONSTRAINTS_FILE ./src/constraints.sdc
set LIB_FILE /vlsi/tech/nangate45/lib/NangateOpenCellLibrary_typical.lib
set RC_SCRIPT /vlsi/tech/nangate45/scripts/setRC.tcl
set RCX_FILE /vlsi/tech/nangate45/scripts/rcx_patterns.rules

read_liberty $LIB_FILE
read_liberty iir/iir.lib 
read_liberty enfasi/enfasi.lib 

read_db  results/routed.odb
read_sdc $CONSTRAINTS_FILE
source $RC_SCRIPT

extract_parasitics -ext_model_file $RCX_FILE
write_spef results/final.spef
read_spef results/final.spef
report_checks -path_delay max -digits 3 -format full_clock_expanded
report_checks -path_delay min -digits 3 -format full_clock_expanded
report_power
