#!/usr/bin/env bash
set -euo pipefail
theme="$(cat "$HOME/.config/arch/current" 2>/dev/null || true)"
state="$HOME/.cache/awww/cycle_index"
mkdir -p "$(dirname "$state")"

files=()
if [[ -n "$theme" ]]; then
    mapfile -t files < <(
        find "$HOME/.config/arch/themes/$theme/backgrounds" "$HOME/.config/arch/backgrounds/$theme" \
            -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) 2>/dev/null | sort
    )
fi
if [[ ${#files[@]} -eq 0 ]]; then
    mapfile -t files < <(find "$HOME/Pictures/Wallpapers" -maxdepth 1 -type f | sort)
fi
[[ ${#files[@]} -gt 0 ]] || exit 0

index=0
[[ -f "$state" ]] && index=$(cat "$state")
index=$((index + 1))
[[ "$index" -ge ${#files[@]} ]] && index=0
echo "$index" > "$state"
awww img "${files[$index]}" --transition-type any --transition-duration 2
