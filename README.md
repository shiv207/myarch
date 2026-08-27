# MyArch

A minimal, keyboard-driven Wayland desktop environment built on Arch Linux and Hyprland. Designed for zero-friction workflows, aesthetic precision, and quiet efficiency.

---

## Overview

This setup is the result of stripping away visual noise and focusing entirely on speed and utility. Every element—from window tiling parameters to custom progress overlays—serves an explicit purpose.

The aesthetic is built around adaptive color schemes generated dynamically from wallpapers, maintaining visual consistency across terminal windows, bar modules, and application launchers.

---

## Preview

### Clean Workspace
![Clean Workspace](screenshots/setup.png)

A clean view showing the minimal top bar, discrete workspace indicators, and default system state.

### Tiling & Active Workflow
![Tiling Layout](screenshots/tile.png)

Hyprland dwindle layout managing active windows with clean gaps, border accents, and high-readability typography.

### Application Launcher
![Rofi Launcher](screenshots/rofi.png)

Centered application launcher providing fast, fuzzy-search access to applications, system controls, and clipboard history.

### Warm Palette Variant
![Gruvbox Palette](screenshots/setup_gruvboc.png)

An alternative warm palette dynamically applied across the entire desktop via the internal theme engine.

---

## System Architecture

### 1. Window Management (Hyprland)
Hyprland operates as the Wayland compositor. Key structural choices:
- Layout: Dwindle layout handles automatic window splitting without manual management.
- Window Rules: Specific utility windows (e.g., floating terminal tools, volume/brightness overlays) are assigned explicit window rules to automatically float, center, and resize without breaking tiling workflows.
- Input Configuration: Acceleration profiles and key repeat rates are tuned for direct, instant response.

### 2. Dynamic Color Engine (Aether & Wallust)
The desktop color scheme adapts automatically to whichever wallpaper is active:
- When a wallpaper is selected, Wallust extracts a dominant color palette.
- Aether applies those colors across configuration files in real time.
- Hyprland border colors, bar styles, GTK themes, and terminal color sequences update instantly without restarting the Wayland session.

### 3. Status Bar (Quickshell)
The top bar is a Quickshell build written in QML, launched through a systemd user service (`omarchy-shell.service`):
- Left: Workspace selector showing active and populated workspace states.
- Center: Currently focused window title, auto-truncated to preserve visual balance.
- Right: System indicators including network status, battery level, audio volume, and clock.

### 4. On-Screen Display (SwayOSD)
Hardware volume and brightness keys bypass default notify-daemon alerts:
- Custom shell scripts (`vol-osd` and `brightness-osd`) query current hardware state using `wpctl` and `brightnessctl`.
- Values are sent directly to `swayosd-client`, rendering smooth, translucent floating progress bars centered on screen.

### 5. Launchers & System Utilities (Rofi & Viegphunt)
Rofi acts as the core modal interface:
- App Launcher: Launched via `Alt+Space`.
- Clipboard History: Integrates with `wl-paste` and `cliphist` via `Super+V`.
- Wallpaper Selector: Triggered via `Super+W` to browse and select wallpapers with immediate theme regeneration.
- Keybinding Hints: A helper script accessible via `Super+H` listing all active system keybindings.

### 6. Terminal & Shell Environment
- Terminals: Ghostty and Kitty configured with minimal padding, explicit font sizing, and GPU acceleration.
- Shell: Zsh managed via Oh My Zsh with `zsh-autosuggestions` and `zsh-syntax-highlighting`.
- Telemetry: Fastfetch configured for instant system summary upon terminal spawn.

---

## Keybindings

| Keybinding | Action |
| --- | --- |
| `Super + Space` | Open Terminal |
| `Alt + Space` | Application Launcher |
| `Super + Q` | Close active window |
| `Super + F` | Toggle window float mode |
| `Super + V` | Open clipboard manager |
| `Super + W` | Open wallpaper picker |
| `Super + Shift + W` | Set random wallpaper |
| `Super + H` | Display keybinding hints |
| `Super + Shift + S` | Capture region screenshot |
| `Super + L` | Lock screen (Hyprlock) |
| `Super + 1..9` | Switch to workspace 1..9 |

---

## Directory Structure

```
myarch/
├── config/
│   ├── hypr/          # Hyprland compositor & modular configs
│   ├── quickshell/    # Quickshell bar (QML) & overview components
│   ├── rofi/          # Application launcher & theme styles
│   ├── swaync/        # Notification center configuration
│   ├── swayosd/       # On-screen display styles
│   ├── ghostty/       # Ghostty terminal config
│   ├── kitty/         # Kitty terminal config
│   ├── fastfetch/     # Telemetry fetch configuration
│   ├── nvim/          # Neovim text editor config
│   └── viegphunt/     # Utility scripts for launcher & wallpaper switching
├── bin/               # Custom shell scripts (OSD controls, floating launchers)
├── wallpapers/        # Selected wallpaper collection
├── screenshots/       # Preview screenshots
├── install.sh         # One-shot installer for a fresh Arch system
├── blackbox.md        # Agentic install prompt (hand this to any coding agent)
├── .zshrc             # Shell runtime configuration
└── README.md
```

---

## Installation

### One-shot script

Fresh Arch system, packages through the display manager, done. The installer takes care of everything: official and AUR packages, configuration deployment, helper scripts, wallpapers, the zsh setup, and the first theme generation. It backs up anything it overwrites and can be re-run safely.

```bash
curl -fsSL https://github.com/shiv207/myarch/raw/main/install.sh -o install.sh && bash install.sh
```

- Everything, including personal applications (Spotify, WhatsApp, Obsidian, VS Code): run it without arguments.
- Interface only, no personal applications: `bash install.sh --core`

What happens under the hood, in order:

1. Preflight — arch, non-root user, sudo availability.
2. Clones the repository into `~/myarch` if it is not already there.
3. Backs up any existing config directories to `~/.config_backup_myarch_<timestamp>`.
4. Installs the core stack from the official repos, builds `yay` from the AUR if missing, then installs the AUR packages.
5. Deploys `config/` to `~/.config/`, rewrites the author's machine-specific paths (`/home/shiv`) to yours, recreates the Hyprland appearance symlink that feeds off the aether theme output, installs scripts to `~/.local/bin/`, dotfiles to `$HOME`, and wallpapers to `~/Pictures/Wallpapers/`.
6. Sets up oh-my-zsh with `zsh-autosuggestions` and `zsh-syntax-highlighting`, moves your login shell to zsh.
7. Generates the first aether theme from the first wallpaper and primes the lock-screen background.
8. Enables SDDM, verifies every binary is present, and reports.

After the installer finishes: reboot, pick the Hyprland session at the SDDM login screen, press `Super+H` for the keybinding list.

### Agentic install (alternative)

If something between the script and your machine disagrees, or you simply prefer to watch an agent do the work: hand the entire contents of `blackbox.md` to any agentic CLI (opencode, Claude Code, Codex, Cursor) and let it install, verify, and report.

The prompt is written the way install prompts should be written: the repository is declared the single source of truth, every phase ends in a verification gate with real command output as evidence, speculation is explicitly forbidden, retries are bounded, the agent must deliberately attempt to break its own install before reporting success, and the final report contract forces it to show the commands it ran rather than claim completion. It is safe to re-run, and any deviation from its instructions must be disclosed in the report.

```bash
git clone https://github.com/shiv207/myarch.git ~/myarch && cd ~/myarch
# paste the contents of blackbox.md into your agent, or:
opencode "$(cat blackbox.md)"
```

Requires: Arch Linux, an x86_64 machine, a non-root user with sudo, and network access.

---

## Credits

Inspired by community Hyprland ecosystem projects. Crafted for daily productivity.
