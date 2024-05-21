#!/bin/bash

last_cp=""
while true
do
  start_time=$(date +%s%N)

  latest="/home/g6/emli-mini-project/temp/$(/home/g6/emli-mini-project/src/pi/photo/latest_file.sh).jpg"
  previous="/home/g6/emli-mini-project/temp/$(/home/g6/emli-mini-project/src/pi/photo/second_latest_file.sh).jpg"

  motion=$(python3 /home/g6/emli-mini-project/src/pi/motion-detector/motion_detect.py $latest $previous)

  if [ "$motion" = "Motion detected" ]; then
    path=$(/home/g6/emli-mini-project/src/pi/photo/latest_file.sh)
    if [ "$path" != "$last_cp" ]; then
      echo "[$(date +'%Y-%m-%d %H:%M:%S') - movement_trigger.sh] Movement detected in photos, saving last photo" >> /home/g6/emli-mini-project/log/log.txt
      /home/g6/emli-mini-project/src/pi/trigger/set_trigger.sh "/home/g6/emli-mini-project/temp/$path.json" "Motion"
      /home/g6/emli-mini-project/src/pi/photo/move_image.sh "$path"
      last_cp=$path
    fi
  fi

  end_time=$(date +%s%N)

  elapsed=$(( (end_time - start_time) / 1000000 ))

  sleep_time=$(( 3000 - elapsed ))

  if [ $sleep_time -gt 0 ]; then
    sleep $(( sleep_time / 1000 )).$(( sleep_time % 1000 ))
  fi
done
