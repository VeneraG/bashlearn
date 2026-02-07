#!/bin/bash
# Проверка на валидность ввода: только буквы и цифры. 
valid_alpha_num() {
    valid_chars="$(echo $1 | sed -e 's/[^[:alnum:]]//g')"
    if [ "$valid_chars" = "$1" ]; then
        return 0
    else
        return 1
    fi
}
# Проверка на валидность ввода: только заглавные буквы.
valid_alpha_upper() {
    valid_chars="$(echo $1 | sed -e 's/[^[:upper:]]//g')"
    if [ "$valid_chars" = "$1" ]; then
        return 0
    else
        return 1
    fi
}
# Проверка на валидность ввода: только цифры и знаки дефиса (для телефонных номеров).
valid_phone() {
    valid_chars="$(echo $1 | sed -e 's/[^- [:digit:]\(\)]//g')"
    if [ "$valid_chars" = "$1" ]; then
        return 0
    else
        return 1
    fi
}


echo -n "Ввод:"
read input 
if ! valid_alpha_num "$input"; then
    echo "Ошибка: Ввод должен содержать только буквы и цифры."
    
else
    echo "Ввод корректен: $input"
fi

if ! valid_phone "$input"; then
    echo "Ошибка: Ввод должен содержать только цифры и знаки дефиса."
    
else
    echo "Ввод корректен: $input"
fi

exit 0



