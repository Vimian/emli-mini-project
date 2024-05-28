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
for image_path in "$image_dir"/*/*.jpg; do
  if [ -e "$image_path" ]; then
    image_dis=$(echo "$image_path" | awk -F'/' '{print $(NF-1)}')
    image_name=$(basename "$image_path" .jpg)
    image_loc="$image_dis/$image_name"
    
    # Check if the image has already been processed
    if ! is_processed "$image_loc"; then
      # Run the description script
      echo "/../drone/photos/$image_name"
      ./make_description.sh "./../drone/photos/$image_loc"
      
      # Log the processed image name
      echo "$image_loc" >> "$log_file"
    fi
  fi
done

echo "Processing complete."
