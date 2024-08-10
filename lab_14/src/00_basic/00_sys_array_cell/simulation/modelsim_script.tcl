
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../tb_sys_array_cell.sv ../../sys_array_cell.sv

# open the testbench module for simulation
vsim -novopt work.tb_sys_array_cell

# add all testbench signals to time diagram
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/clk
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/reset_n
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/weight_load
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/input_data
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/prop_data
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/weights
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/out_data
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/prop_output

# симуляция и отображение результатов
run -all

#wave zoom full
WaveRestoreZoom {0 ns} [simtime]
