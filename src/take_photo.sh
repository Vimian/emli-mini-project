#!/bin/bash
name=$(date +%H%M%S_%N)
dir=$(date +%F)

if [ ! -d "${dir}" ]; then
  mkdir "${dir}"
fi

rpicam-still -t 0.01 -o "./${dir}/${name:0:10}.jpg"

