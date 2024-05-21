#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <json_file> <new_trigger_value"
  exit 1
fi

json_file=$1
new_trigger_value=$(echo "$2" | jq)

echo "$2"

if [ -f "$json_file" ]; then
  existing_content=$(cat "$json_file")
else
  echo "Error: JSON file does not exist."
  exit 1
fi

# Merge the new content under the key "Annotation" into the existing JSON content
merged_content=$(jq --argjson newTrigger "$new_trigger_value" '. + { "Annotation": $newTrigger }' <<< "$existing_content")

# Write the merged content back to the JSON file
echo "$merged_content" > "$json_file"
