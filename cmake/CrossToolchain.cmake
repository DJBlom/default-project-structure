############################################################################
# Contents: Cross Compiler Toolchain File
# Author: Dawid Blom
# Date: September 27, 2023
# 
# NOTE: 
# This file just sets the path to the corss compiler toolchain binaries
# required for compilation.
############################################################################
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION RPI-3B)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CROSS_COMPILER $ENV{CROSS_COMPILER})
if(CROSS_COMPILER)
    message("Cross compiler found")
    set(CMAKE_C_COMPILER $ENV{CROSS_COMPILER}/aarch64-rpi3-linux-gnu-gcc)
    set(CMAKE_CXX_COMPILER $ENV{CROSS_COMPILER}/aarch64-rpi3-linux-gnu-g++)
else()
    message("No cross compiler found")
endif()
