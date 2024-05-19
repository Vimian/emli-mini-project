#!/bin/bash

while true
do
  start_time=$(date +%s%N)
  /home/g6/emli-mini-project/src/take_photo.sh
  end_time=$(date +%s%N)

  elapsed=$(( (end_time - start_time) / 1000000 ))

  sleep_time=$(( 3000 - elapsed ))

  if [ $sleep_time -gt 0 ]; then
    sleep $(( sleep_time / 1000 )).$(( sleep_time % 1000 ))
  fi
done
