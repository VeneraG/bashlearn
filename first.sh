#!/bin/bash
readonly FILE_PATH="/home/venera/templates"
for FILE in "$FILE_PATH"/*; do
  if [[ -d "$FILE" ]]; then
    echo "Directory: $(basename "$FILE")"
    elif [[ -f "$FILE" ]]; then
    echo "File: $(basename "$FILE")"
    fi
done
echo "$(top -bn1 | grep 'Cpu(s)')"
cpu_usage=$(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')
echo "$(top -bn1 | grep 'Cpu(s)')"
echo "Current CPU Usage: $cpu_usage"
