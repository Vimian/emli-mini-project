#!/bin/bash

# MQTT connection details
mqtt_host="localhost"
mqtt_user="g6"
mqtt_pass="letmein"
mqtt_port=1883
mqtt_topic="rain_sensor_output"

# Function to process each message
process_message() {
  local message="$1"
  # Extract the value of rain_detect using jq
  if echo "$message" | jq . >/dev/null 2>&1; then

    rain_detect=$(echo "$message" | jq -r '.rain_detect')

    # Check if rain_detect is 1
    if [ "$rain_detect" -eq 1 ]; then
      echo "[$(date +'%Y-%m-%d %H:%M:%S') - detect_rain.sh] Rain detected, wiping camera" >> /home/g6/emli-mini-project/log/log.txt
      mosquitto_pub -h localhost -u g6 -P letmein -p 1883 -t raining -m "IT RAINS"
    fi
  fi
}

# Subscribe to the MQTT topic and process messages
mosquitto_sub -h "$mqtt_host" -u "$mqtt_user" -P "$mqtt_pass" -p "$mqtt_port" -t "$mqtt_topic" | while read -r message; do
  process_message "$message"
done
