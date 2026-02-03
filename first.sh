#!/bin/bash
readonly FILE_PATH="/home/venera/templates"
for FILE in "$FILE_PATH"/*; do
  if [[ -d "$FILE" ]]; then
    echo "Directory: $(basename "$FILE")"
    elif [[ -f "$FILE" ]]; then
    echo "File: $(basename "$FILE")"
    fi
done
