#!/bin/bash

month_num_to_name(){

    case $1 in
        1) month="Jan" ;;
        2) month="Feb" ;;
        3) month="Mar" ;;
        4) month="Apr" ;;
        5) month="May" ;;
        6) month="Jun" ;;
        7) month="Jul" ;;
        8) month="Aug" ;;
        9) month="Sep" ;;
        10) month="Oct" ;;
        11) month="Nov" ;;
        12) month="Dec" ;;
        *) echo "Invalid month number: $1" 
            exit 1 
    esac  
    return 0       
}

# Processing dates that looks like MM/DD/YYYY , MM-DD-YYYY
if [ $# -eq 1 ] ; then 
    set -- $(echo $1 | tr '/-' ' ')
fi



# Check if the correct number of arguments is provided
if  [ $# -ne 3 ]; then
    echo "Usage: $0 month day year "
    echo "Example:  2 3 2024 or 12 25 2024"
    exit 1
fi
# check if year is valid
year_string="$3"
if [ ${#year_string} -le 3 ] ; then
    echo "Invalid year: $3. Enter a four-digit year."
    exit 1
fi



# check if month is valid
if [ -z $(echo $1 | sed 's/[[:digit:]]//g') ] ; then
    month_num_to_name $1 
else
    month="$(echo $1 | cut -c1 | tr '[:lower:]' '[:upper:]')"
    month="$month$(echo $1 | cut -c2-3 | tr '[:upper:]' '[:lower:]')"

fi
 
# Check if day is valid
if [ $2 -le 0 ] || [ $2 -gt 31 ]; then
    echo "Invalid day: $2. Please enter a day between 1 and 31."
    exit 1
fi

 echo $month $2 $3

 exit 0




