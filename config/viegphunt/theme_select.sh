#!/usr/bin/env bash

if pidof rofi > /dev/null; then
    pkill rofi
fi

CACHE_DIR="$HOME/.cache/omarchy-themes"
REPO_BASE="https://raw.githubusercontent.com/basecamp/omarchy/master/themes"

declare -A THEME_SLUG=(
    [Catppuccin]=catppuccin
    [Tokyo Night]=tokyo-night
    [Gruvbox]=gruvbox
    [Nord]=nord
)

declare -A THEME_BG=(
    [catppuccin]=1-totoro.png
    [tokyo-night]=0-swirl-buck.jpg
    [gruvbox]=1-the-backwater.jpg
    [nord]=1-city-view.png
)

mkdir -p "$CACHE_DIR"

for slug in "${THEME_SLUG[@]}"; do
    dir="$CACHE_DIR/$slug"
    mkdir -p "$dir"
    [ ! -f "$dir/icon.png" ] && curl -sL -o "$dir/icon.png" "$REPO_BASE/$slug/preview.png"
    [ ! -f "$dir/colors.toml" ] && curl -sL -o "$dir/colors.toml" "$REPO_BASE/$slug/colors.toml"
    [ ! -f "$dir/background" ] && curl -sL -o "$dir/background" "$REPO_BASE/$slug/backgrounds/${THEME_BG[$slug]}"
done

selected_theme=$(for name in "${!THEME_SLUG[@]}"; do
    echo -en "$name\0icon\x1f$CACHE_DIR/${THEME_SLUG[$name]}/icon.png\n"
done | rofi -dmenu -p "Theme")

[[ -z "$selected_theme" ]] && exit 0

slug="${THEME_SLUG[$selected_theme]}"
dir="$CACHE_DIR/$slug"

aether --import-colors-toml "$dir/colors.toml" --wallpaper "$dir/background"

echo "$slug" > "$HOME/.cache/awww/current_theme"

awww img "$dir/background" --transition-type any --transition-duration 2

notify-send "Theme applied" "$selected_theme" -i "$dir/icon.png"