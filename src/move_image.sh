#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <image_path>"
  exit 1
fi

image_path=$1
folder_path="${image_path%/*}"
echo $folder_path
if [ ! -d "/home/g6/emli-mini-project/images/${folder_path}" ]; then
  mkdir "/home/g6/emli-mini-project/images/${folder_path}"
fi
cp "/home/g6/emli-mini-project/temp/$image_path.json" "/home/g6/emli-mini-project/images/$image_path.json"
cp "/home/g6/emli-mini-project/temp/$image_path.jpg" "/home/g6/emli-mini-project/images/$image_path.jpg"

echo "Successfully saved $image_path"

