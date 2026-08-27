#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# myarch — one-shot installer
# Installs the complete Arch Hyprland rice (packages, configs, scripts,
# wallpapers, shell) on a fresh Arch Linux system.
#
# Usage:
#   bash install.sh            install everything (core stack + personal apps)
#   bash install.sh --core     install only the core interface stack
#
# Safe to run more than once. Existing configs are backed up, never deleted.
# ---------------------------------------------------------------------------

CORE_ONLY=0
if [ "${1:-}" = "--core" ]; then
    CORE_ONLY=1
fi

REPO_URL="https://github.com/shiv207/myarch.git"
GIT_NAME="${GIT_NAME:-shiv207}"
GIT_EMAIL="${GIT_EMAIL:-shivamshsr@gmail.com}"

# Absolute path to the dotfiles directory.
if [ -f "$PWD/install.sh" ] && [ -d "$PWD/config" ]; then
    DOTFILES_DIR="$PWD"
else
    DOTFILES_DIR="$HOME/myarch"
fi

log()  { printf '\n\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Package manifest (ground truth from a working myarch system)
# ---------------------------------------------------------------------------

CORE_PAC=(
    # Compositor and Wayland pillars
    hyprland hyprlock hypridle hyprshot hyprpolkitagent
    xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland
    swaync wlogout rofi rofi-emoji yad awww quickshell
    swayosd cliphist wl-clipboard brightnessctl
    pipewire pipewire-pulse wireplumber pavucontrol
    # Terminals, shell and everyday tools
    ghostty kitty fastfetch btop cava swappy ffmpeg
    nemo gvfs loupe celluloid gnome-text-editor evince obs-studio
    neovim
    # Input method (fcitx5 + bamboo)
    fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-bamboo
    # Qt, display manager, theming
    sddm qt5ct qt6ct qt5-wayland qt6-wayland kvantum kvantum-qt5
    ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-firacode-nerd ttf-opensans noto-fonts
    adw-gtk-theme nwg-look libvips libheif openslide poppler-glib gnome-characters keepass
    gsettings-desktop-schemas
    # Bluetooth and network
    blueman bluez bluez-utils network-manager-applet
    # Login shell bits
    zsh zsh-completions fzf lsd
    # Build toolchain (needed to build yay from the AUR)
    base-devel git curl wget python3
)

# AUR packages required by the interface itself.
CORE_AUR=(
    wlogout aether wallust-git
    apple_cursor whitesur-icon-theme ttf-segoe-ui-variable
    zen-browser-bin
)

# Personal applications. Skipped with --core. Not required for the interface.
EXTRA_AUR=(
    spotify whatsapp-linux-desktop-bin obsidian-bin localsend-bin
    visual-studio-code-bin oh-my-posh-bin pokemon-colorscripts-git
    nemo-preview ttf-victor-mono bluetui impala
)

# ---------------------------------------------------------------------------
# 0. Preflight
# ---------------------------------------------------------------------------

log "Preflight checks"

[ "$(uname -s)" = "Linux" ] || die "This installer targets Arch Linux on Linux."
command -v pacman >/dev/null || die "pacman not found. This installer is for Arch Linux only."

sudo -v || die "Sudo required. Run this script as a normal user with sudo access."
if [ "$(id -u)" -eq 0 ]; then
    die "Do not run as root. Run as a normal user; the script will sudo where needed."
fi

# ---------------------------------------------------------------------------
# 1. Get the dotfiles
# ---------------------------------------------------------------------------

if [ ! -d "$DOTFILES_DIR" ]; then
    log "Cloning dotfiles from $REPO_URL"
    git clone --depth 1 "$REPO_URL" "$DOTFILES_DIR"
fi
cd "$DOTFILES_DIR"

[ -d config ] || die "config/ not found in $DOTFILES_DIR. Something is wrong with the clone."

# Configure git identity if it is missing (used for future commits from this machine).
if [ -z "$(git config --global user.name 2>/dev/null || true)" ]; then
    git config --global user.name "$GIT_NAME"
fi
if [ -z "$(git config --global user.email 2>/dev/null || true)" ]; then
    git config --global user.email "$GIT_EMAIL"
fi

# ---------------------------------------------------------------------------
# 2. Reserve a backup location for anything we overwrite
# ---------------------------------------------------------------------------

BACKUP_DIR="$HOME/.config_backup_myarch_$(date +%Y%m%d_%H%M%S)"
log "Existing configs will be backed up to $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# ---------------------------------------------------------------------------
# 3. Install packages
# ---------------------------------------------------------------------------

log "Installing core packages from the official repos"
sudo pacman -S --needed --noconfirm "${CORE_PAC[@]}"

if ! command -v yay >/dev/null 2>&1; then
    log "yay not found, building it from the AUR"
    rm -rf /tmp/yay-build
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-build
    (cd /tmp/yay-build && makepkg -si --noconfirm)
fi

log "Installing core AUR packages"
yay -S --needed --noconfirm "${CORE_AUR[@]}"

if [ "$CORE_ONLY" -eq 0 ]; then
    log "Installing extras (personal applications)"
    yay -S --needed --noconfirm "${EXTRA_AUR[@]}"
fi

# ---------------------------------------------------------------------------
# 4. Deploy configs
# ---------------------------------------------------------------------------

log "Deploying configuration files"

mkdir -p "$HOME/.config"

for dir in config/*/; do
    name="$(basename "$dir")"
    if [ -e "$HOME/.config/$name" ]; then
        cp -rL "$HOME/.config/$name" "$BACKUP_DIR/"
    fi
done

# Copy the committed configs, resolving symlinks so the repo snapshot is intact.
cp -rL config/* "$HOME/.config/"

# The repo was authored with the original machine's absolute paths.
# Substitute them for this machine's home directory on every copied text file.
log "Rewriting machine-specific paths (/home/shiv -> \$HOME)"
grep -rlI '/home/shiv' "$HOME/.config/" 2>/dev/null | while read -r f; do
    sed -i "s|/home/shiv|$HOME|g" "$f"
done

# appearance.conf is a symlink to the live aether theme output on the reference
# machine. Recreate the same relationship so aether theme changes propagate.
log "Linking Hyprland appearance.conf to the aether theme output"
ln -sfn "$HOME/.config/aether/theme/hyprland-hyprland-appearance.conf" \
        "$HOME/.config/hypr/conf/appearance.conf"

log "Deploying helper scripts"
mkdir -p "$HOME/.local/bin"
cp -r bin/* "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/"*

log "Deploying shell dotfiles"
for f in .zshrc .zprofile .bashrc .bash_profile; do
    if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
        cp "$HOME/$f" "$BACKUP_DIR/" 2>/dev/null || true
    fi
    cp "$f" "$HOME/"
done

log "Deploying wallpapers"
mkdir -p "$HOME/Pictures/Wallpapers" "$HOME/Pictures/Screenshots"
cp -n wallpapers/* "$HOME/Pictures/Wallpapers/" 2>/dev/null || true

# ---------------------------------------------------------------------------
# 5. Shell: oh-my-zsh and plugins
# ---------------------------------------------------------------------------

if command -v zsh >/dev/null 2>&1; then
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Installing oh-my-zsh"
        git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
    fi

    ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    mkdir -p "$ZSH_CUSTOM_DIR"

    if [ ! -d "$ZSH_CUSTOM_DIR/zsh-autosuggestions" ]; then
        log "Installing zsh-autosuggestions"
        git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/zsh-autosuggestions"
    fi
    if [ ! -d "$ZSH_CUSTOM_DIR/zsh-syntax-highlighting" ]; then
        log "Installing zsh-syntax-highlighting"
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM_DIR/zsh-syntax-highlighting"
    fi
fi

# ---------------------------------------------------------------------------
# 6. First-time theme and wallpaper bootstrap
# ---------------------------------------------------------------------------

FIRST_WALLPAPER="$(find "$HOME/Pictures/Wallpapers" -type f | sort | head -n 1 || true)"
if [ -n "$FIRST_WALLPAPER" ] && command -v aether >/dev/null 2>&1; then
    log "Generating the initial aether theme from $FIRST_WALLPAPER"
    aether --generate "$FIRST_WALLPAPER" --no-zed --no-vscode 2>/dev/null \
        || aether --generate "$FIRST_WALLPAPER" --no-zed --no-vscode
fi

# If this script is being run from inside a running Hyprland session, apply the
# wallpaper live. Otherwise the daemon will pick it up at the next login.
if [ "${XDG_SESSION_TYPE:-}" = "wayland" ] && command -v awww >/dev/null 2>&1 \
   && [ -n "$FIRST_WALLPAPER" ]; then
    log "Applying wallpaper in the live session"
    awww img "$FIRST_WALLPAPER" --transition-type any --transition-duration 2 || true
    ~/.config/viegphunt/wallpaper_effects.sh || true
fi

# ---------------------------------------------------------------------------
# 7. Services
# ---------------------------------------------------------------------------

log "Enabling SDDM (display manager)"
sudo systemctl enable sddm 2>/dev/null || warn "Could not enable sddm; enable manually: sudo systemctl enable sddm"

if [ "$(getent passwd "$USER" | cut -d: -f7)" != "/usr/bin/zsh" ] && command -v chsh >/dev/null 2>&1; then
    log "Setting zsh as the login shell"
    chsh -s /usr/bin/zsh || warn "Could not set zsh as login shell; run: chsh -s /usr/bin/zsh"
fi

# ---------------------------------------------------------------------------
# 8. Verification
# ---------------------------------------------------------------------------

log "Verifying installation"

FAILED=0
check() {
    if command -v "$1" >/dev/null 2>&1; then
        printf '  [ OK ] %s\n' "$1"
    else
        printf '  [FAIL] %s\n' "$1"
        FAILED=1
    fi
}

for bin in hyprland hyprctl swaync wlogout rofi awww aether wallust \
           swayosd-client swayosd-server cliphist ghostty kitty fastfetch \
           btop cava swappy nemo kvantum fcitx5 zsh fzf lsd quickshell; do
    check "$bin"
done

if [ "$FAILED" -eq 0 ]; then
    echo ""
    log "All core binaries present. Installation complete."
    echo ""
    echo "  Next steps:"
    echo "    1. Reboot:              sudo reboot"
    echo "    2. SDDM will ask for your user and password."
    echo "    3. Choose the Hyprland session at login."
    echo "    4. Super+H shows every keybinding. Alt+Space opens the app launcher."
    echo ""
    echo "  Notes:"
    echo "    - ~/.local/bin/fetch is a custom compiled binary not shipped here;"
    echo "      the terminal startup summary uses fastfetch."
    echo "    - First wallpaper generation writes ~/.cache/awww/normal.png for"
    echo "      the lock screen. Switching wallpapers with Super+W refreshes it."
    echo "    - Backups of previous configs live in: $BACKUP_DIR"
else
    warn "Some binaries are missing. Check the [FAIL] entries above and their packages."
    exit 1
fi