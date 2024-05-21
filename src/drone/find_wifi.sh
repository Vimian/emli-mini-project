#!/bin/bash

WILDLIFE_CAMERA_SSID="EMLI-TEAM-6-2.4"
WILDLIFE_CAMERA_PASS="letmein6"
RETRY_INTERVAL=5
CONNECTED_SLEEP=300
DB_FILE="./wifi_log.db"

connect_to_wifi() {
  nmcli dev wifi connect "$WILDLIFE_CAMERA_SSID" password "$WILDLIFE_CAMERA_PASS"
}

while true; do
  # Check if connected to the Wildlife Camera SSID
  if iwgetid -r | grep -q "$WILDLIFE_CAMERA_SSID"; then
    echo "Connected to WiFi sleeping synchronizing time"
    ./sync_time.sh
    echo "Now sleeping for $CONNECTED_SLEEP"
    sleep $CONNECTED_SLEEP
  else
    echo "Not connected to $WILDLIFE_CAMERA_SSID. Attempting to connect..."
    connect_to_wifi
  fi
  sleep $RETRY_INTERVAL
done
