#!/bin/bash

current_date=$(date +%F)

dir="/home/g6/emli-mini-project/temp/${current_date}"

latest_file=$(find "$dir" -type f -printf "%T@ %p\n" | sort -nr | tail -n +4 | head -n 1 | cut -d' ' -f2-)

temp="${latest_file%%.*}"

temp2="${temp#*/temp/}"

echo "${temp2}"
