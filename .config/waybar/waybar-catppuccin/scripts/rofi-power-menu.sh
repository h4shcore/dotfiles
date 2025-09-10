#!/bin/bash

# Define options and their icons
declare -A options=(
  ["󰐥 Shutdown"]="systemctl poweroff"
  ["󰜉 Reboot"]="systemctl reboot"
  ["󰤄 Lock"]="loginctl lock-session"
  ["󰤃 Suspend"]="systemctl suspend"
  ["󰍃 Logout"]="hyprctl dispatch exit" # Change to appropriate logout command
  ["󰈆 Cancel"]="exit 0"
)

# Generate menu
chosen=$(printf "%s\n" "${!options[@]}" | rofi -dmenu -p "Power Menu")

# Execute command
[[ -n "$chosen" ]] && eval "${options[$chosen]}"
