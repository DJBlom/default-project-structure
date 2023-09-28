############################################################################
# Contents: Top Most CMakeLists.txt file
# Author: Dawid Blom
# Date: September 15, 2023
#
# NOTE:
# This file is the main CMakeLists.txt file containing the compiler
# options and definitions, the linker options, path to Main.cpp, and
# the including of all the sub directories where other CMakeLists.txt
# files are found.
############################################################################
cmake_minimum_required(VERSION 3.25)

option(BUILD_PROJECT_FOR_DEPLOY "Build the project for deployment" OFF)
option(BUILD_PROJECT "Build the project" OFF)
option(UNIT_TESTS "Perform unit tests" OFF)
option(STATIC_CODE_ANALYSIS "Perform static code analysis" OFF)
option(CODE_COVERAGE "Perform code coverage" OFF)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


if(BUILD_PROJECT_FOR_DEPLOY)
    project(${CMAKE_PROJECT_NAME}${CMAKE_PROJECT_VERSION}${CMAKE_EXECUTABLE_SUFFIX} LANGUAGES CXX C ASM)
    message("Building the project for deployment")
else()
    project(${CMAKE_PROJECT_NAME}${CMAKE_EXECUTABLE_SUFFIX} LANGUAGES CXX C ASM)
    message("Building the project")
endif()

if(BUILD_PROJECT)
    add_compile_options(
        -Wall
        -Werror
        -Wextra
        $<$<CONFIG:DEBUG>:-g3>
        $<$<CONFIG:DEBUG>:-Og>
    )

    add_compile_definitions(
        $<$<CONFIG:DEBUG>:DEBUG>
        $<$<CONFIG:DEBUG>:TRACE_ENABLED>
    )

    add_executable(${PROJECT_NAME}
        ${CMAKE_SOURCE_DIR}/source/Main.cpp
    )

    target_include_directories(${PROJECT_NAME} PRIVATE
        ${CMAKE_SOURCE_DIR}/source/system/include/
        ${CMAKE_SOURCE_DIR}/source/features/include/
    )

    target_link_options(${PROJECT_NAME} PRIVATE
        LINKER:-lpthread
        LINKER:-lrt
    )

    if(IS_DIRECTORY ${CMAKE_SOURCE_DIR}/source/features)
        add_subdirectory(${CMAKE_SOURCE_DIR}/source/features)
        target_link_libraries(${PROJECT_NAME} PRIVATE features)
    else()
        message(STATUS "Directory source/features, does not exist")
    endif()

    if(IS_DIRECTORY ${CMAKE_SOURCE_DIR}/source/system)
        add_subdirectory(${CMAKE_SOURCE_DIR}/source/system)
        target_link_libraries(${PROJECT_NAME} PRIVATE system)
    else()
        message(STATUS "Directory source/system, does not exist")
    endif()

    if (EXISTS ${CMAKE_OBJDUMP})
        add_custom_command(
            TARGET ${PROJECT_NAME}
            POST_BUILD
            COMMAND ${CMAKE_OBJDUMP} -hS $<TARGET_FILE:${PROJECT_NAME}>
                    >${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_NAME:${PROJECT_NAME}>.S
        )
    else ()
        message(STATUS "'objdump' not found: cannot generate .S file")
    endif()
endif()


if (UNIT_TESTS)
    if(IS_DIRECTORY ${CMAKE_SOURCE_DIR}/test)
        add_subdirectory(${CMAKE_SOURCE_DIR}/test)
    else()
        message(STATUS "Directory test, does not exist")
    endif()
endif()


if (STATIC_CODE_ANALYSIS)
    find_program(CMAKE_CXX_CPPCHECK NAMES cppcheck)
    set(CMAKE_CXX_CPPCHECK "cppcheck")
    if (CMAKE_CXX_CPPCHECK)
        list(APPEND CMAKE_CXX_CPPCHECK
            "--enable=all"
            "--std=c11"
            "--std=c++20"
            "--error-exitcode=1"
            "--platform=unix64"
            "--suppress=missingInclude"
            "${CMAKE_SOURCE_DIR}/source"
        )

        add_custom_target(${PROJECT_NAME}
            COMMAND ${CMAKE_CXX_CPPCHECK}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMENT "Running static code analysis..."
        )
    else ()
        message(STATUS "Requires the static code analysis tool, CppCheck.")
    endif()
endif()


if (CODE_COVERAGE)
    if(IS_DIRECTORY ${CMAKE_SOURCE_DIR}/test)
        add_subdirectory(${CMAKE_SOURCE_DIR}/test)
    else()
        message(STATUS "Directory test, does not exist")
    endif()
endif()


