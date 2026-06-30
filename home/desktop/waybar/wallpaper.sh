#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

choice=$(
    find "$WALLPAPER_DIR" -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
        -printf "%P\n" |
    sort |
    fuzzel --dmenu
)

[[ -z "$choice" ]] && exit 0

awww img "$WALLPAPER_DIR/$choice" \
    --transition-type grow \
    --transition-pos center \
    --transition-fps 60 \
    --transition-duration 1
