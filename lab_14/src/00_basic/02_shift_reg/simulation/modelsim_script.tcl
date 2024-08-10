
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../tb_shift_reg.sv ../../shift_reg.sv

# open the testbench module for simulation
vsim -novopt work.tb_shift_reg

# add all testbench signals to time diagram
add wave -noupdate -radix binary sim:/tb_shift_reg/clk
add wave -noupdate -radix binary sim:/tb_shift_reg/reset_n
add wave -noupdate -radix unsigned sim:/tb_shift_reg/ctrl_code
add wave -noupdate -radix decimal sim:/tb_shift_reg/data_in
add wave -noupdate -radix decimal sim:/tb_shift_reg/data_write

add wave -noupdate -radix decimal sim:/tb_shift_reg/data_read
add wave -noupdate -radix decimal sim:/tb_shift_reg/data_out

# run the simulation
run -all

# expand the signals time diagram
WaveRestoreZoom {0 ns} [simtime]
