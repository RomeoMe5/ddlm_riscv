
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../../nbit_8in1_selector.v 
vlog  ../testbench.v 


# open the testbench module for simulation
vsim work.testbench

# add all testbench signals to time diagram
add wave sim:/testbench/*

# run the simulation
run -all

# expand the signals time diagram
wave zoom full
