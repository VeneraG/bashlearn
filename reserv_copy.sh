#!/bin/bash

archivedir="$HOME/.deleted_files"
realrm="$(which rm)"
copy="$(which cp) -R"

if [ $# -eq 0 ]; then
    exec $realrm #Оболочка заменяется /bin/rm
fi

#Проверка на наличие -f

flags=""

while getopts "dfiPRrvW" opt
do
    case $opt in
        f) exec $realrm "$@" ;;
        *) flags="$flags -$opt" ;;
    esac
done


shift $(( $OPTIND - 1 ))

#Основная часть


#гарантия наличия каталога arhivedir
if [ ! -d "$archivedir" ]; then
    if [  ! -w $HOME ]; then
        echo "$0: Нет прав на создание каталога $archivedir" >&2
        exit 1
    fi
    mkdir "$archivedir"
    chmod 700 "$archivedir" 
fi


for arg 
do 
    newname="$archivedir/$(date +"%d-%m-%Y-%H-%M-%S").$$.$(basename "$arg")"
    if [ -f "$arg" -o -d "$arg" ]; then
        $copy "$arg" "$newname" 
    fi 
done 
exec $realrm $flags "$@" #Текущий сценарий заменяется /bin/rm с флагами, которые не были -f
