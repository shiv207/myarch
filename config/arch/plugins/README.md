# Shell plugins

Omarchy’s desktop is one Quickshell process (`omarchy-shell`) with enable/disable plugins.

This setup does **not** load that. The equivalent pieces are separate programs:

| Role | Tool | Config |
| --- | --- | --- |
| Bar | Waybar | `~/.config/waybar/` |
| Notifications | SwayNC | `~/.config/swaync/` |
| OSD | SwayOSD | `~/.config/swayosd/` |
| Lock | hyprlock | `~/.config/hypr/hyprlock.conf` |
| Launcher | Rofi | `~/.config/rofi/` + `~/.config/viegphunt/app_launcher.sh` |
| Polkit | hyprpolkitagent | started from `autostart.lua` |

To add a “plugin”, edit Waybar’s modules (or drop a script under `~/.config/waybar/`) rather than cloning omarchy-shell plugins.
