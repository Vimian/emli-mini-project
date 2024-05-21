#!/bin/bash

WILDLIFE_CAMERA_SSID="EMLI-TEAM-6-2.4"
SSH_PASS_FILE="./ssh_pass"

echo "Synchronizing time with wildlife camera..."
CAMERA_IP="192.168.10.1"  # Replace with actual IP
DRONE_TIME=$(date "+%s")
sshpass -f $SSH_PASS_FILE ssh g6@$CAMERA_IP "sudo date -s '@$DRONE_TIME'"
echo "Time synchronized to $(date)"
