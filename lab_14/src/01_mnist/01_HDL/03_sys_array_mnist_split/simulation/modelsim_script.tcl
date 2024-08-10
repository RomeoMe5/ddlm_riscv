
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog +incdir+./ ../tb_sys_array_wrapper_mnist_split.sv ../../sys_array_wrapper_mnist_split.sv ../../sys_array_fetcher_split.sv ../../sys_array_basic_split.sv ../../sys_array_cell.sv ../../shift_reg.sv
vlog +incdir+./ ../../rom.sv ../../seg7_tohex_mnist.sv ../../max_num.sv ../../sys_array_split.sv

# open the testbench module for simulation
vsim -novopt work.tb_sys_array_wrapper_mnist_split

set StdArithNoWarnings 1
set NumericStdNoWarnings 1

# add all testbench signals to time diagram
add wave -noupdate -radix binary      sim:/tb_sys_array_wrapper_mnist_split/clk
add wave -noupdate -radix binary      sim:/tb_sys_array_wrapper_mnist_split/reset_n
add wave -noupdate -radix binary      sim:/tb_sys_array_wrapper_mnist_split/start_comp
add wave -noupdate -radix decimal     sim:/tb_sys_array_wrapper_mnist_split/image_num
add wave -noupdate -radix binary      sim:/tb_sys_array_wrapper_mnist_split/ready
add wave -noupdate -radix hexadecimal sim:/tb_sys_array_wrapper_mnist_split/out_data
add wave -noupdate -radix binary      sim:/tb_sys_array_wrapper_mnist_split/classes

# run the simulation
run -all

# expand the signals time diagram
WaveRestoreZoom {0 ns} [simtime]
