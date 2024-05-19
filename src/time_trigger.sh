#!/bin/bash

while true
do
  start_time=$(date +%s%N)
  path=$(./latest_file.sh)
  ./set_trigger.sh "/home/g6/emli-mini-project/temp/$path.json" "Time"
  ./move_image.sh "$path"
  end_time=$(date +%s%N)

  elapsed=$(( (end_time - start_time) / 1000000 ))

  sleep_time=$(( 300000 - elapsed ))
  if [ $sleep_time -gt 0 ]; then
    sleep $(( sleep_time / 1000 )).$(( sleep_time % 1000 ))
  fi
done
