#!/bin/bash
ACTIVE=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class')
if [[ "$ACTIVE" != "nemo" && "$ACTIVE" != "Nemo" ]]; then
    exit 0
fi

xdotool key --clearmodifiers F2
