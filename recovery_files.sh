#!/bin/bash

arhivedir="$HOME/.deleted_files"
realrm="$(which rm)"
realmv="$(which mv)"
dest=$(pwd)

#Проверка на наличие архива
if [ ! -d "$arhivedir" ]; then
    echo "Каталог $arhivedir не найден. Восстановление невозможно."
    exit 1
fi

cd $arhivedir

# Проверка на пустой ввод
if [ $# -eq 0 ]; then
    echo "Содержимое архива отсортировано по дате удаления:"
    ls | sed -e 's/\([[:digit:]][[:digit:]]\.\)\{4\}//g' \
    -e 's/\([[:digit:]][[:digit:]]\-\)//g'
    
    exit 0
fi

#Нахождение файлов в резерве

#if user give a pattern
matches="$(ls -d *"$1"* 2>/dev/null | wc -l)"
echo $matches

if [ $matches -eq 0 ]; then
    echo "Файл не найден в резерве."
    exit 1

fi
if [ $matches -gt 1 ]; then

    echo "Найдено несколько совпадений:"
    index=1
    for file in $(ls -td *"$1"*); do
        datetime="$(echo "$file" |  awk -F. '{ split($1,a,"-"); print a[5]"/"a[4]" в "a[3]":"a[2]":"a[1] }')"
        filename="$(echo "$file" |  cut -c27- )"
        if [ -d "$file" ]; then
            filecount="$(ls "$file" | wc -l | sed 's/[^[:digit:]]//g')"
            echo "$index) $filename/ (удален $datetime, содержит $filecount файлов)"
        else
            size="$(ls -sdk1 "$file" | awk '{ print $1 }')"
            echo "$index) $filename (удален $datetime, размер $size КБ)"
        fi
        index=$((index+1))
    done
    echo ""
    echo -n "Какую версию $1 вы хотите восстановить? ('0' для выхода) [1]: "
    read answer
    if [ ! -z "$(echo $answer | sed 's/[[:digit:]]//g')" ]; then
        echo "$0: восстановление отменено: введено не число" >&2
        exit 1  
    fi

    if [ ${answer:=1} -ge $index] ; then
        echo "$0: восстановление отменено: введено число вне диапазона" >&2
        exit 1  
    fi

    if [ $answer -lt 1 ]; then
        echo "Восстановление отменено." >&2
        exit 1
    fi
    restore="$(ls -td1 *"$1"* | sed -n "${answer}p")"

    if [ -e "$dest/$1" ]; then
        echo "Файл $dest/$1 уже существует. Восстановление отменено." >&2
        exit 1
    fi

    echo -n "Восстановление файла $1 из архива $restore... "
    $realmv "$arhivedir/$restore" "$dest/$1"
    echo "Готово."

    echo -n "Хотите удалить резервные копии из архива? [y/N] "
    read answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        $realrm -rf "$arhivedir/$restore"
        echo "Резервные копии удалены."
    else
        echo "Резервные копии сохранены в архиве."
    fi
else
    if [ -e "$dest/$1" ]; then
        echo "Файл $dest/$1 уже существует. Восстановление отменено." >&2
        exit 1
    fi
    echo -n "Восстановление файла $1 из архива... "
    $realmv "$arhivedir/"*"$1"* "$dest/$1"
    echo "Готово."

fi



#