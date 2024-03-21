rem recreate a temp folder for all the simulation files

rd /s /q sim
md sim
cd sim

rem compile verilog files for simulation

iverilog -o cnt_load.out -s testbench ../../cnt_load.v ../testbench.v

rem run the simulation and finish on $stop

vvp -l cnt_load.log -n cnt_load.out

rem show the simulation results in GTKwave

gtkwave dump.vcd

rem return to the parent folder

cd ..
