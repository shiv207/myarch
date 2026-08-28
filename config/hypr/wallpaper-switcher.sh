#!/usr/bin/env bash
# Dedicated wallpaper switcher helper for Hyprland setup.
# Runs the graphical wallpaper carousel and applies the chosen background.

export ARCH_PATH="${ARCH_PATH:-/home/shiv/Developer/arch}"
export OMARCHY_PATH="${ARCH_PATH}"
export PATH="$ARCH_PATH/bin:$HOME/.local/bin:$PATH"

# 1. Run the graphical wallpaper picker
selected_bg="$(arch-theme-bg-switcher)"

# If cancelled or empty, exit
[[ -z "$selected_bg" ]] && exit 0

# 2. Apply the chosen wallpaper
arch-theme-bg-set "$selected_bg"

notify-send "Wallpaper" "Applied $(basename "$selected_bg")" -t 2000 2>/dev/null || true
