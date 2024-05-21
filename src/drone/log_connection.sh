#!/bin/bash

WILDLIFE_CAMERA_SSID="EMLI-TEAM-6-2.4"
LOG_INTERVAL=1 # Log every 30 seconds
DB_FILE="./wifi_log.db"  # Replace with actual path to SQLite database

# Initialize SQLite database
sqlite3 $DB_FILE <<EOF
CREATE TABLE IF NOT EXISTS wifi_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  timestamp INTEGER,
  link_quality INTEGER,
  signal_level INTEGER
);
EOF

while true; do
  # Check if connected to the Wildlife Camera SSID
  if iwgetid -r | grep -q "$WILDLIFE_CAMERA_SSID"; then
    # Get WiFi link quality and signal level
    WIFI_INFO=$(awk '/wlp0s20f3/ { print int($3 * 100 / 70) " " int($4) }' /proc/net/wireless)
    LINK_QUALITY=$(echo $WIFI_INFO | cut -d' ' -f1)
    SIGNAL_LEVEL=$(echo $WIFI_INFO | cut -d' ' -f2)
    TIMESTAMP=$(date +%s)

    # Insert log into database
    sqlite3 $DB_FILE <<EOF
INSERT INTO wifi_log (timestamp, link_quality, signal_level) VALUES ($TIMESTAMP, $LINK_QUALITY, $SIGNAL_LEVEL);
EOF

    echo "Logged WiFi info at $TIMESTAMP: Link Quality=$LINK_QUALITY, Signal Level=$SIGNAL_LEVEL"
  else
    echo "Not connected to $WILDLIFE_CAMERA_SSID"
  fi
  sleep $LOG_INTERVAL
done

