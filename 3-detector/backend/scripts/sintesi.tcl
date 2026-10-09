# sintesi.tcl
# Script per la sintesi

set VERILOG_FILES {src/top.sv src/detector.sv  src/fsm.sv  src/ser_par.sv}
set TOP_MODULE top
set LIB_FILE /vlsi/tech/nangate45/lib/NangateOpenCellLibrary_typical.lib
set CONSTRAINTS_FILE ./src/constraints.sdc

read_liberty $LIB_FILE
read_liberty iir/iir.lib 
read_liberty enfasi/enfasi.lib 

# Notare l'opzione aggiuntiva, necessaria per i blocchi iir ed enfasi
read_slang  --ignore-unknown-modules   {*}$VERILOG_FILES

# Sintesi generica. Il comando richiede un solo parametro:
# il nome del modulo top-level
syn_generic $TOP_MODULE

# Standard-cell mapping ed ottimizzazione.
# Il comando richiede un solo parametro:
# il nome del file di constraints
syn_map $CONSTRAINTS_FILE

report_area
report_timing
write_netlist results/top_netlist.v
report_area   results/area_report.txt
report_timing results/timing_report.txt


