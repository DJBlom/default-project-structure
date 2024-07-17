############################################################################
# Contents: Project Build File
# 
# Author: Dawid Blom
#
# Date: September 15, 2023
#
# NOTE:
#
############################################################################
#!/bin/bash

readonly PROJECT_NAME=NativeProjectStructure
readonly PROJECT_VERSION_NUM=0.0.1
readonly PROJECT_VERSION_PREFIX=-v
readonly BIN_SUFFIX=.elf
readonly CMAKE=cmake
readonly BIN_DIR=$PROJECT_NAME
readonly TEST_DIR=test
readonly TOOLCHAIN=$(pwd)/cmake/CrossToolchain.cmake
readonly BUILD_TYPE="Debug"
readonly BUILD_DIR=build

readonly YES=0
readonly NO=1
readonly ECHO="echo -e"
readonly INFO_COLOR="\e[1;36m"
readonly ERROR_COLOR="\e[1;31m"
readonly SUCCESS_COLOR="\e[1;32m"
readonly END_COLOR="\e[0m"


readonly TEST_TYPES=("sca" "coverage" "unit" "show")
readonly STATS_TYPES=("lc")
readonly INSTALLATION_OPTION=("setup" "cpputest")
readonly SUPPORTED_BUILD_TYPES=("host" "target" "deploy")



function Main()
{
    EnvironmentVerification $#
    ParseCommandLineArguments $@
}

function EnvironmentVerification()
{
    local allArguments=$1
    if [[ $(basename `pwd`) != $PROJECT_NAME ]];
    then
        $ECHO "${ERROR_COLOR}ERROR: This script must be run from the top most directory of project, $PROJECT_NAME ${END_COLOR}"
    fi

    if [[ $allArguments -eq 0 ]];
    then
        Help
        exit 1;
    fi
}

function ParseCommandLineArguments()
{
    local testType=""
    local statsType=""
    local buildType=""
    local installType=""
    while [[ -n "$1" ]];
    do
        case $1 in
            -b | --build | -b=* | --build=*)
                IsArgumentValueProvided $@
                if ReturnValueNotOk;
                then 
                    $ECHO "${ERROR_COLOR}ERROR: Build option not specified${END_COLOR}"
                    Help
                    exit 1
                else
                    if [[ ($1 == "-b") || ($1 == "--build") ]];
                    then
                        buildType=$(ExtractArgument $2)
                        shift
                    else
                        buildType=$(ExtractArgument $1)
                    fi
                    Build $(ToLower $buildType)
                fi
                ;;
            -t | --test | -t=* | --test=*)
                IsArgumentValueProvided $@
                if ReturnValueNotOk;
                then 
                    $ECHO "${ERROR_COLOR}ERROR: Test option not specified${END_COLOR}"
                    Help
                    exit 1
                else
                    if [[ ($1 == "-t") || ($1 == "--test") ]];
                    then
                        testType=$(ExtractArgument $2)
                        shift
                    else
                        testType=$(ExtractArgument $1)
                    fi
                    Test $(ToLower $testType)
                fi
                ;;
            -s | --stats | -s=* | --stats=*)
                IsArgumentValueProvided $@
                if ReturnValueNotOk;
                then 
                    $ECHO "${ERROR_COLOR}ERROR: Statistic option not specified${END_COLOR}"
                    Help
                    exit 1
                else
                    if [[ ($1 == "-s") || ($1 == "--stats") ]];
                    then
                        statsType=$(ExtractArgument $2)
                        shift
                    else
                        statsType=$(ExtractArgument $1)
                    fi
                    Statistics $(ToLower $statsType)
                fi
                ;;
            -i | --install | -i=* | --install=*)
                IsArgumentValueProvided $@
                if ReturnValueNotOk;
                then 
                    $ECHO "${ERROR_COLOR}ERROR: Installation option not specified${END_COLOR}"
                    Help
                    exit 1
                else
                    if [[ ($1 == "-i") || ($1 == "--install") ]];
                    then
                        installType=$(ExtractArgument $2)
                        shift
                    else
                        installType=$(ExtractArgument $1)
                    fi
                    Install $(ToLower $installType)
                fi
                ;;
            -h | --help)
                Help
                ;;
            *)
                Help
                exit 1
                ;;
        esac
        shift
    done
}

function Build()
{
    local buildtype=$1
    RemoveDirectory $BUILD_DIR
    if [[ $buildtype == ${SUPPORTED_BUILD_TYPES[0]} ]];
    then
        $ECHO "${INFO_COLOR}Building for the host platform${END_COLOR}"
        HostBuild
        exit
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
            $ECHO "${ERROR_COLOR}ERROR: Cannot build for 'deployment', enrivonrment variable 'CROSS_COMPILER' is not set${END_COLOR}"
        fi
    else
        $ECHO "${ERROR_COLOR}ERROR: Build type not supported${END_COLOR}"
    fi
}

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

function Statistics()
{
    local statstype=$1
    if [[ $statstype == ${STATS_TYPES[0]} ]];
    then
        $ECHO "${INFO_COLOR}INFO: Running 'Cloc' to see the projects line count${END_COLOR}"
        LineCount
    else
        $ECHO "${ERROR_COLOR}ERROR: Currently, I do not support that kind of statistics${END_COLOR}"
    fi
}

function Install()
{
    local install=$1
    if [[ $install == ${INSTALLATION_OPTION[0]} ]];
    then
        $ECHO "${INFO_COLOR}INFO: Installing required project packages${END_COLOR}"
        $ECHO "${SUCCESS_COLOR}"
        InstallPackages
        $ECHO "${END_COLOR}"
    elif [[ $install == ${INSTALLATION_OPTION[1]} ]];
    then
        $ECHO "${INFO_COLOR}INFO: Installing 'CppUTest'${END_COLOR}"
        $ECHO "${SUCCESS_COLOR}"
        InstallCppUTest
        $ECHO "${END_COLOR}"
    else
        $ECHO "${ERROR_COLOR}ERROR: Currently, I do not support that kind of statistics${END_COLOR}"
    fi
}

function HostBuild()
{
    mkdir -p $BUILD_DIR/$BIN_DIR
    $CMAKE -S . -B $BUILD_DIR/$BIN_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
                                                            -DCMAKE_PROJECT_NAME=$PROJECT_NAME \
                                                            -DCMAKE_EXECUTABLE_SUFFIX=$BIN_SUFFIX \
                                                            -DBUILD_PROJECT=ON
    $CMAKE --build $BUILD_DIR/$BIN_DIR
}

function TargetBuild()
{
    mkdir -p $BUILD_DIR/$BIN_DIR
    $CMAKE -S . -B $BUILD_DIR/$BIN_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
                                                            -DCMAKE_PROJECT_NAME=$PROJECT_NAME \
                                                            -DCMAKE_EXECUTABLE_SUFFIX=$BIN_SUFFIX \
                                                            -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
                                                            -DBUILD_PROJECT=ON
    $CMAKE --build $BUILD_DIR/$BIN_DIR
}

function DeployBuild()
{
    $CMAKE -S . -B $BUILD_DIR/$BIN_DIR --warn-uninitialized -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
                                                            -DCMAKE_PROJECT_NAME=$PROJECT_NAME \
                                                            -DCMAKE_PROJECT_VERSION=$PROJECT_VERSION_PREFIX$PROJECT_VERSION_NUM \
                                                            -DCMAKE_EXECUTABLE_SUFFIX=$BIN_SUFFIX \
                                                            -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
                                                            -DBUILD_PROJECT_FOR_DEPLOY=ON \
                                                            -DBUILD_PROJECT=ON
    $CMAKE --build $BUILD_DIR/$BIN_DIR

    DEPLOY_DIR=$BUILD_DIR/$PROJECT_NAME$PROJECT_VERSION_PREFIX$PROJECT_VERSION_NUM
    mkdir -p $DEPLOY_DIR
    cp -r $BUILD_DIR/$BIN_DIR/$PROJECT_NAME$PROJECT_VERSION_PREFIX$PROJECT_VERSION_NUM$BIN_SUFFIX $DEPLOY_DIR
    tar cvf $DEPLOY_DIR.tar.gz $DEPLOY_DIR
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
             --checkers-report=static_code_analysis.txt\
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
             $prjDir/app/source \
             $prjDir/api/source \
             $prjDir/system/source \
             $prjDir/features/source 
}

function CodeCoverage()
{
	local prjDir=$(pwd)
    local coverageDir=$prjDir/$TEST_DIR/coverage
    mkdir -p $coverageDir
    sudo -E make -C $prjDir/$TEST_DIR -s gcov
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
            sudo -E make -C $prjDir/$TEST_DIR -s clean
        fi
        exit 1
	else
        $ECHO "${SUCCESS_COLOR}PASS: Total coverage is: ${total_coverage}.0%${END_COLOR}"
        if [ -d $coverageDir ];
        then
            rm -rf $coverageDir
            sudo -E make -C $prjDir/$TEST_DIR -s clean
        fi
        exit 0
	fi
}

function UnitTest()
{
	local prjDir=$(pwd)
    sudo -E make -C $prjDir/test -s
    sudo -E make -C $prjDir/test -s clean
}

function ShowCodeCoverage()
{
	local prjDir=$(pwd)
    local coverageDir=$prjDir/$TEST_DIR/coverage
    mkdir $coverageDir
    sudo -E make -C $prjDir/$TEST_DIR -s gcov
	gcovr -e $prjDir/$TEST_DIR/mocks --exclude-throw-branches -r $prjDir \
	--html-nested $coverageDir/coverage.html  --txt $coverageDir/coverage.txt

    firefox $coverageDir/coverage.html
}

function InstallPackages()
{
    packages=(cloc lcov gcovr make cmake opencv-devel cppcheck dh-autoreconf automake autoconf)
    DNF=$(which dnf)

    if [[ ! -z $DNF ]];
    then
        sudo dnf -y install ${packages[@]}
    else
        $ECHO "${ERROR_COLOR}ERROR: This system does not use the dnf based package manage${END_COLOR}"
    fi
}

function InstallCppUTest()
{
    InstallPackages
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
        $ECHO "${INFO_COLOR}INFO: CppUTest is already installed @ $CPPUTEST_HOME${END_COLOR}"
    fi
}

function LineCount()
{
    $ECHO "${INFO_COLOR}INFO: Total project line count"
    cloc .
    $ECHO "${END_COLOR}"
}

function Help()
{
    $ECHO "${INFO_COLOR}\n\rUsage: ./scripts/Project.sh [OPTION]${END_COLOR}"
    $ECHO "${INFO_COLOR}Building, testing, and analyzing a projects code${END_COLOR}"
    $ECHO   
    $ECHO "${INFO_COLOR}OPTIONS:${END_COLOR}"
    $ECHO "${INFO_COLOR}\t-b, -b=, --build, --build=SUPPORTED_BUILD${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\tSUPPORTED_BUILD:${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[HOST], compiles for the host computer you are developing on (e.g. Linux PC or Laptop)${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[TARGET], compiles for the target platform (e.g. Arm)${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[DEPLOY], compiles for the target platform and packages the binary file for production\n\r${END_COLOE}"
    $ECHO "${INFO_COLOR}\t-t, -t=, --test, --test=SUPPORTED_TEST${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\tSUPPORTED_TEST:${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[SCA], performs static code analysis using Cppcheck${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[COVERAGE], performs code coverage with gcovr${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[UNIT], runs all unit tests in your project using CppUTest\n\r${END_COLOE}"
    $ECHO "${INFO_COLOR}\t-s, -s=, --stats, --stats=SUPPORTED_STATISTICS${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\tSUPPORTED_STATISTICS:${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[LC], takes a source code line and file count\n\r${END_COLOR}"
    $ECHO "${INFO_COLOR}\t-i, -i=, --install, --install=SUPPORTED_INSTALLS${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\tSUPPORTED_INSTALLS:${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[SETUP], installs all required packages for the project${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[CPPUTEST], install CppUTest and requried packages for it\n\r${END_COLOR}"
    $ECHO "${INFO_COLOR}\t-h, --help${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[HELP], displays this information\n\r${END_COLOR}"
}

function IsBuildTypeSupported()
{
    local valid=$NO
    local buildtype=$1
    for build in ${SUPPORTED_BUILD_TYPES[@]};
    do
        if [[ $build == $buildtype ]];
        then
            valid=$YES
            break
        fi
    done

    return $valid
}

function HasSecondArgument()
{
    local valid=$NO
    if [[ -z $2 ]];
    then
        valid=$YES
    fi
    
    return $valid
}

function IsArgumentValueProvided()
{
    local valid=$NO
    if [[ ("$1" == *=* && -n ${1#*=}) || ( -n "$2" && "$2" != -*) || ( -n "$3" && "$3" != -*) ]];
    then
        valid=$YES
    fi

    return $valid
}

function CrossCompilerProvided()
{
    local valid=$YES
    if [[ -z $CROSS_COMPILER ]];
    then
        valid=$NO
    fi

    return $valid
}

function RemoveDirectory()
{
    local dirname=$1
    if DirectoryExists $dirname;
    then
        rm -rf $dirname
    fi
}

function DirectoryExists()
{
    [[ -d "${1}" ]];
}

function ExtractArgument()
{
    echo "${2:-${1#*=}}"
}

function ReturnValueNotOk()
{
    [[ $? -ne 0 ]];
}

function ToLower()
{
    echo "${1}" | tr '[:upper:]' '[:lower:]' 
}

Main $@
