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

if(BUILD_PROJECT_FOR_DEPLOY)
    project(${CMAKE_PROJECT_NAME}${CMAKE_PROJECT_VERSION}${CMAKE_EXECUTABLE_SUFFIX} LANGUAGES CXX C ASM)
    message("Building the project with a version tag")
else()
    project(${CMAKE_PROJECT_NAME}${CMAKE_EXECUTABLE_SUFFIX} LANGUAGES CXX C ASM)
    message("Building the project without any version tag")
endif()

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


if(BUILD_PROJECT)
    add_compile_options(
        -Wall
        -Werror
        -Wextra
        -Wconversion
        $<$<CONFIG:DEBUG>:-g3>
        $<$<CONFIG:DEBUG>:-Og>
    )

    add_compile_definitions(
        $<$<CONFIG:DEBUG>:DEBUG>
        $<$<CONFIG:DEBUG>:TRACE_ENABLED>
    )

    add_executable(${PROJECT_NAME}
        ${CMAKE_SOURCE_DIR}/app/source/Main.cpp
    )

    target_include_directories(${PROJECT_NAME} PRIVATE
        ${CMAKE_SOURCE_DIR}/app/include
        ${CMAKE_SOURCE_DIR}/api/include
        ${CMAKE_SOURCE_DIR}/system/include
        ${CMAKE_SOURCE_DIR}/features/include
        ${CMAKE_SOURCE_DIR}/algorithms/include
    )

    target_link_options(${PROJECT_NAME} PRIVATE
        LINKER:-lpthread
        LINKER:-lrt
    )

    if(IS_DIRECTORY ${CMAKE_SOURCE_DIR}/api)
        add_subdirectory(${CMAKE_SOURCE_DIR}/api)
        target_link_libraries(${PROJECT_NAME} PRIVATE api)
    else()
        message(STATUS "Directory api, does not exist")
    endif()

    if(IS_DIRECTORY ${CMAKE_SOURCE_DIR}/features)
        add_subdirectory(${CMAKE_SOURCE_DIR}/features)
        target_link_libraries(${PROJECT_NAME} PRIVATE features)
    else()
        message(STATUS "Directory features, does not exist")
    endif()

    if(IS_DIRECTORY ${CMAKE_SOURCE_DIR}/system)
        add_subdirectory(${CMAKE_SOURCE_DIR}/system)
        target_link_libraries(${PROJECT_NAME} PRIVATE system)
    else()
        message(STATUS "Directory system, does not exist")
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
