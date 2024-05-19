#!/bin/bash

# Identify the serial port (adjust if necessary)
serial_port="/dev/ttyACM0"

# Check if the serial port exists
if [ ! -e "$serial_port" ]; then
  echo "Serial port $serial_port not found. Please check the connection."
  exit 1
fi

# Configure the serial port settings (baud rate, etc.)
stty -F "$serial_port" 115200 raw -echo

raining=0

# Function to process each line of input
process_line() {
  local line="$1"
  # Extract the value of rain_detect using jq
  rain_detect=$(echo "$line" | jq -r '.rain_detect')
  
  if [ "$rain_detect" -eq 1 -a $raining -eq 0 ]; then
    echo "It rains"
    raining=1
  elif [ "$rain_detect" -eq 0 ]; then
    raining=0
  fi
}

cat "$serial_port" | while read -r line; do
  process_line "$line"
done
