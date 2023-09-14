############################################################################
#
############################################################################
cmake_minimum_required(VERSION 3.25)
project(target-features VERSION 0.0.1 LANGUAGES CXX C)


file(GLOB RESULT ${PROJECT_SOURCE_DIR}/source)
list(LENGTH RESULT FILES_IN_DIR)
if(${FILES_IN_DIR} GREATER 0)
    add_library(features OBJECT
        ${PROJECT_SOURCE_DIR}/source/FeatureTemp.cpp
    )

    target_include_directories(features PRIVATE
        ${PROJECT_SOURCE_DIR}/include/
    )
else ()
    message(STATUS "There are no files in, source/features/include or source/features/source.")
endif()



