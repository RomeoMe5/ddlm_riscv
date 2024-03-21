# create modelsim working library

vlib work

# compile all the Verilog sources

vlog ../../cnt_div.v
vlog ../testbench.v


# open the testbench module for simulation

vsim -novopt work.testbench

# add all testbench signals to time diagram

# add wave -radix hex sim:/testbench/*

add wave -radix bin sim:/testbench/clk_in
add wave -radix bin sim:/testbench/rst_n
add wave -radix bin sim:/testbench/clk_out

# run the simulation

run -all

# expand the signals time diagram

wave zoom full
