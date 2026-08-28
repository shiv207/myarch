#!/usr/bin/env bash

if pidof yad > /dev/null; then
    pkill yad
fi

yad --center --title="Keybinding Hints" --no-buttons --list \
    --column=Key: --column="" --column=Description: \
    --timeout-indicator=bottom \
"  =   "          "        "  "SUPER KEY (Windows Key Button)" \
"" "" "" \
"  /"              "        "  "Show keybinding hints" \
"  Return / Space" "        "  "Open terminal" \
"  E"              "        "  "Open file manager" \
"  B"              "        "  "Open browser" \
"  D / ALT Space"  "        "  "App launcher" \
"  M"              "        "  "Power menu (wlogout)" \
"" "" "" \
"  H J K L"        "        "  "Focus window (vim)" \
"  Shift H J K L"  "        "  "Move window" \
"  R then HJKL"    "        "  "Resize mode (Esc to exit)" \
"  F"              "        "  "Fullscreen" \
"  Shift Space"    "        "  "Toggle floating" \
"  G"              "        "  "Toggle window group (tabs)" \
"  \\"             "        "  "Toggle dwindle split" \
"" "" "" \
"  Esc"            "        "  "Lock screen" \
"  Q"              "        "  "Close active window" \
"  Shift V"        "        "  "Close active window (alt)" \
"  V"              "        "  "Clipboard manager" \
"  W"              "        "  "Choose wallpaper" \
"  Shift W"        "        "  "Random wallpaper" \
"  N"              "        "  "Cycle wallpaper" \
"  T"              "        "  "Pick palette" \
"  Shift S / Print""        "  "Screenshot (region)" \
"  Ctrl W"         "        "  "Network (nmtui)" \
"  Ctrl Space"     "        "  "Theme backgrounds" \
"  Shift Backspace""        "  "Toggle gaps" \
"  Ctrl N"         "        "  "Night light" \
"  Ctrl ,"         "        "  "Do not disturb" \
"  Ctrl I"         "        "  "Stay awake (idle off)" \
"" "" "" \
"  [1 -> 0]"       "        "  "Switch workspace 1-10" \
"  Shift [1 -> 0]" "        "  "Move window to workspace 1-10" \
"" "" "" \
"More Keybinding"   "        "  "$HOME/.config/hypr/conf/keybinding.conf"
