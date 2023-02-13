#!/bin/bash

##################
# indexer for videos
###################

counter=1
for file in *.mp4; do
  if [ -f "$file" ]; then
    new_name="$(printf "%04d" $counter).${file##*.}"
    echo "moving $file to $new_name!"
    mv "$file" "$new_name"
    ./converter.sh -i $new_name -o edited.$new_name
    rm $new_name
    counter=$((counter + 1))
  fi
done

if [ $counter -eq 1 ]; then
  echo "No video files found in the current directory. Files must use the .mp4 file extension"
fi