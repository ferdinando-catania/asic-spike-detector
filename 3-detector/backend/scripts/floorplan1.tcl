# floorplan1.tcl
# Primo step del floorplan - piazzamento macro

set NETLIST_FILE results/top_netlist.v
set TOP_MODULE top
set CONSTRAINTS_FILE ./src/constraints.sdc

set LIB_FILE /vlsi/tech/nangate45/lib/NangateOpenCellLibrary_typical.lib
set LEF_FILE_TECH  /vlsi/tech/nangate45/lef/NangateOpenCellLibrary.tech.lef
set LEF_FILE_CELLS /vlsi/tech/nangate45/lef/NangateOpenCellLibrary.macro.mod.lef

set TRACK_SCRIPT /vlsi/tech/nangate45/scripts/make_tracks.tcl

read_liberty $LIB_FILE
read_liberty iir/iir.lib 
read_liberty enfasi/enfasi.lib 

read_lef $LEF_FILE_TECH 
read_lef $LEF_FILE_CELLS 
read_lef iir/iir_final.lef 
read_lef enfasi/enfasi_final.lef 

read_verilog $NETLIST_FILE
link_design $TOP_MODULE

read_sdc $CONSTRAINTS_FILE

# Initialize_floorplan: dobbiamo indicare le coordinate di:
# - core (dove verranno alloggiate le celle standard)
# - die (dove arriveranno i terminali del circuito)
# Il die è più grande del core (include una zona "cuscinetto" attorno al core)
#
# Forniremo le coordinate degli estremi (in basso a sinistra ed in alto a destra) 
# del core e del die (espresse in micron).
#
# C'è un ulteriore parametro (-site) che determina l'altezza delle righe in cui allocare 
# le standard-cell. E' definito nel file di tecnologia.

initialize_floorplan -die_area {0 0 200 105} -core_area {0.5 0.5 199.5 104.5} -site FreePDK45_38x28_10R_NP_162NW_34O
source $TRACK_SCRIPT

# Piazzamento dei pins
place_pins -hor_layer metal3 -ver_layer metal2 -random

place_macro -macro_name blocco1 -location {10 15}
place_macro -macro_name blocco2 -location {105 10}

# Piazzamento delle tapcell e delle endcap
tapcell  -distance 17  -tapcell_master "TAPCELL_X1"  -endcap_master "TAPCELL_X1"

write_db   results/floorplan1.odb
gui::show
