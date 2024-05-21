#!/bin/bash

WILDLIFE_CAMERA_SSID="EMLI-TEAM-6-2.4"
SYNC_INTERVAL=5
LOCAL_PHOTO_DIR="./photos"
CAMERA_IP="192.168.10.1"
SSH_PASS_FILE="./ssh_pass"
REMOTE_PHOTO_DIR="/home/g6/emli-mini-project/images"


while true; do
  # Check if connected to the Wildlife Camera SSID
  if iwgetid -r | grep -q "$WILDLIFE_CAMERA_SSID"; then
    echo "Connected to $WILDLIFE_CAMERA_SSID. Copying new photos..."

    # Fetch list of new images
    NEW_IMAGES=$(sshpass -f $SSH_PASS_FILE ssh g6@$CAMERA_IP "find $REMOTE_PHOTO_DIR -name '*.jpg'")

    for IMAGE in $NEW_IMAGES; do
      IMAGE_NAME=$(basename $IMAGE)
      RELATIVE_DIR=$(dirname "${IMAGE#$REMOTE_PHOTO_DIR/}")
      LOCAL_FILE_DIR="$LOCAL_PHOTO_DIR/$RELATIVE_DIR"
      LOCAL_IMAGE="$LOCAL_FILE_DIR/$IMAGE_NAME"

      # Assume the corresponding JSON file has the same name but with .json extension
      JSON_FILE="${IMAGE%.jpg}.json"
      JSON_NAME=$(basename $JSON_FILE)
      LOCAL_JSON="$LOCAL_FILE_DIR/$JSON_NAME"

      # Check if both the image and its JSON file exist locally
      if [ ! -f "$LOCAL_IMAGE" ] || [ ! -f "$LOCAL_JSON" ]; then
        # Create local directory if it doesn't exist
        mkdir -p "$LOCAL_FILE_DIR"

        # Update the JSON metadata on the Raspberry Pi
        sshpass -f $SSH_PASS_FILE ssh g6@$CAMERA_IP "jq '. += {\"Drone Copy\": {\"Drone ID\": \"WILDDRONE-001\", \"Seconds Epoch\": '\"$(date +%s.%3N)\"'}}' '$JSON_FILE' > '$JSON_FILE.tmp' && mv '$JSON_FILE.tmp' '$JSON_FILE'"
        echo "Updated metadata for $JSON_NAME on Raspberry Pi"

        # Copy the image
        sshpass -f $SSH_PASS_FILE scp g6@$CAMERA_IP:"$IMAGE" "$LOCAL_FILE_DIR"
        echo "Copied $IMAGE_NAME to $LOCAL_FILE_DIR"

        # Copy the JSON file
        sshpass -f $SSH_PASS_FILE scp g6@$CAMERA_IP:"$JSON_FILE" "$LOCAL_FILE_DIR"
        echo "Copied $JSON_NAME to $LOCAL_FILE_DIR"
      fi
    done
  else
    echo "Not connected to $WILDLIFE_CAMERA_SSID"
  fi
  sleep $SYNC_INTERVAL
done
