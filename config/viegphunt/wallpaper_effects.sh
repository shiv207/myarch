#!/usr/bin/env bash

current_wallpaper_path=$(awww query | head -n 1 | awk -F'image: ' '/image:/ {print $2; exit}')
destination_wallpaper_dir="$HOME/.cache/awww"
mkdir -p "$destination_wallpaper_dir"

rm -f "$destination_wallpaper_dir/normal.png"
vipsthumbnail "$current_wallpaper_path" -o "$destination_wallpaper_dir/normal.png"

if [ -n "$current_wallpaper_path" ] && [ -f "$current_wallpaper_path" ]; then
    # Palette packs own colors when ~/.config/arch/current exists. Super+Alt+A still runs aether.
    if [ ! -f "$HOME/.config/arch/current" ]; then
        aether --generate "$current_wallpaper_path"
    fi
fi
