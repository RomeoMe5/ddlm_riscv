
rem recreate a temp folder for all the simulation files
rd /s /q sim
md sim
cd sim

rem compile verilog files for simulation
iverilog -s testbench ..\testbench.v ..\..\nbit_4in1_demux.v 
 pause

rem run the simulation
vvp -la.lst -n a.out -vcd

rem show the simulation results in GTKwave
gtkwave dump.vcd

rem return to the parent folder
cd ..
