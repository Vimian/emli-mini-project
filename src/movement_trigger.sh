#!/bin/bash

last_cp=""
while true
do
  start_time=$(date +%s%N)

  latest="/home/g6/emli-mini-project/temp/$(./latest_file.sh).jpg"
  previous="/home/g6/emli-mini-project/temp/$(./second_latest_file.sh).jpg"

  motion=$(python3 /home/g6/emli-mini-project/src/motion_detect.py $latest $previous)

  if [ "$motion" = "Motion detected" ]; then
    path=$(/home/g6/emli-mini-project/src/latest_file.sh)
    if [ "$path" != "$last_cp" ]; then
      /home/g6/emli-mini-project/src/set_trigger.sh "/home/g6/emli-mini-project/temp/$path.json" "Motion"
      /home/g6/emli-mini-project/src/move_image.sh "$path"
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
