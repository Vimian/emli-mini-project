#!/bin/bash

# Directory containing the images
image_dir="./../drone/photos"

# Log file to keep track of processed images
log_file="processed_images.log"

# Create the log file if it doesn't exist
touch "$log_file"

# Function to check if an image has been processed
is_processed() {
  local image_name="$1"
  grep -Fxq "$image_name" "$log_file"
}

# Iterate over each .jpg file in the directory
for image_path in "$image_dir"/*.jpg; do
  if [ -e "$image_path" ]; then
    image_name=$(basename "$image_path" .jpg)
    
    # Check if the image has already been processed
    if ! is_processed "$image_name"; then
      # Run the description script
      ./make_description.sh "/../drone/photos/$image_name"
      
      # Log the processed image name
      echo "$image_name" >> "$log_file"
    fi
  fi
done

echo "Processing complete."
