# floorplan2.tcl
# Griglia di alimentazione

read_db results/floorplan1.odb

#### Gliglia di alimentazione
add_global_connection -net VDD -pin_pattern VDD -power
add_global_connection -net VSS -pin_pattern VSS -ground
global_connect

set_voltage_domain -name CORE -power VDD -ground VSS

# Griglia principale
define_pdn_grid -name power_grid -voltage_domains CORE

# Stripes
add_pdn_stripe -grid power_grid -layer metal1 -followpins
pdngen

# Stripes: 
# metal6 a dimensione minima dove non ci sono le macro
# metal8 e metal7 in modo da poter passare sopra le macro
#   Stripes verticali in metal8 dimensione 3x minimo
#   Stripes orizzontali in metal7 dimensione 3x minimo
add_pdn_stripe -grid power_grid -layer metal6 -width 0.28 -spacing 0.28 -offset 4   -pitch 200 -extend_to_boundary
add_pdn_stripe -grid power_grid -layer metal6 -width 0.28 -spacing 0.28 -offset 95  -pitch 200 -extend_to_boundary
add_pdn_stripe -grid power_grid -layer metal6 -width 0.28 -spacing 0.28 -offset 195 -pitch 200 -extend_to_boundary
add_pdn_stripe -grid power_grid -layer metal8 -width 1.2 -pitch 20 -offset 10 -extend_to_boundary
add_pdn_stripe -grid power_grid -layer metal7 -width 1.2 -pitch 20 -offset 10 -extend_to_boundary
add_pdn_connect -grid power_grid -layers {metal1 metal6}
add_pdn_connect -grid power_grid -layers {metal1 metal8}
add_pdn_connect -grid power_grid -layers {metal7 metal8}
add_pdn_connect -grid power_grid -layers {metal7 metal6}
pdngen


# Definiamo ora una seconda griglia di alimentazione per le macro
# e la colleghiamo alla griglia principale tramite il metal7
define_pdn_grid -name macro_grid -voltage_domains CORE -macro -cells {.*}
add_pdn_connect -grid macro_grid -layers {metal6 metal7}
pdngen

report_design_area
write_db   results/floorplan.odb
gui::show

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
