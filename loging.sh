#!/bin/bash

removelog="/var/log/remove.log"

if [ $# -eq 0 ]; then
    echo "Usage: $0 [-s] list of files or dirictories"

    exit 1
fi

if [ "$1" == "-s" ]; then
    shift
    for file in "$@"; do
        if [ -e "$file" ]; then
            echo "Removing: $file"
            rm -rf "$file"
            echo "$(date): Removed $file" >> "$removelog"
        else
            echo "File not found: $file"
        fi
    done
    
else
    echo "$(date): ${USER}: $@" >> "$removelog"
    
fi

/bin/rm-old "$@"

exit 0




