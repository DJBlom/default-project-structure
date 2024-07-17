############################################################################
# Contents: Project Statistics File
# 
# Author: Dawid Blom
#
# Date: September 15, 2023
#
# NOTE:
#
############################################################################
#!/bin/bash


readonly STATS_TYPES=("lc")


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

function LineCount()
{
    $ECHO "${INFO_COLOR}INFO: Total project line count"
    cloc .
    $ECHO "${END_COLOR}"
}
