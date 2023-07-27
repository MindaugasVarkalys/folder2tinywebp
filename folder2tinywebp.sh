#!/bin/bash

API_KEY=YOUR_API_KEY	# Get your key at https://tinypng.com/developers

die() { echo >&2 "$0 ERROR: $@";exit 1;}            # Emergency exit function
[ "$1" ] || die "Argument missing."                 # Exit unless argument submitted
[ -d "$1" ] || die "Arg '$1' is not a directory."   # Exit if argument is not dir
cd "$1" || die "Can't access '$1'."                 # Exit unless access dir.

shopt -s extglob

files=(*.@(png|webp|jpg))                           # All files names in array $files
[ -f "$files" ] || die "No files found."            # Exit if no files found

for f in "${files[@]}"
do
  echo "Processing $f file..."
  LOCATION=`curl -si https://api.tinify.com/shrink --user api:$API_KEY --data-binary "@$f" | grep "location" | cut -c 11- | sed 's/.$//'`
  FILE_NAME=`echo "$f" | cut -d'.' -f1`
  curl -s "$LOCATION" --user api:$API_KEY --header "Content-Type: application/json" --data '{"convert":{"type":"image/webp"}}' --output "$FILE_NAME.webp"
done
