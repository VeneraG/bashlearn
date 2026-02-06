#!/bin/bash

# ----------------------------------------
# Название: system_monitor.sh
# Автор: Galieva Venera
# Дата: 03.02.2026
# Описание: Скрипт мониторинга ресурсов системы (ЦПУ, память, диск) с оповещениями при превышении пороговых значений. 
# Доп.Функции: Уведомление на почту при превышении порогов (не реализовано). Запись в журнал значений использования ресурсов (не реализовано).
# ----------------------------------------


# Пороговые значения
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
LOGFILE="journal.log"
log(){
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}



# Функция для отправки оповещения
send_alert() {
  echo "$(tput setaf 1)ALERT: $1 usage exceeded threshold! Current value: $2%$(tput sgr0)"
}

# выход из скрипта 
cleanup() {

    log "$(tput setaf 3)Script finished working$(tput sgr0)"
    echo "...exiting"
    echo "Press \"cat journal.log\" to see the log file"
    exit
}
trap cleanup SIGINT

log "$(tput setaf 4)Script started working$(tput sgr0)"

flag=true

while $flag; do
  # Мониторинг использования ЦПУ
  cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

  cpu_usage=${cpu_usage%.*} # Преобразование в целое число
  

  if ((cpu_usage >= CPU_THRESHOLD)); then
    send_alert "CPU" "$cpu_usage"
  fi

  # Мониторинг использования памяти
  memory_usage=$(free | awk '/Mem/ {printf("%3.1f", ($3/$2) * 100)}')
  
  memory_usage=${memory_usage%.*}
  if ((memory_usage >= MEMORY_THRESHOLD)); then
    send_alert "Memory" "$memory_usage"
  fi
  # Мониторинг использования диска
  disk_usage=$(df -h / | awk '/\// {print $(NF-1)}')
  disk_usage=${disk_usage%?} # Удалить знак %
  

  if ((disk_usage >= DISK_THRESHOLD)); then
    send_alert "Disk" "$disk_usage"
  fi
  clear
  log "Current usage - $(tput setaf 2)CPU$(tput sgr0): $cpu_usage%, $(tput setaf 2)Memory$(tput sgr0): $memory_usage%, $(tput setaf 2)Disk$(tput sgr0): $disk_usage%"
  echo "Resource Usage:"
  echo "CPU: $cpu_usage%"
  echo "Memory: $memory_usage%"
  echo "Disk: $disk_usage%"
  echo "Press Ctrl+C to exit..."
  sleep 2
  
  

done

exit 0
