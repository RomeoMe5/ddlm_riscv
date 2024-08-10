
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../tb_sys_array_fetcher.sv ../../sys_array_fetcher.sv ../../sys_array_basic.sv ../../sys_array_cell.sv ../../shift_reg.sv

# open the testbench module for simulation
vsim -novopt work.tb_sys_array_fetcher

# add all testbench signals to time diagram
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/clk
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/reset_n
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/weights_load
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/start_comp
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher/input_data
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher/weights_data

add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/ready
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher/out_data

add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher/result_data

# run the simulation
run -all

# expand the signals time diagram
WaveRestoreZoom {0 ns} [simtime]
