
# create modelsim working library

vlib work

# compile all the Verilog sources

vlog ../../crc_ser.v
vlog ../testbench.v

# open the testbench module for simulation

vsim -novopt work.testbench

# add all testbench signals to time diagram


add wave -radix bin sim:/testbench/clk
add wave -radix bin sim:/testbench/rst_n
add wave -radix bin sim:/testbench/crc_en
add wave -radix bin sim:/testbench/data
add wave -radix hex sim:/testbench/buff
add wave -radix hex sim:/testbench/crc5


# run the simulation

run -all

# expand the signals time diagram

wave zoom full
