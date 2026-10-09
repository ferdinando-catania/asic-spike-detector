# place.tcl

set TOP_MODULE enfasi
set CONSTRAINTS_FILE ./src/constraints.sdc
set LIB_FILE /vlsi/tech/nangate45/lib/NangateOpenCellLibrary_typical.lib
set RC_SCRIPT /vlsi/tech/nangate45/scripts/setRC.tcl

read_liberty $LIB_FILE
read_db results/floorplan.odb
read_sdc $CONSTRAINTS_FILE
source $RC_SCRIPT

report_design_area 
# metto il place_density coerente con report_design_area
global_placement -density 0.75

# Una prima ottimizzazione per aggiustare hold time
estimate_parasitics -placement
set_propagated_clock clk
report_checks -path_delay max -digits 3 -format full_clock_expanded -field capacitance
report_checks -path_delay min  -digits 3 -format full_clock_expanded
repair_timing -hold -hold_margin 0.10 -verbose
report_checks -path_delay min -digits 3 -format full_clock_expanded
#improve_placement -max_displacement 20
#improve_placement -max_displacement 10

# placement dettagliato
detailed_placement -max_displacement 20
optimize_mirroring
improve_placement -max_displacement 10
check_placement -verbose

write_db results/placement.odb

report_cell_usage -verbose

gui::show

#############################################################################
