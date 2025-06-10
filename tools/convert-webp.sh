#!/bin/bash

# Path to the directory containing original images
input_dir="./assets/original-image"

# Path to the directory containing WebP images
output_dir="./assets/images"

# Check if the output directory exists, if not, create it
if [ ! -d $output_dir ]; then
  mkdir -p $output_dir
fi

# Get a list of files in the input directory
files=$(ls $input_dir)

# Iterate through each file and convert to WebP if it's an image (excluding gif files)
for file in $files; do
  # Create the WebP file name by changing the file extension
  webp_file="$output_dir/$(basename $file .png).webp"

  # Check if the file is an image (excluding gif files)
  if [[ ($file == *".jpg" || $file == *".jpeg") ]]; then
    # Use the cwebp tool to convert
    cwebp -q 1 $input_dir/$file -o $webp_file

    echo "Converted $file to $webp_file"
  else
    # If it's not an image, copy it to the output directory as is
    cp $input_dir/$file $output_dir/

    echo "Copied $file to $output_dir/"
  fi
done
