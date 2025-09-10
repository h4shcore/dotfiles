#!/bin/bash

options=(
  "󰤨  Wi-Fi"
  "󰂯  Bluetooth"
  "⏻  Power"
  "󰈆  Cancel"
)

# rofi menu launch
chosen=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "quick")

case "$chosen" in
  *"Wi-Fi"*) exec ~/scripts/rofi-wifi-menu.sh ;;
  *"Bluetooth"*) exec ~/scripts/rofi-bluetooth-menu.sh ;;
  *"Power"*) exec ~/scripts/rofi-power-menu.sh ;;
  *"Cancel"*|"") exit 0 ;;
esac
