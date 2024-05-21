#!/bin/bash
while true
do
  current_date=$(date +%F)

  dir="/home/g6/emli-mini-project/temp/${current_date}"

  file_to_delete=$(find "$dir" -type f -printf "%T@ %p\n" | sort -nr | tail -n +21 | head -n 1 | cut -d' ' -f2-)

  temp="${file_to_delete%%.*}"
  if [ -n "$file_to_delete" ]
  then
    rm "${temp}".jpg
    echo "[$(date +'%Y-%m-%d %H:%M:%S') - clean_up.sh] Removed ${temp}.jpg" >> /home/g6/emli-mini-project/log/log.txt
    rm "${temp}".json
    echo "[$(date +'%Y-%m-%d %H:%M:%S') - clean_up.sh] Removed ${temp}.json" >> /home/g6/emli-mini-project/log/log.txt
  fi
  sleep 1
done
