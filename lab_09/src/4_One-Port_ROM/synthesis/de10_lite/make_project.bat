cd %~dp0
rd /s /qproject\
mkdir project\
copy *.v project\
copy *.sdc project\
copy *.qpf project\
copy *.qsf project\
copy ..\..\rom.txt ..\
