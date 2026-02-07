#!/bin/bash


validint(){

    number="$1"
    min="$2"
    max="$3"

    if [ -z $number ]; then
        echo "Error: No number provided."
        return 1
    fi


    if [ "${number%${number#?}}" = "-" ]; then
        testvalue="${number#?}"
    else
        testvalue="$number"
    fi

    nodigits="$(echo $testvalue | sed 's/[[:digit:]]//g')"
    if [ ! -z "$nodigits" ]; then
        echo "Error: Invalid number format. Only digits are allowed."
        return 1
    fi

    if [ ! -z "$min" ] && [ "$number" -lt "$min" ]; then
        echo "Error: Number is less than the minimum allowed value ($min)."
        return 1
    fi

    if [ ! -z "$max" ] && [ "$number" -gt "$max" ]; then
        echo "Error: Number exceeds the maximum allowed value ($max)."
        return 1
    fi

    return 0

    }

if validint "$1" "$2" "$3"; then
    echo "Заданное число находиться в диапазоне от $2 до $3."

fi






