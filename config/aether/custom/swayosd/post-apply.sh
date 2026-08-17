#!/bin/bash
pkill swayosd-server
sleep 0.3
swayosd-server --config /home/shiv/.config/swayosd/config.toml --style /home/shiv/.config/swayosd/style.css &
