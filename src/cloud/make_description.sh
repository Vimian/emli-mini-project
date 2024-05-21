#!/bin/bash

path=$1

file="$path.jpg"
Model="llava:7b" 
Test=$(ollama run $Model "describe $file in one paragraph")

echo "$Test" 


JSON=$(cat <<EOF
{
 	"Source": "$Model",
	"Test": "${Test//\"/\\\"}"
}
EOF
)

./set_annotation.sh ".$path.json" "$JSON"
