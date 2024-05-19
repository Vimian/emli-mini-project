#!/bin/bash
name=$(date +%H%M%S_%N)
dir=$(date +%F)

if [ ! -d "/home/g6/emli-mini-project/temp" ]; then
  mkdir "/home/g6/emli-mini-project/temp"
fi
if [ ! -d "/home/g6/emli-mini-project/temp/${dir}" ]; then
  mkdir "/home/g6/emli-mini-project/temp/${dir}"
fi

file_name="${name:0:10}.jpg"
rpicam-still -t 0.01 -o "/home/g6/emli-mini-project/temp/${dir}/$file_name"


create_date=$(sudo exiftool "/home/g6/emli-mini-project/temp/${dir}/$file_name" | grep Create | awk '{print $4,$5}' | sed ':a;$!{N;ba}; s/:/-/; s/:/-/;')
create_seconds_epoch="$(date -d "$create_date" +%s).${name:7:3}"
trigger="PLEASE ADD ME"
subject_distance=$(sudo exiftool "/home/g6/emli-mini-project/temp/${dir}/$file_name" | grep 'Subject Distance' | awk '{print $4}')
exposure_time=$(sudo exiftool "/home/g6/emli-mini-project/temp/${dir}/$file_name" | grep 'Exposure Time' | awk '{print $4}')
iso=$(sudo exiftool "/home/g6/emli-mini-project/temp/${dir}/$file_name" | grep 'ISO' | awk '{print $3}')

json_name=$(cat <<EOF
{
 	"File Name": "$file_name",
	"Create Date": "$create_date",
 	"Create Seconds Epoch": $create_seconds_epoch,
	"Trigger": "$trigger",
	"Subject Distance": $subject_distance,
	"Exposure Time": "$exposure_time",
	"ISO": $iso
}
EOF
)

json_filename=$(echo "/home/g6/emli-mini-project/temp/${dir}/$file_name" | sed "s/jpg/json/g")
echo "$json_name" > $json_filename
