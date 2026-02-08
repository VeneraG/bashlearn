#!/bin/bash
retries="10"

action="lock"

while getopts "lur:" opt; do
  case $opt in
    l) action="lock" ;;
    u) action="unlock" ;;
    r) retries="$OPTARG" ;;
    
  esac
done


shift $((OPTIND -1))
# проверка пустого ввода
if [ $# -eq 0 ]; then
    cat << EOF >&2
Usage: $0 [-l|-u] [-r retries] LOCKFILE
Options:
  -l            Lock the specified LOCKFILE (default action)
  -u            Unlock the specified LOCKFILE
  -r retries    Number of retries for locking (default: 10) 
EOF
exit 1
fi

#проверка lockfile на наличие в системе
if [ -z "$(which lockfile | grep -v '^no ')" ]; then
    echo "$0: lockfile command not found. Please install the 'procmail' package." >&2
    exit 1
fi

# Основное тело
if [ "$action" = "lock" ]; then
    if ! lockfile -1 -r $retries "$1" 2> /dev/null; then
        echo "$0: Failed to acquire lock on $1 after $retries retries." >&2
        exit 1
    fi
else 
    if [ ! -f "$1" ]; then
        echo "$0: Lockfile $1 does not exist. Cannot unlock." >&2
        exit 1
    fi
    rm -f "$1"
fi

exit 0




