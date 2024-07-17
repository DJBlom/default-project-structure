############################################################################
# Contents: Algorithms CMakeLists.txt file
# Author: Dawid Blom
# Date: April 12, 2024
#
# NOTE:
############################################################################
cmake_minimum_required(VERSION 3.25)
project(target-algorithms VERSION 0.0.1 LANGUAGES CXX C)


file(GLOB RESULT ${PROJECT_SOURCE_DIR}/include)
list(LENGTH RESULT FILES_IN_DIR)
if(${FILES_IN_DIR} GREATER 0)
    target_include_directories(algorithms
        PRIVATE
        ${PROJECT_SOURCE_DIR}/include
    )
else ()
    message(STATUS "There are no files in, algorithms/source.")
endif()
