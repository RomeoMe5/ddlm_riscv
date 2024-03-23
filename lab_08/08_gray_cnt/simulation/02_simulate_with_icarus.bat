rem recreate a temp folder for all the simulation files

rd /s /q sim
md sim
cd sim

rem compile verilog files for simulation

iverilog -o gray_cnt.out -s testbench ../../gray_cnt.v ../testbench.v

rem run the simulation and finish on $stop

vvp -l gray_cnt.log -n gray_cnt.out

rem show the simulation results in GTKwave

gtkwave dump.vcd

rem return to the parent folder

cd ..
