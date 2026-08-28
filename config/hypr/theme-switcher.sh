#!/usr/bin/env bash
# Dedicated theme switcher helper for Hyprland setup.
# Runs the graphical theme carousel, applies the selected theme,
# and explicitly pushes the color palette to the running Quickshell topbar.

export ARCH_PATH="${ARCH_PATH:-/home/shiv/Developer/arch}"
export OMARCHY_PATH="${ARCH_PATH}"
export PATH="$ARCH_PATH/bin:$HOME/.local/bin:$PATH"

# 1. Run the graphical theme switcher (carousel in center of screen)
selected_theme="$(arch-theme-switcher)"

# If cancelled or empty, exit
[[ -z "$selected_theme" ]] && exit 0

# 2. Apply theme files and reload hyprctl / apps
arch-theme-set "$selected_theme"

# 3. Explicitly push the color palette to Quickshell
THEME_PATH="$HOME/.local/state/arch/current/theme"
if [[ -f "$THEME_PATH/colors.toml" ]]; then
  COLORS="$(base64 -w0 "$THEME_PATH/colors.toml" 2>/dev/null)"
  SHELL_CONF="$([[ -f "$THEME_PATH/shell.toml" ]] && base64 -w0 "$THEME_PATH/shell.toml" 2>/dev/null || echo "")"
  if [[ -n "$COLORS" ]]; then
    arch-shell shell applyTheme "$COLORS" "$SHELL_CONF" >/dev/null 2>&1 || true
  fi
fi

notify-send "Theme" "Applied $selected_theme" -t 2000 2>/dev/null || true
