############################################################################
# Contents: Project Install Functions
# 
# Author: Dawid Blom
#
# Date: September 15, 2023
#
# NOTE:
#
############################################################################
#!/bin/bash


readonly INSTALLATION_OPTION=("setup" "cpputest")


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
