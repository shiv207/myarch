# If you come from bash you might have to change your $PATH.
export PATH="$HOME/.local/bin:$PATH"
export ARCH_PATH="/home/shiv/Developer/arch"
export OMARCHY_PATH="/home/shiv/Developer/arch"
export PATH="$OMARCHY_PATH/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"

ZSH_THEME=""

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# fastfetch. Will be disabled if above colorscript was chosen to install
fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Alias for animated fetch
alias animfetch="$HOME/.local/bin/fetch"

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# kurealnum workflow aliases (paths rewritten off /home/oscar)
alias py='python3'
alias plz='sudo'
alias please='sudo'
alias notes='cd ~/notes/ && nvim'
alias wn='python3 $HOME/.config/scripts/whatnext.py'
alias encode='. $HOME/.config/scripts/encode.sh'
alias springclean='$HOME/.config/scripts/sysmaintenance.sh'
alias gwtp='git worktree prune'

nwt() {
    if [ -z "$1" ]; then
        echo "Usage: nwt <branch-name>"
        return 1
    fi
    local folder_name="${1//\//-}"
    git fetch
    git worktree add "../$folder_name" "$1"
    cd "../$folder_name" || return
}

rmwt() {
    if [ -z "$1" ]; then
        echo "Usage: rmwt <branch-name>"
        return 1
    fi
    local folder_name="${1//\//-}"
    git worktree remove "../$folder_name"
}

gfch() {
    if [ -z "$1" ]; then
        echo "Usage: gfch <branch>"
        return 1
    fi
    git fetch
    git checkout "$1"
}

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Starship prompt. Oh-my-zsh theme left empty above.
eval "$(starship init zsh)"

alias sysupdate='sys-update'

# Optional extra work helpers
# [ -f "$HOME/.config/zsh/kureal-work.zsh" ] && source "$HOME/.config/zsh/kureal-work.zsh"


# Added by Antigravity CLI installer
export PATH="/home/shiv/.local/bin:$PATH"
