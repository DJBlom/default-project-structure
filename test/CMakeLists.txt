############################################################################
# Contents: Unit Test CMakeLists.txt file
# Author: Dawid Blom
# Date: September 15, 2023
# 
# NOTE: 
# This file is the unit test CMakeLists.txt file containing the compiler
# options and definitions, the link options and libraries, the path to the
# main test runner file MainTest.cpp and all the test, mock files, 
# and project source files.
############################################################################
cmake_minimum_required(VERSION 3.25)
project(target-tests VERSION 0.0.1 LANGUAGES CXX C)


if(DEFINED ENV{CPPUTEST_HOME})
    add_compile_options(
        -Wall
        -Werror
        -Wextra
        --coverage
        -fprofile-arcs
        -ftest-coverage
        $<$<CONFIG:DEBUG>:-g3>
        $<$<CONFIG:DEBUG>:-Og>
    )

    include_directories(tests INTERFACE
        $ENV{CPPUTEST_HOME}/include
    )

    link_directories(tests INTERFACE
        $ENV{CPPUTEST_HOME}/lib
    )

    add_executable(tests
        ${PROJECT_SOURCE_DIR}/MainTest.cpp
        ${PROJECT_SOURCE_DIR}/tests/Template.cpp
    )

    target_link_libraries(tests 
        gcov
        CppUTest
        CppUTestExt
    )

    add_custom_command(TARGET tests POST_BUILD
        COMMENT "Running Unit Tests..." 
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        COMMAND ./tests -c -v
    )
else()
    message(STATUS "Requires the unit testing framework, CppuTest.")
endif()
