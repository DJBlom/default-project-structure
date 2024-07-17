############################################################################
# Contents: Project Test Functions
# 
# Author: Dawid Blom
#
# Date: September 15, 2023
#
# NOTE: 
#
############################################################################
#!/bin/bash

readonly TEST_DIR=$(pwd)/test
readonly TEST_TYPES=("sca" "coverage" "unit" "show")

function Test()
{
    local testtype=$1
    if [[ $testtype == ${TEST_TYPES[0]} ]];
    then
        $ECHO "${INFO_COLOR}INFO: Running 'Cppcheck' to perform static code analysis${END_COLOR}"
        StaticCodeAnalysis
    elif [[ $testtype == ${TEST_TYPES[1]} ]];
    then
        $ECHO "${INFO_COLOR}INFO: Running 'gcovr' to perform code coverage${END_COLOR}"
        CodeCoverage
    elif [[ $testtype == ${TEST_TYPES[2]} ]];
    then
        $ECHO "${INFO_COLOR}INFO: Running 'CppUTest' to perform unit-testing${END_COLOR}"
        UnitTest
    elif [[ $testtype == ${TEST_TYPES[3]} ]];
    then
        $ECHO "${INFO_COLOR}INFO: Launching 'firefox' to display code coverage${END_COLOR}"
        ShowCodeCoverage
    else
        $ECHO "${ERROR_COLOR}ERROR: Test type not supported${END_COLOR}"
    fi
}

function StaticCodeAnalysis()
{
    local prjDir=$(pwd)
    cppcheck --enable=style \
             --enable=warning \
             --enable=performance \
             --enable=portability \
             --enable=information \
             --enable=missingInclude \
             --enable=unusedFunction \
             --library=posix \
             --std=c11 \
             --std=c++20 \
             --error-exitcode=1 \
             --platform=unix64 \
             --suppress=missingIncludeSystem \
             --suppress=checkersReport \
             -I $prjDir/api/include \
             -I $prjDir/system/include \
             -I $prjDir/features/include \
             -I $prjDir/algorithms/include \
             $prjDir/app/source \
             $prjDir/api/source \
             $prjDir/system/source \
             $prjDir/features/source 
}

function CodeCoverage()
{
	local prjDir=$(pwd)
#    local coverageDir=$TEST_DIR/coverage
    local coverageDir=$BUILD_DIR/coverage
    mkdir -p $coverageDir
    sudo -E make -C $TEST_DIR -s gcov
	gcovr --exclude="^[^\/]+\/mocks\/?(?:[^\/]+\/?)*$" --exclude-throw-branches -r $prjDir \
	--html-nested $coverageDir/coverage.html  --txt $coverageDir/coverage.txt

	coverage=$(grep -F "TOTAL" $coverageDir/coverage.txt)
	# Extract the line coverage percentage
	total_coverage=($(echo "$coverage" | awk -F ' ' '{print $4}' | awk -F '%' '{print $1}'))
	threshold=80
	if [[ $total_coverage -lt $threshold ]];
	then
        $ECHO "${ERROR_COLOR}FAILED: Total coverage should be ${threshold}.0% or higher.${END_COLOR}"
        $ECHO "${INFO_COLOR}INFO: Currently, it is ${total_coverage}.0%${END_COLOR}"
        if [ -d $coverageDir ];
        then
            rm -rf $coverageDir
            sudo -E make -C $TEST_DIR -s clean
        fi
        exit 1
	else
        $ECHO "${SUCCESS_COLOR}PASS: Total coverage is: ${total_coverage}.0%${END_COLOR}"
        if [ -d $coverageDir ];
        then
            rm -rf $coverageDir
            sudo -E make -C $TEST_DIR -s clean
        fi
        exit 0
	fi
}

function UnitTest()
{
	local prjDir=$(pwd)
    sudo -E make -C $TEST_DIR -s
    sudo -E make -C $TEST_DIR -s clean
}

function ShowCodeCoverage()
{
	local prjDir=$(pwd)
    local coverageDir=$BUILD_DIR/coverage
    mkdir -p $coverageDir
    sudo -E make -C $TEST_DIR -s gcov
	gcovr -e $TEST_DIR/mocks --exclude-throw-branches -r $prjDir \
	--html-nested $coverageDir/coverage.html  --txt $coverageDir/coverage.txt

    firefox $coverageDir/coverage.html
    sudo -E make -C $TEST_DIR -s clean
}
