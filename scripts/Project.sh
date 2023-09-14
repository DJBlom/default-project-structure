################################################################################
#
################################################################################
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

Analyse()
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
    $CMAKE -S . -B $BUILD_DIR/$TEST_DIR --warn-uninitialized -DUNIT_TESTS=ON 
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
        echo -e "\e[31mTotal coverage should be ${threshold}%: FAILED \e[0m"
        echo -e "\e[31mCurrent total coverage should be ${total_percentage}% \e[0m"
        exit 1
    else
        echo " "
        echo -e "\e[32mTotal coverage is: ${total_percentage}%: PASSED \e[0m"
        exit 0
    fi
}

Help()
{
    echo
    echo "Description:"
    echo "This script is used to build, test, analyze, and provide code coverage on a project."
    echo
    echo "Usage: ./Project.sh [-b|t|a|c|h]"
    echo "options:"
    echo "      b    Build the project"
    echo "      t    Run the unit test"
    echo "      a    Run static code analysis"
    echo "      c    Generate a code coverage report"
    echo "      h    Displays this help message"
    echo
}

while getopts ":btach" option;
do
    case $option in
        b) 
            Build
            exit;;
        t) 
            Test
            exit;;
        a) 
            Analyse
            exit;;
        c) 
            Coverage 
            exit;;
        h)
            Help
            exit;;
        \?)
            echo "Usage: run [./Project.sh -h] for help"
    esac
done







