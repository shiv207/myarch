#!/usr/bin/env bash
# Super+T: pick a palette pack. Does not touch nvim/agents.

if pidof rofi >/dev/null; then
    pkill rofi
fi

THEMES_DIR="$HOME/.config/arch/themes"
[[ -d "$THEMES_DIR" ]] || exit 1

selected="$(
    find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | while read -r slug; do
        [[ -f "$THEMES_DIR/$slug/colors.toml" ]] || continue
        icon="$THEMES_DIR/$slug/preview.png"
        if [[ -f "$icon" ]]; then
            printf '%s\0icon\x1f%s\n' "$slug" "$icon"
        else
            printf '%s\n' "$slug"
        fi
    done | rofi -dmenu -p "Theme"
)"

[[ -z "$selected" ]] && exit 0

arch-theme-set "$selected"

# Push the new palette to the live shell explicitly.
THEME_PATH="$HOME/.local/state/arch/current/theme"
COLORS=$(base64 -w0 "$THEME_PATH/colors.toml" 2>/dev/null)
SHELL_CONF=$(base64 -w0 "$THEME_PATH/shell.toml" 2>/dev/null)
[[ -n "$COLORS" ]] && arch-shell shell applyTheme "$COLORS" "$SHELL_CONF" >/dev/null 2>&1

notify-send "Theme" "$selected" 2>/dev/null || true

