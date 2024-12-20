############################################################################
# Contents: Project Build Functions
# 
# Author: Dawid Blom
#
# Date: September 15, 2023
#
# NOTE:
#
############################################################################
#!/bin/bash


readonly PROJECT_VERSION_NUM=0.0.1
readonly PROJECT_VERSION_PREFIX=-v
readonly BIN_SUFFIX=.elf
readonly CMAKE=cmake
readonly BUILD_TYPE="Debug"
readonly TOOLCHAIN=$(pwd)/cmake/CrossToolchain.cmake
readonly BUILD_DIR=build
readonly PROJECT_NAME=$(basename `pwd`)
readonly BIN_DIR=$BUILD_DIR/$PROJECT_NAME
readonly SUPPORTED_BUILD_TYPES=("host" "target" "deploy")

function Build()
{
    local buildtype=$1
    RemoveDirectory $BUILD_DIR
    if [[ $buildtype == ${SUPPORTED_BUILD_TYPES[0]} ]];
    then
        $ECHO "${INFO_COLOR}Building for the host platform${END_COLOR}"
        HostBuild
    elif [[ $buildtype == ${SUPPORTED_BUILD_TYPES[1]} ]];
    then
        if CrossCompilerProvided;
        then
            $ECHO "${INFO_COLOR}Building for the deployment${END_COLOR}"
            TargetBuild
        else
            $ECHO "${ERROR_COLOR}ERROR: Cannot build for 'TARGET', enrivonrment variable 'CROSS_COMPILER' is not set${END_COLOR}"
        fi
    elif [[ $buildtype == ${SUPPORTED_BUILD_TYPES[2]} ]];
    then
        if CrossCompilerProvided;
        then
            $ECHO "${INFO_COLOR}Building for the target platform${END_COLOR}"
            DeployBuild
        else
            $ECHO "${ERROR_COLOR}ERROR: Cannot build for 'DEPLOY', enrivonrment variable 'CROSS_COMPILER' is not set${END_COLOR}"
        fi
    else
        $ECHO "${ERROR_COLOR}ERROR: Build type not supported${END_COLOR}"
    fi
}

function HostBuild()
{
    mkdir $BIN_DIR
    $CMAKE -S . -B $BIN_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
                                                 -DCMAKE_PROJECT_NAME=$PROJECT_NAME \
                                                 -DCMAKE_EXECUTABLE_SUFFIX=$BIN_SUFFIX \
                                                 -DBUILD_PROJECT=ON
    $CMAKE --build $BIN_DIR
}

function TargetBuild()
{
    mkdir -p $BIN_DIR
    $CMAKE -S . -B $BIN_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
                                                 -DCMAKE_PROJECT_NAME=$PROJECT_NAME \
                                                 -DCMAKE_EXECUTABLE_SUFFIX=$BIN_SUFFIX \
                                                 -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
                                                 -DBUILD_PROJECT=ON
    $CMAKE --build $BIN_DIR
}

function DeployBuild()
{
    $CMAKE -S . -B $BIN_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
                                                 -DCMAKE_PROJECT_NAME=$PROJECT_NAME \
                                                 -DCMAKE_PROJECT_VERSION=$PROJECT_VERSION_PREFIX$PROJECT_VERSION_NUM \
                                                 -DCMAKE_EXECUTABLE_SUFFIX=$BIN_SUFFIX \
                                                 -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
                                                 -DBUILD_PROJECT_FOR_DEPLOY=ON \
                                                 -DBUILD_PROJECT=ON
    $CMAKE --build $BIN_DIR

    DEPLOY_DIR=$BUILD_DIR/$PROJECT_NAME$PROJECT_VERSION_PREFIX$PROJECT_VERSION_NUM
    mkdir -p $DEPLOY_DIR
    cp -r $BIN_DIR/$PROJECT_NAME$PROJECT_VERSION_PREFIX$PROJECT_VERSION_NUM$BIN_SUFFIX $DEPLOY_DIR
    tar cvf $DEPLOY_DIR.tar.gz $DEPLOY_DIR
}
