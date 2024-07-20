############################################################################
# Contents: Main Function
# 
# Author: Dawid Blom
#
# Date: September 15, 2023
#
# NOTE: Allows the user to build, test, draw statistics, and install 
# project related packages.
############################################################################
#!/bin/bash
source $(dirname "$0")/Build.sh
source $(dirname "$0")/Test.sh
source $(dirname "$0")/Install.sh
source $(dirname "$0")/Statistics.sh

readonly YES=0
readonly NO=1
readonly ECHO="echo -e"
readonly INFO_COLOR="\e[1;36m"
readonly ERROR_COLOR="\e[1;31m"
readonly SUCCESS_COLOR="\e[1;32m"
readonly END_COLOR="\e[0m"


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
        $ECHO "${ERROR_COLOR}ERROR: $(basename "$0") must be called from:\n${END_COLOR}"
        $ECHO "${ERROR_COLOR}\t$(dirname `pwd`)\n\r${END_COLOR}"
        $ECHO "${INFO_COLOR}INFO: Currently, you are here:\n${END_COLOR}"
        $ECHO "${INFO_COLOR}\t$(pwd)${END_COLOR}"
        exit 1;
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

function Help()
{
    $ECHO "${INFO_COLOR}\n\rUsage: ./scripts/Project.sh [OPTION]${END_COLOR}"
    $ECHO "${INFO_COLOR}Building, testing, and analyzing a projects code${END_COLOR}"
    $ECHO   
    $ECHO "${INFO_COLOR}OPTIONS:${END_COLOR}"
    $ECHO "${INFO_COLOR}\t-b, -b=, --build, --build=SUPPORTED_BUILD${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\tSUPPORTED_BUILD:${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[HOST], compiles for the host computer you are developing on (e.g. Linux PC or Laptop)${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[TARGET], compiles for the target platform (e.g. Arm). Create 'CROSS_COMPILER=path/to/compiler'${END_COLOR}" 
    $ECHO "${INFO_COLOR}\t\t\t[DEPLOY], compiles for the target platform and packages the binary file for production."\
        "Create 'CROSS_COMPILER=path/to/compiler'\n\r${END_COLOE}"
    $ECHO "${INFO_COLOR}\t-t, -t=, --test, --test=SUPPORTED_TEST${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\tSUPPORTED_TEST:${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[SCA], performs static code analysis using Cppcheck${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[COVERAGE], performs code coverage with gcovr${END_COLOR}"
    $ECHO "${INFO_COLOR}\t\t\t[UNIT], runs all unit tests in your project using CppUTest${END_COLOE}"
    $ECHO "${INFO_COLOR}\t\t\t[SHOW], graphically displays the code coverage in firefox\n\r${END_COLOE}"
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
