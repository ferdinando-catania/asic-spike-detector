# floorplan.tcl

set NETLIST_FILE results/enfasi_netlist.v
set TOP_MODULE enfasi
set CONSTRAINTS_FILE ./src/constraints.sdc

set LIB_FILE /vlsi/tech/nangate45/lib/NangateOpenCellLibrary_typical.lib
set LEF_FILE_TECH  /vlsi/tech/nangate45/lef/NangateOpenCellLibrary.tech.lef
set LEF_FILE_CELLS /vlsi/tech/nangate45/lef/NangateOpenCellLibrary.macro.mod.lef

set TRACK_SCRIPT /vlsi/tech/nangate45/scripts/make_tracks.tcl

read_liberty $LIB_FILE
read_lef $LEF_FILE_TECH 
read_lef $LEF_FILE_CELLS 

read_verilog $NETLIST_FILE
link_design $TOP_MODULE

read_sdc $CONSTRAINTS_FILE

# Argomenti di initialize_floorplan:
# Dobbiamo indicare le coordinate di:
# - core (dove verranno alloggiate le celle standard)
# - die (dove arriveranno i terminali del circuito)
# Il die è più grande del core (include una zona "cuscinetto" attorno al core)
#
# Forniremo le coordinate degli estremi (in basso a sinistra ed in alto a destra) 
# del core e del die (espresse in micron).
#
# C'è un ulteriore parametro (-site) che determina l'altezza delle righe in cui allocare 
# le standard-cell. E' definito nel file di tecnologia.

initialize_floorplan -die_area {0 0 85 85} -core_area {0.5 0.5 84.5 84.5} -site FreePDK45_38x28_10R_NP_162NW_34O
source $TRACK_SCRIPT

# Piazzamento dei pins
# -hor_layers -ver_layers : i metal da utilizzare per i pin orizzontali e verticali
# -random : piazza i pin in modo casuale
# E' possibile specificare singolarmente dove piazzare i vari pin, ma per semplicità,
# non lo faremo

place_pins -hor_layer metal3 -ver_layer metal2 -random

# Piazzamento delle tapcell e delle endcap
# Le tapcells includono solo i collegamenti di substrato, per prevenire fenomeni di latchup
# (in alcune librerie # le celle non hanno le prese di substrato, al fine di ottimizzare l'area).
# Vengono distribuite in modo uniforme all'interno del core, in ogni riga di celle
# Le endcap sono celle che vengono piazzate ai bordi di ogni riga. 
# Servono per evitare problemi di DRC.
# In alcuni casi includono dei condensatori di decoupling.
# Nella tecnologia considerata, le tapcell e le endcap sono uguali

tapcell  -distance 17  -tapcell_master "TAPCELL_X1"  -endcap_master "TAPCELL_X1"
# In effetti si potrebbe mettere una distanza molto maggiore...


#### Gliglia di alimentazione
# Definiamo innanzitutto i nomi dei segnali di alimentazione e di massa
# I pin delle celle standard si chiamano VDD e VSS e noi continuiamo a chiamarli allo stesso modo
add_global_connection -net VDD -pin_pattern VDD -power
add_global_connection -net VSS -pin_pattern VSS -ground
global_connect

# In generale ci possono essere più alimentazioni in diverse parti del chip.
# Nel nostro caso c'è un solo voltage domain, chiamato CORE.
# I terminali di alimentazione si chiamano VDD e VSS:
set_voltage_domain -name CORE -power VDD -ground VSS

# Bisogna poi dare un nome alla griglia di alimentazione (ce ne potrebbe essere più di una)
# La chiamiamo power_grid
define_pdn_grid -name power_grid -voltage_domains CORE

# Possiamo ora definire le linee di alimentazione e massa (stripes)
# che compongono la griglia di alimentazione
#
# Innanzitutto inseriamo delle stripe sulle righe delle celle standard, per collegare
# le alimentazioni ai pin delle celle. 
add_pdn_stripe -grid power_grid -layer metal1 -followpins
# Aggiungiamo quindi le stripe verticali
# Utilizzo metal6 di dimensione 4x minimo
add_pdn_stripe -grid power_grid -layer metal6 -width 0.56 -pitch 10 -offset 5 -extend_to_boundary
add_pdn_connect -grid power_grid -layers {metal1 metal6}
pdngen


# metal1: WIDTH 0.07; PITCH 0.14 ;
# metal2: WIDTH 0.07; PITCH 0.19 ;
# metal3: WIDTH 0.07; PITCH 0.14 ;
# metal4: WIDTH 0.14; PITCH 0.28 ;
# metal5: WIDTH 0.14; PITCH 0.28 ;
# metal6: WIDTH 0.14; PITCH 0.28 ;
# metal7: WIDTH 0.4 ; PITCH 0.8 ; 
# metal8: WIDTH 0.4 ; PITCH 0.8 ;
# metal9: WIDTH 0.8 ; PITCH 1.6 ;
# metal10:WIDTH 0.8 ; PITCH 1.6 ;

report_cell_usage -verbose
report_design_area

write_db   results/floorplan.odb
gui::show

