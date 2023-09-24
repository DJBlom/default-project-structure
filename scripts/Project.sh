############################################################################
# Contents: Top Most CMakeLists.txt file
# Author: Dawid Blom
# Date: September 15, 2023
# 
# NOTE: 
# This file is a utility file used to build and test the project base on
# arguments passed to it (run ./scrips/Project.sh -h, for a list of 
# arguments). It provides the capability to run your unit tests, static
# code analysis, code coverage, get a line project's line count, and build
# your project.
############################################################################
#!/bin/bash

CMAKE=cmake
BIN_DIR=project
TEST_DIR=test
BUILD_TYPE="Debug"
BUILD_DIR=$(pwd)/build

rm -rf $BUILD_DIR/*

Build()
{
    mkdir -p $BUILD_DIR/$BIN_DIR
    $CMAKE -S . -B $BUILD_DIR/$BIN_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DBUILD_PROJECT=ON 
    $CMAKE --build $BUILD_DIR/$BIN_DIR
}

Test()
{
    mkdir -p $BUILD_DIR/$TEST_DIR
    $CMAKE -S . -B $BUILD_DIR/$TEST_DIR --warn-uninitialized -DUNIT_TESTS=ON 
    $CMAKE --build $BUILD_DIR/$TEST_DIR
}

Analyze()
{
    mkdir -p $BUILD_DIR/$BIN_DIR
    $CMAKE -S . -B $BUILD_DIR/$BIN_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DBUILD_PROJECT=ON -DSTATIC_CODE_ANALYSIS=ON
    $CMAKE --build $BUILD_DIR/$BIN_DIR
    cd $BUILD_DIR/$BIN_DIR
    make analysis
}

Coverage()
{
    mkdir -p $BUILD_DIR/$TEST_DIR
    $CMAKE -S . -B $BUILD_DIR/$TEST_DIR --warn-uninitialized -DCODE_COVERAGE=ON 
    $CMAKE --build $BUILD_DIR/$TEST_DIR
    lcov --rc lcov_branch_coverage=1 --directory . --capture --output-file $BUILD_DIR/$TEST_DIR/coverage.info
    lcov --rc lcov_branch_coverage=1 --remove $BUILD_DIR/$TEST_DIR/coverage.info '/opt/*' --output-file $BUILD_DIR/$TEST_DIR/coverage.info
    lcov --rc lcov_branch_coverage=1 --list $BUILD_DIR/$TEST_DIR/coverage.info > $BUILD_DIR/$TEST_DIR/coverage.txt
    total_coverage=$(grep -F "Total:" $BUILD_DIR/$TEST_DIR/coverage.txt | tr -d ' ')

    # Extract the line coverage percentage
    line_coverage=($(echo "$total_coverage" | awk -F '|' '{print $2}' | awk -F '%' '{print $1}' ))
    line_coverage=$(printf "%.0f" "$line_coverage")

    # Extract the function coverage percentage
    function_coverage=($(echo "$total_coverage" | awk -F '|' '{print $3}' | awk -F '%' '{print $1}'))
    function_coverage=$(printf "%.0f" "$function_coverage")

    # Extract the branch coverage percentage
    branch_coverage=($(echo "$total_coverage" | awk -F '|' '{print $4}' | awk -F '%' '{print $1}'))
    branch_coverage=$(printf "%.0f" "$branch_coverage")

    total_percentage=$(((($branch_coverage + $line_coverage + $function_coverage)) / 3))

    threshold=90
    if [[ $total_percentage -lt $threshold ]];
    then
        echo " "
        echo -e "\e[31mFAILED: Total coverage should be ${threshold}.0% or higher. Currently, it is ${total_percentage}.0%. \e[0m"
        exit 1
    else
        echo " "
        echo -e "\e[32mPASSED: Total coverage is: ${total_percentage}.0% \e[0m"
        exit 0
    fi
}

LineCount()
{
    echo
    echo "Total project line count."
    cloc .
    echo 
}

InstallRequirements()
{
    DNF=$(which dnf)
    specific_packages=(cloc lcov cppcheck)

    if [[ $DNF ]];
    then
        sudo dnf -y install $specific_packages 
        sudo dnf -y group install "C Development Tools and Libraries"
    else
        echo "Your distribution is not unknown"
    fi

    if [[ -z "${CPPUTEST_HOME}" ]];
    then
        cd /opt/
        git clone https://github.com/cpputest/cpputest.git
        echo "export CPPUTEST_HOME=/opt/cpputest"
    else
        echo "CppUTest is installed"
    fi
}

Help()
{
    echo
    echo "Description:"
    echo "This script is used to build, test, analyze, and provide code coverage on a project."
    echo
    echo "Usage: ./Project.sh [-b|t|a|c|i|h]"
    echo "options:"
    echo "     -b    Build the project"
    echo "     -t    Execute unit test"
    echo "     -a    Run static code analysis"
    echo "     -c    Generate a code coverage report"
    echo "     -l    Provides the total line count of the project"
    echo "     -i    Installs all requirements for this script to work"
    echo "     -h    Displays this help message"
    echo
}



if [[ -z $1 ]];
then
    echo "Usage: run [./Project.sh -h] for help"
else
    while getopts ":btaclih" option;
    do
        case $option in
            b) 
                Build
                exit;;
            t) 
                Test
                exit;;
            a) 
                Analyze
                exit;;
            c) 
                Coverage 
                exit;;
            l) 
                LineCount
                exit;;
            i)
                InstallRequirements
                exit;;
            h)
                Help
                exit;;
            \?)
                echo "Usage: run [./Project.sh -h] for help"
        esac
    done
fi







