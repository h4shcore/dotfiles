#!/bin/sh

# Get the current date and time
timestamp=$(date '+%Y-%m-%d_%H-%M-%S')

# Define the output file name
output="$HOME/Pictures/screenshots/ss_$timestamp.png"

# Take a screenshot of a selected area using grim and slurp
grim -g "$(slurp)" "$output"

# Copy the screenshot to the clipboard using wl-clipboard
wl-copy < "$output"

echo "Screenshot saved as $output and copied to clipboard."
