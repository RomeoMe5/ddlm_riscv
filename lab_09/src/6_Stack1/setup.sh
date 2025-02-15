#!/bin/bash

# Environment variables
DEFAULT_QUARTUS_ROOT="/opt/intelFPGA_lite/20.1"

if [ -z "$1" ]; then
    # Try to find Quartus in default location
    if [ -f "${DEFAULT_QUARTUS_ROOT}/quartus/bin64/quartus" ]; then
        QUARTUS_ROOT=$DEFAULT_QUARTUS_ROOT
    else
        echo "Warning: Quartus not found in default path, using it anyway: ${DEFAULT_QUARTUS_ROOT}"
        QUARTUS_ROOT=$DEFAULT_QUARTUS_ROOT
    fi
else
    QUARTUS_ROOT=$1
fi

export PROJECT_NAME=stack1
export PATH="${QUARTUS_ROOT}/quartus/bin64:${PATH}"
export PATH="${QUARTUS_ROOT}/modelsim_ase/linuxaloem:${PATH}"
export TARGET_OS=linux

# Get number of CPU cores
NUM_CORES=$(nproc)

# Run make with parameters
if [ -z "$1" ]; then
    make -j${NUM_CORES} "${@:2}"
else
    make -j${NUM_CORES} "$@"
fi 