#!/bin/sh

# Prompt user to select a region using slurp
region=$(slurp)

# Check if a region was selected
if [ -n "$region" ]; then
  # Take screenshot using grim with the selected region
  grim -g "$region" ~/Pictures/screenshots/ss-$(date +%Y-%m-%d_%H-%M-%S).png

  # Notify user
  notify-send "Screenshot saved" "Region screenshot saved to ~/Pictures/screenshots/"
else
  # If no region is selected, display error
  notify-send "No selection" "No region was selected for the screenshot"
fi
