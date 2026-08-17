#!/bin/bash
ACTIVE=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class')
if [[ "$ACTIVE" != "nemo" && "$ACTIVE" != "Nemo" ]]; then
    exit 0
fi

ydotool key 29:1 46:1 46:0 29:0
sleep 0.1

FILE=$(wl-paste 2>/dev/null | head -1)

if [ -n "$FILE" ] && [ -e "$FILE" ]; then
    nemo-preview "$FILE" &
fi
