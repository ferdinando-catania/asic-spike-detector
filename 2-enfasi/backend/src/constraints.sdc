# file di vincoli

set_cmd_units -time ns -capacitance fF

create_clock -name my_clock  -period 10 clk
set_clock_transition  0.050 my_clock
# jitter: 100ps
set_clock_uncertainty -setup -hold 0.100 my_clock

set_input_delay  -clock my_clock 0.500  [all_inputs -no_clocks]
set_output_delay -clock my_clock 0.500  [all_outputs ]

set_load 3.9 [all_outputs]
set_driving_cell -lib_cell BUF_X1 [all_inputs]

