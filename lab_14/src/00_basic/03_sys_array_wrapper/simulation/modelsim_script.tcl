
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../tb_sys_array_wrapper.sv ../../sys_array_wrapper.sv ../../sys_array_fetcher.sv ../../sys_array_basic.sv ../../sys_array_cell.sv ../../seg7_tohex.sv ../../rom.sv ../../shift_reg.sv

# open the testbench module for simulation
vsim -novopt work.tb_sys_array_wrapper

# add all testbench signals to time diagram
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper/clk
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper/reset_n
add wave -noupdate -radix binary sim:/tb_sys_array_wrapper/start_comp
add wave -noupdate -radix decimal sim:/tb_sys_array_wrapper/row
add wave -noupdate -radix decimal sim:/tb_sys_array_wrapper/col
add wave -noupdate -radix binary sim:/tb_sys_array_wrapper/ready
add wave -noupdate -radix hexadecimal sim:/tb_sys_array_wrapper/out_data

# run the simulation
run -all

# expand the signals time diagram
WaveRestoreZoom {0 ns} [simtime]
