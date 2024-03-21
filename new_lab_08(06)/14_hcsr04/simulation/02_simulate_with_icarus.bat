rem recreate a temp folder for all the simulation files

rd /s /q sim
md sim
cd sim

rem compile verilog files for simulation

iverilog -o hcsr04.out -s testbench ../../hcsr04.v ../testbench.v

rem run the simulation and finish on $stop

vvp -l hcsr04.log -n hcsr04.out

rem show the simulation results in GTKwave

gtkwave dump.vcd

rem return to the parent folder

cd ..
