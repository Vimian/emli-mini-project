#!/bin/bash

while true
do
  start_time=$(date +%s%N)
  path=$(/home/g6/emli-mini-project/src/pi/photo/latest_file.sh)
  /home/g6/emli-mini-project/src/pi/trigger/set_trigger.sh "/home/g6/emli-mini-project/temp/$path.json" "Time"
  /home/g6/emli-mini-project/src/pi/photo/move_image.sh "$path"
  echo "[$(date +'%Y-%m-%d %H:%M:%S') - time_trigger.sh] Saving image due to time trigger" >> /home/g6/emli-mini-project/log/log.txt
  end_time=$(date +%s%N)

  elapsed=$(( (end_time - start_time) / 1000000 ))

  sleep_time=$(( 300000 - elapsed ))
  if [ $sleep_time -gt 0 ]; then
    sleep $(( sleep_time / 1000 )).$(( sleep_time % 1000 ))
  fi
done
