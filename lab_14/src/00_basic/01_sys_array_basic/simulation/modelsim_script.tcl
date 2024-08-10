
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../tb_sys_array_basic.sv ../../sys_array_basic.sv ../../sys_array_cell.sv

# open the testbench module for simulation
vsim -novopt work.tb_sys_array_basic

# add all testbench signals to time diagram
add wave -noupdate -radix binary  sim:/tb_sys_array_basic/clk
add wave -noupdate -radix binary  sim:/tb_sys_array_basic/reset_n
add wave -noupdate -radix binary  sim:/tb_sys_array_basic/weights_load
add wave -noupdate -radix decimal sim:/tb_sys_array_basic/inputs_test
add wave -noupdate -radix decimal sim:/tb_sys_array_basic/weight_test
add wave -noupdate -radix decimal sim:/tb_sys_array_basic/outputs_test

# run the simulation
run -all

# expand the signals time diagram
WaveRestoreZoom {0 ns} [simtime]
