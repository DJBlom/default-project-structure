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
PROJECT_NAME=SomeProject
PROJECT_VERSION_NUM=0.0.1
PROJECT_VERSION_PREFIX=-v
BIN_SUFFIX=.elf
CMAKE=cmake
BIN_DIR=project
TEST_DIR=test
BUILD_TYPE="Debug"
BUILD_DIR=build


rm -rf $BUILD_DIR/*

DeployBuild()
{
    $CMAKE -S . -B $BUILD_DIR/$BIN_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
                                                            -DCMAKE_PROJECT_NAME=$PROJECT_NAME \
                                                            -DCMAKE_PROJECT_VERSION=$PROJECT_VERSION_PREFIX$PROJECT_VERSION_NUM \
                                                            -DCMAKE_EXECUTABLE_SUFFIX=$BIN_SUFFIX \
                                                            -DBUILD_PROJECT_FOR_DEPLOY=ON \
                                                            -DBUILD_PROJECT=ON
    $CMAKE --build $BUILD_DIR/$BIN_DIR

    DEPLOY_DIR=$BUILD_DIR/$PROJECT_NAME$PROJECT_VERSION_PREFIX$PROJECT_VERSION_NUM
    mkdir -p $DEPLOY_DIR
    cp -r $BUILD_DIR/$BIN_DIR/$PROJECT_NAME$PROJECT_VERSION_PREFIX$PROJECT_VERSION_NUM$BIN_SUFFIX $DEPLOY_DIR
    tar cvf $DEPLOY_DIR.tar.gz $DEPLOY_DIR
}

Build()
{
    mkdir -p $BUILD_DIR/$BIN_DIR
    $CMAKE -S . -B $BUILD_DIR/$BIN_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
                                                            -DCMAKE_PROJECT_NAME=$PROJECT_NAME \
                                                            -DCMAKE_EXECUTABLE_SUFFIX=$BIN_SUFFIX \
                                                            -DBUILD_PROJECT=ON
    $CMAKE --build $BUILD_DIR/$BIN_DIR
}

Test()
{
    PROJECT_TEST=Test$PROJECT_NAME
    mkdir -p $BUILD_DIR/$TEST_DIR
    $CMAKE -S . -B $BUILD_DIR/$TEST_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
                                                             -DCMAKE_PROJECT_NAME=$PROJECT_TEST \
                                                             -DCMAKE_EXECUTABLE_SUFFIX=$BIN_SUFFIX \
                                                             -DUNIT_TESTS=ON
    $CMAKE --build $BUILD_DIR/$TEST_DIR
}

Analyze()
{
    mkdir -p $BUILD_DIR/$BIN_DIR
    $CMAKE -S . -B $BUILD_DIR/$BIN_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
                                                            -DCMAKE_PROJECT_NAME=$PROJECT_NAME \
                                                            -DCMAKE_EXECUTABLE_SUFFIX= \
                                                            -DSTATIC_CODE_ANALYSIS=ON
    $CMAKE --build $BUILD_DIR/$BIN_DIR
    cd $BUILD_DIR/$BIN_DIR
    make $PROJECT_NAME
}

Coverage()
{
    PROJECT_COVERAGE=${PROJECT_NAME}Coverage
    mkdir -p $BUILD_DIR/$TEST_DIR
    $CMAKE -S . -B $BUILD_DIR/$TEST_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
                                                             -DCMAKE_PROJECT_NAME=$PROJECT_COVERAGE \
                                                             -DCMAKE_EXECUTABLE_SUFFIX=$BIN_SUFFIX \
                                                             -DCODE_COVERAGE=ON
    $CMAKE --build $BUILD_DIR/$TEST_DIR
    lcov --rc lcov_branch_coverage=1 --directory . --capture --output-file $BUILD_DIR/$TEST_DIR/coverage.info
    lcov --rc lcov_branch_coverage=1 --remove $BUILD_DIR/$TEST_DIR/coverage.info '/opt/*' --output-file $BUILD_DIR/$TEST_DIR/coverage.info
    lcov --rc lcov_branch_coverage=1 --list $BUILD_DIR/$TEST_DIR/coverage.info > $BUILD_DIR/$TEST_DIR/coverage.txt
    genhtml --rc lcov_branch_coverage=1 --legend -o $BUILD_DIR/$TEST_DIR/html $BUILD_DIR/$TEST_DIR/coverage.info
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


InstallPackages()
{
    packages=(cloc lcov cppcheck dh-autoreconf automake autoconf)
    DNF=$(which dnf)

    if [[ ! -z $DNF ]];
    then
        sudo dnf -y install ${packages[@]}
    fi

    if [[ -z "$CPPUTEST_HOME" ]];
    then
        cd /opt
        sudo git clone https://github.com/cpputest/cpputest.git
        cd cpputest
        sudo autoreconf --install
        sudo ./configure
        sudo make tdd
        echo "export CPPUTEST_HOME=/opt/cpputest/" >> /home/$(whoami)/.bashrc
        source /home/$(whoami)/.bashrc
    else
        echo "CppUTest is already installed @ $CPPUTEST_HOME"
    fi
}

LineCount()
{
    echo
    echo "Total project line count."
    cloc .
    echo
}

Help()
{
    echo
    echo "Description:"
    echo "This script is used to build, test, analyze, and provide code coverage on a project."
    echo
    echo "Usage: ./Project.sh [-d|b|t|a|c|i|h]"
    echo "options:"
    echo "      -d    Build the project for deployment"
    echo "      -b    Build the project"
    echo "      -t    Execute unit test"
    echo "      -a    Run static code analysis"
    echo "      -c    Generate a code coverage report"
    echo "      -l    Provides the total line count of the project"
    echo "      -i    Installs all required packages for the project"
    echo "      -h    Displays this help message"
    echo
}

while getopts ":dbtaclih" option;
do
    case $option in
        d)
            DeployBuild
            exit;;
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
            InstallPackages
            exit;;
        h)
            Help
            exit;;
        \?)
            echo "Usage: run [./Project.sh -h] for help"
    esac
done
