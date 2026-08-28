#!/usr/bin/env bash
# Extra backgrounds for the current palette.
# Drop files in ~/.config/arch/backgrounds/<theme-slug>/
set -euo pipefail
theme="$(cat "$HOME/.config/arch/current" 2>/dev/null || true)"
dirs=()
[[ -n "$theme" ]] && dirs+=("$HOME/.config/arch/themes/$theme/backgrounds")
[[ -n "$theme" ]] && dirs+=("$HOME/.config/arch/backgrounds/$theme")
dirs+=("$HOME/Pictures/Wallpapers")

if pidof rofi >/dev/null; then pkill rofi; fi

selected="$(
    for d in "${dirs[@]}"; do
        [[ -d "$d" ]] || continue
        find "$d" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | sort
    done | while read -r f; do
        printf '%s\0icon\x1f%s\n' "$(basename "$f")" "$f"
    done | rofi -dmenu -p "Background"
)"
[[ -z "$selected" ]] && exit 0

path="$(
    for d in "${dirs[@]}"; do
        [[ -d "$d" ]] || continue
        find "$d" -maxdepth 1 -type f -name "$selected" | head -n 1
    done | head -n 1
)"
[[ -n "$path" ]] && awww img "$path" --transition-type any --transition-duration 2
