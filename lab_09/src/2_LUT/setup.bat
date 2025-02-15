@echo off
setlocal enabledelayedexpansion

:: Определение переменных окружения
set DEFAULT_QUARTUS_ROOT=C:\intelFPGA_lite\20.1

if "%1"=="" (
    :: Try to find Quartus in default location
    if exist "%DEFAULT_QUARTUS_ROOT%\quartus\bin64\quartus.exe" (
        set QUARTUS_ROOT=%DEFAULT_QUARTUS_ROOT%
    ) else (
        echo Warning: Quartus not found in default path, using it anyway: %DEFAULT_QUARTUS_ROOT%
        set QUARTUS_ROOT=%DEFAULT_QUARTUS_ROOT%
    )
) else (
    set QUARTUS_ROOT=%1
)

set PROJECT_NAME=lut
set PATH=%QUARTUS_ROOT%\quartus\bin64;%PATH%
set PATH=%QUARTUS_ROOT%\modelsim_ase\win32aloem;%PATH%
SET TARGET_OS=windows

:: Определение количества процессоров
for /f "tokens=2 delims==" %%i in ('wmic cpu get NumberOfCores /value') do set NUM_CORES=%%i

:: Запуск make с соответствующими параметрами
if "%1"=="" (
    make -j%NUM_CORES% %2 %3 %4 %5 %6 %7 %8 %9 
) else (
    make -j%NUM_CORES% %1 %2 %3 %4 %5 %6 %7 %8 %9 
)