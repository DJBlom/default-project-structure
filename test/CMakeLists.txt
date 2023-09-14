############################################################################
#
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

    include_directories(tests PRIVATE
        $ENV{CPPUTEST_HOME}/include
    )

    link_directories(tests 
        $ENV{CPPUTEST_HOME}/lib
    )

    add_executable(tests
        ${PROJECT_SOURCE_DIR}/MainTest.cpp
        ${PROJECT_SOURCE_DIR}/tests/Template.cpp
    )

    target_link_libraries(tests 
        #lcov
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
    message(STATUS "Requires CppuTest to be installed")
endif()
