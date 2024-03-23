rem recreate a temp folder for all the simulation files

rd /s /q sim
md sim
cd sim

rem compile verilog files for simulation

iverilog -o simple_counter.out -s testbench ../../simple_counter.v ../testbench.v

rem run the simulation and finish on $stop

vvp -l simple_counter.log -n simple_counter.out

rem show the simulation results in GTKwave

gtkwave dump.vcd

rem return to the parent folder

cd ..
