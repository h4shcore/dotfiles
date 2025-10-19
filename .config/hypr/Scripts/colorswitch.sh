#!/bin/sh

WALLPAPER_DIR="$HOME/Pictures/wallpapers/"

WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)

matugen image $WALLPAPER

pkill dunst

dunstify "enjoy your new colorschem!"
