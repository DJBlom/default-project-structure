############################################################################
# Contents: API CMakeLists.txt file
# Author: Dawid Blom
# Date: October 2, 2023
#
# NOTE:
############################################################################
cmake_minimum_required(VERSION 3.25)
project(target-api VERSION 0.0.1 LANGUAGES CXX C)


file(GLOB RESULT ${PROJECT_SOURCE_DIR}/source)
list(LENGTH RESULT FILES_IN_DIR)
if(${FILES_IN_DIR} GREATER 0)
    add_library(api 
        OBJECT
        ${PROJECT_SOURCE_DIR}/source/BinarySemaphore.cpp
        ${PROJECT_SOURCE_DIR}/source/PrioInheritMutex.cpp
        ${PROJECT_SOURCE_DIR}/source/RealtimeThread.cpp
    )

    target_include_directories(api
        PRIVATE
        ${PROJECT_SOURCE_DIR}/include/
        PUBLIC
        ${CMAKE_SOURCE_DIR}/app/include
    )

    target_link_libraries(api)
else ()
    message(STATUS "There are no files in, api/source.")
endif()
