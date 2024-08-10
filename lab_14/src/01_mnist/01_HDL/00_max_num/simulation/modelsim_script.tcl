
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog  ../tb_max_num.sv ../../max_num.sv

# open the testbench module for simulation
vsim -novopt work.tb_max_num

# add all testbench signals to time diagram
add wave -noupdate -radix binary sim:/tb_max_num/clk
add wave -noupdate -radix binary sim:/tb_max_num/reset_n
add wave -noupdate -radix binary sim:/tb_max_num/start
add wave -noupdate -radix decimal sim:/tb_max_num/matrix
add wave -noupdate -radix binary sim:/tb_max_num/classes
add wave -noupdate -radix binary sim:/tb_max_num/ready

add wave -noupdate -radix decimal sim:/tb_max_num/max_num0/half_max
add wave -noupdate -radix binary sim:/tb_max_num/max_num0/half_max_reg
add wave -noupdate -radix decimal sim:/tb_max_num/max_num0/three_max
add wave -noupdate -radix binary sim:/tb_max_num/max_num0/three_max_reg
add wave -noupdate -radix decimal sim:/tb_max_num/max_num0/i_var
add wave -noupdate -radix decimal sim:/tb_max_num/max_num0/maximum

# run the simulation
run -all

# expand the signals time diagram
WaveRestoreZoom {0 ns} [simtime]
