rem recreate a temp folder for all the simulation files

rd /s /q sim
md sim
cd sim

rem compile verilog files for simulation

iverilog -o crc_ser.out -s testbench ../../crc_ser.v ../testbench.v

rem run the simulation and finish on $stop

vvp -l crc_ser.log -n crc_ser.out

rem show the simulation results in GTKwave

gtkwave dump.vcd

rem return to the parent folder

cd ..
