
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog +incdir+./ ../tb_sys_array_split.sv ../../sys_array_split.sv

# open the testbench module for simulation
vsim -novopt work.tb_sys_array_split

set StdArithNoWarnings 1
set NumericStdNoWarnings 1

# add all testbench signals to time diagram
add wave -noupdate -radix decimal sim:/tb_sys_array_split/clk
add wave -noupdate -radix decimal sim:/tb_sys_array_split/reset_n
add wave -noupdate -radix decimal sim:/tb_sys_array_split/start
add wave -noupdate -radix decimal sim:/tb_sys_array_split/ARRAY_A_W
add wave -noupdate -radix decimal sim:/tb_sys_array_split/ARRAY_A_L
add wave -noupdate -radix decimal sim:/tb_sys_array_split/ARRAY_W_W
add wave -noupdate -radix decimal sim:/tb_sys_array_split/ARRAY_W_L
add wave -noupdate -radix decimal sim:/tb_sys_array_split/ready
add wave -noupdate -radix decimal sim:/tb_sys_array_split/out_data
add wave -noupdate -radix decimal sim:/tb_sys_array_split/first_none
add wave -noupdate -radix decimal sim:/tb_sys_array_split/last

# run the simulation
run -all

# expand the signals time diagram
WaveRestoreZoom {0 ns} [simtime]
