#!/bin/bash

# Serial port configuration
serial_port="/dev/ttyACM0"

if [ ! -e "$serial_port" ]; then
  echo "Serial port $serial_port not found. Please check the connection."
  exit 1
fi

stty -F "$serial_port" 115200 raw -echo

# MQTT connection details
mqtt_host="localhost"
mqtt_user="g6"
mqtt_pass="letmein"
mqtt_port=1883
mqtt_rain_topic="rain_sensor_output"
mqtt_raining_topic="raining"

# Function to process lines read from the serial port
process_line() {
  local line="$1"
  
  rain_detect=$(echo "$line" | jq -r '.rain_detect')
  
  # Check if rain_detect is 1
  if [ "$rain_detect" -eq 1 ]; then
    # Publish the line to the MQTT topic
    mosquitto_pub -d -h "$mqtt_host" -u "$mqtt_user" -P "$mqtt_pass" -p "$mqtt_port" -t "$mqtt_rain_topic" -m "$line"
  fi
}

# Function to send "hello" to the serial port
send_hello_to_serial() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S') - serial_to_mqtt_to_serial.sh] Received wipe command, sending serial command" >> /home/g6/emli-mini-project/log/log.txt
  echo -n "{wiper_angle:180}" > "$serial_port"
  sleep 1
  echo -n "{wiper_angle:0}" > "$serial_port"
  sleep 1
}

trap "exit_gracefully" SIGINT

exit_gracefully() {
  echo "Terminating script..."
  kill $serial_pid
  kill $mqtt_pid
  exit 0
}

# Listen to the serial port and process lines
cat "$serial_port" | while read -r line; do
  process_line "$line"
done &
serial_pid=$!

# Listen to the MQTT topic and send "hello" to the serial port when a message is received
mosquitto_sub -h "$mqtt_host" -u "$mqtt_user" -P "$mqtt_pass" -p "$mqtt_port" -t "$mqtt_raining_topic" | while read -r message; do
  send_hello_to_serial
done &
mqtt_pid=$!

# Wait for background processes to complete
wait $serial_pid
wait $mqtt_pid
