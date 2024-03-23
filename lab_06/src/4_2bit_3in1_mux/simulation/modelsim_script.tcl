
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../../bit2_3in1_mux.v 
vlog  ../testbench.v 


# open the testbench module for simulation
vsim work.testbench

# add all testbench signals to time diagram
add wave sim:/testbench/*

# run the simulation
run -all

# expand the signals time diagram
wave zoom full
