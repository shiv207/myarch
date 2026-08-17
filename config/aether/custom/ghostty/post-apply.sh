#!/bin/bash
# Reload Ghostty in place: send SIGUSR2 (handled by the GTK build) so the new
# theme applies without restarting the terminal.
# Aether writes theme templates asynchronously, so wait until the theme file's
# mtime stops changing before signalling.

theme_file="$HOME/.config/ghostty/themes/aether-generated.conf"

if [ -f "$theme_file" ]; then
    last=""
    stable=0
    for _ in $(seq 1 30); do
        cur=$(stat -c %y "$theme_file")
        if [ "$cur" = "$last" ]; then
            stable=$((stable + 1))
            [ "$stable" -ge 2 ] && break
        else
            stable=0
        fi
        last="$cur"
        sleep 0.3
    done

    for pid in $(pgrep -x ghostty); do
        kill -USR2 "$pid"
    done
fi

notify-send "Ghostty" "Theme updated" -i terminal