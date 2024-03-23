rem recreate a temp folder for all the simulation files

rd /s /q sim
md sim
cd sim

rem compile verilog files for simulation

iverilog -o cnt_updown.out -s testbench ../../cnt_updown.v ../testbench.v

rem run the simulation and finish on $stop

vvp -l cnt_updown.log -n cnt_updown.out

rem show the simulation results in GTKwave

gtkwave dump.vcd

rem return to the parent folder

cd ..
