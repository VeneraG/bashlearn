#!/bin/bash

in_path()
{
    command=$1 
    ourpath=$2
    result=1
    old_IFS=$IFS
    IFS=":"
    for dir in $ourpath; do
        if [ -x "$dir/$command" ]; then
            result=0
            break
        fi
    done
    IFS=$old_IFS
    return $result
}
check_command_in_path()
{
    var=$1
    if [ -n "$var" ] ; then
        if [ "${var:0:1}" = "/" ] ; then
            if [ ! -x "$var" ]; then
                return 1
            fi
        elif ! in_path $var "$PATH"; then
                return 2
        fi

    fi
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 command" >&2
    exit 1
fi

check_command_in_path "$1"
case $? in
    0) echo "Command '$1' found in PATH." ;;
    2) echo "Command '$1' not found or not executable." ;;
    1) echo "Command '$1' not found." ;;
esac

exit 0  