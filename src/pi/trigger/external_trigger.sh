#!/bin/bash

# MQTT connection details
mqtt_host="localhost"
mqtt_user="g6"
mqtt_pass="letmein"
mqtt_port=1883
mqtt_topic="g6/animal"

# Function to process each message
process_message() {
  local message="$1"
  # Extract the value of rain_detect using jq
  if echo "$message" | jq . >/dev/null 2>&1; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S') - externak_trigger.sh] Wildlife triggered sensor, saving photo" >> /home/g6/emli-mini-project/log/log.txt
    path=$(/home/g6/emli-mini-project/src/pi/photo/latest_file.sh)
    /home/g6/emli-mini-project/src/pi/trigger/set_trigger.sh "/home/g6/emli-mini-project/temp/$path.json" "External"
    /home/g6/emli-mini-project/src/pi/photo/move_image.sh "$path"
  fi
}

# Subscribe to the MQTT topic and process messages
mosquitto_sub -h "$mqtt_host" -u "$mqtt_user" -P "$mqtt_pass" -p "$mqtt_port" -t "$mqtt_topic" | while read -r message; do
  process_message "$message"
done
