#!/usr/bin/zsh

###############################################################################
#                     ZSH Configuration for Ubuntu                             #
#                     https://github.com/pongstr/dotfiles                       #
###############################################################################

# Disable compfix for shared environments
ZSH_DISABLE_COMPFIX="true"

# Path to Oh-My-Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set default editor
export EDITOR='vim'
export VISUAL='vim'

# Set name of the theme to load
# See: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="pongstr"

# Case-sensitive completion
CASE_SENSITIVE="true"

# Auto-update settings
DISABLE_AUTO_UPDATE="false"
export UPDATE_ZSH_DAYS=14

# Disable auto-setting terminal title
DISABLE_AUTO_TITLE="true"

# Enable command auto-correction
ENABLE_CORRECTION="false"

# Display red dots whilst waiting for completion
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# History settings
HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

###############################################################################
# Plugins
###############################################################################

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
    git
    docker
    docker-compose
    node
    npm
    nvm
    pip
    python
    ubuntu
    sudo
    history
    command-not-found
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

###############################################################################
# Environment Variables
###############################################################################

# Homebrew (Linuxbrew)
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Neovim
if [ -d "/opt/nvim-linux64" ]; then
    export PATH="$PATH:/opt/nvim-linux64/bin"
fi

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# Pyenv
if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)" 2>/dev/null
    eval "$(pyenv init -)" 2>/dev/null
fi

# Go
if [ -d "/usr/local/go" ]; then
    export PATH="$PATH:/usr/local/go/bin"
    export GOPATH="$HOME/go"
    export PATH="$PATH:$GOPATH/bin"
fi

# Rust
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# GPG
export GPG_TTY=$(tty)

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac

###############################################################################
# Aliases - File Operations
###############################################################################

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

###############################################################################
# Aliases - Directory Navigation
###############################################################################

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Directory shortcuts
alias dirs='dirs -v'
alias push='pushd'
alias pop='popd'

###############################################################################
# Aliases - System
###############################################################################

alias hh='history'
alias h='history | tail -20'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias top='htop'
alias ports='netstat -tulanp'
alias myip='curl -s https://api.ipify.org && echo'

###############################################################################
# Aliases - Git
###############################################################################

alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gpl='git pull'
alias gl='git lg'
alias gll='git ll'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gm='git merge'
alias gr='git rebase'
alias gri='git rebase -i'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'

###############################################################################
# Aliases - Docker
###############################################################################

alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlogs='docker logs -f'
alias dprune='docker system prune -af'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'

###############################################################################
# Aliases - Node.js / NPM
###############################################################################

alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias nrl='npm run lint'
alias npmlist='npm list -g --depth=0'
alias npmclean='find . -name "node_modules" -type d -prune -exec rm -rf {} +'
alias npmoutdated='npm outdated'
alias npmupdate='npm update'

# pnpm aliases
alias pni='pnpm install'
alias pnr='pnpm run'
alias pnrd='pnpm run dev'
alias pnrb='pnpm run build'

# yarn aliases
alias yi='yarn install'
alias ya='yarn add'
alias yad='yarn add -D'
alias yr='yarn run'

###############################################################################
# Aliases - Python
###############################################################################

alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

###############################################################################
# Aliases - Editors
###############################################################################

alias v='vim'
alias nv='nvim'
alias code='code'
alias c='cursor'

###############################################################################
# Aliases - Ubuntu/Apt
###############################################################################

alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias purge='sudo apt purge'
alias autoremove='sudo apt autoremove -y'
alias search='apt search'

###############################################################################
# Aliases - Modern CLI Replacements (if installed)
###############################################################################

# Use bat instead of cat if available
if command -v batcat &>/dev/null; then
    alias cat='batcat --paging=never'
    alias bat='batcat'
fi

# Use eza instead of ls if available
if command -v eza &>/dev/null; then
    alias ls='eza --icons'
    alias ll='eza -lah --icons'
    alias la='eza -a --icons'
    alias lt='eza --tree --icons'
fi

# Use fd instead of find if available
if command -v fdfind &>/dev/null; then
    alias fd='fdfind'
fi

###############################################################################
# Functions
###############################################################################

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find file by name
ff() {
    find . -type f -name "*$1*"
}

# Find directory by name
fd() {
    find . -type d -name "*$1*"
}

# Get weather
weather() {
    curl "wttr.in/${1:-}"
}

# Quick HTTP server
serve() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Git branch cleanup - delete merged branches
git-cleanup() {
    git branch --merged | grep -v '\*\|main\|master\|develop' | xargs -n 1 git branch -d
}

# Docker shell into container
dsh() {
    docker exec -it "$1" /bin/bash || docker exec -it "$1" /bin/sh
}

# Kill process by port
killport() {
    lsof -ti:"$1" | xargs kill -9
}

# Quick note taking
note() {
    local notes_dir="$HOME/notes"
    mkdir -p "$notes_dir"
    if [ -z "$1" ]; then
        ls -la "$notes_dir"
    else
        $EDITOR "$notes_dir/$1.md"
    fi
}

###############################################################################
# NVM auto-use .nvmrc
###############################################################################

autoload -U add-zsh-hook
load-nvmrc() {
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

        if [ "$nvmrc_node_version" = "N/A" ]; then
            nvm install
        elif [ "$nvmrc_node_version" != "$node_version" ]; then
            nvm use
        fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
        echo "Reverting to nvm default version"
        nvm use default
    fi
}

# Load .nvmrc on directory change
if command -v nvm &>/dev/null; then
    add-zsh-hook chpwd load-nvmrc
    load-nvmrc 2>/dev/null
fi

###############################################################################
# Welcome Message
###############################################################################

# Uncomment for a welcome message
# echo "Welcome back, $(whoami)! 👋"
# echo "Today is $(date '+%A, %B %d, %Y')"
