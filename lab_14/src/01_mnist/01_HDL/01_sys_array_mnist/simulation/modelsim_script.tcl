
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog +incdir+./ ../tb_sys_array_wrapper_mnist.sv ../../sys_array_wrapper_mnist.sv ../../sys_array_fetcher.sv ../../sys_array_basic.sv ../../sys_array_cell.sv ../../shift_reg.sv
vlog +incdir+./ ../../rom.sv ../../seg7_tohex_mnist.sv ../../max_num.sv

# open the testbench module for simulation
vsim -novopt work.tb_sys_array_wrapper_mnist

set StdArithNoWarnings 1
set NumericStdNoWarnings 1

# add all testbench signals to time diagram
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/clk
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/reset_n
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/load_params
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/start_comp
add wave -noupdate -radix decimal sim:/tb_sys_array_wrapper_mnist/image_num
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/ready
add wave -noupdate -radix hexadecimal sim:/tb_sys_array_wrapper_mnist/out_data
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/classes

# run the simulation
run -all

# expand the signals time diagram
WaveRestoreZoom {0 ns} [simtime]
