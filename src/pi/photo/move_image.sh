#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <image_path>"
  echo "[$(date +'%Y-%m-%d %H:%M:%S') - move_image.sh] Wrong arguments for move_image" >> "/home/g6/emli-mini-project/log/log.txt"
  exit 1
fi

image_path=$1
folder_path="${image_path%/*}"

if [ ! -d "/home/g6/emli-mini-project/images/${folder_path}" ]; then
  mkdir "/home/g6/emli-mini-project/images/${folder_path}"
fi
cp "/home/g6/emli-mini-project/temp/$image_path.json" "/home/g6/emli-mini-project/images/$image_path.json"
cp "/home/g6/emli-mini-project/temp/$image_path.jpg" "/home/g6/emli-mini-project/images/$image_path.jpg"

echo "[$(date +'%Y-%m-%d %H:%M:%S') - move_image.sh] Saved $image_path" >> /home/g6/emli-mini-project/log/log.txt
