if exist Project rmdir /S /Q Project
mkdir Project
cd Project

mkdir sim
mkdir tb

cd..

copy sim Project\sim
copy Top.sv Project
copy tb.v Project\tb

copy keyboard_interface.v Project\tb
copy ps2_command_in.v Project\tb
copy ps2_data_out.v Project\tb

copy *.hex Project


cd..
copy *.sv DeSim\Project