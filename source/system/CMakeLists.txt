############################################################################
#
############################################################################
cmake_minimum_required(VERSION 3.25)
project(target-system VERSION 0.0.1 LANGUAGES CXX C)


file(GLOB RESULT ${PROJECT_SOURCE_DIR}/source)
list(LENGTH RESULT FILES_IN_DIR)
if(${FILES_IN_DIR} GREATER 0)
    add_library(system OBJECT
        ${PROJECT_SOURCE_DIR}/source/SystemTemp.cpp
    )

    target_include_directories(system PRIVATE
        ${PROJECT_SOURCE_DIR}/include/
    )
else ()
    message(STATUS "There are no files in, source/system/include or source/system/source.")
endif()



