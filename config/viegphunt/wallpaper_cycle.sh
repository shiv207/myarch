#!/usr/bin/env bash

themes_dir="$HOME/.cache/omarchy-themes"
state_dir="$HOME/.cache/awww"
theme_file="$state_dir/current_theme"
index_file="$state_dir/cycle_index"

theme=$(cat "$theme_file" 2>/dev/null)

wallpapers=()
if [ -n "$theme" ] && [ -d "$themes_dir/$theme" ]; then
    mapfile -t wallpapers < <(find "$themes_dir/$theme" -maxdepth 2 -type f \( -name background -o -path '*/wallpapers/*' \) | sort)
fi
if [ ${#wallpapers[@]} -eq 0 ]; then
    exit 0
fi
if [ ${#wallpapers[@]} -eq 0 ]; then
    exit 0
fi

index=0
[ -f "$index_file" ] && index=$(cat "$index_file" 2>/dev/null)
index=$((index + 1))
if [ "$index" -ge "${#wallpapers[@]}" ]; then
    index=0
fi
echo "$index" > "$index_file"

awww img "${wallpapers[$index]}" --transition-type any --transition-duration 2