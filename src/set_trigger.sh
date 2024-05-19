#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <json_file> <new_trigger_value"
  exit 1
fi

json_file=$1
new_trigger_value=$2

if [ ! -f "$json_file" ]; then
  echo "File not found: $json_file"
  exit 1
fi

jq --arg new_trigger "$new_trigger_value" '.Trigger = $new_trigger' "$json_file" > tmp.json && mv tmp.json "$json_file"


echo "Trigger value updated successfully"
