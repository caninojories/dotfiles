# Ubuntu Development Environment Dotfiles 🚀

A comprehensive development environment setup for Ubuntu/Debian-based systems, inspired by [pongstr/dotfiles](https://github.com/pongstr/dotfiles).

## Features

- **One-command setup** - Bootstrap your entire development environment
- **SSH/GitHub configuration** - Automated SSH key generation and GitHub setup
- **Development tools** - VSCode, Cursor, Chrome, Chromium, Docker, DBeaver
- **Node.js management** - NVM with latest LTS Node.js
- **Custom ZSH theme** - Beautiful terminal with git status
- **Modern CLI tools** - bat, eza, fzf, lazygit, and more

## Quick Start

```bash
# Clone the repository
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles/ubuntu

# Make scripts executable
chmod +x bootstrap.sh
chmod +x scripts/*.sh

# Run the bootstrap script
./bootstrap.sh
```

## Directory Structure

```
ubuntu/
├── bootstrap.sh                 # Main installation script
├── configs/
│   ├── .editorconfig           # Editor configuration
│   ├── .tmux.conf              # tmux configuration
│   └── .zshrc                  # ZSH configuration
├── scripts/
│   ├── install-dev-tools.sh    # Development tools installer
│   ├── setup-git.sh            # Git configuration
│   ├── setup-github-ssh.sh     # GitHub SSH key setup
│   ├── setup-keyboard-mac.sh   # Mac keyboard & mouse layout
│   ├── setup-macos-appearance.sh # macOS-style dock & themes
│   └── setup-terminal.sh       # Terminal, ZSH, fonts setup
└── themes/
    └── pongstr.zsh-theme       # Custom Oh-My-Zsh theme
```

## What Gets Installed

### Essential Packages

- build-essential, curl, wget, git
- zsh, terminator
- openssh-client/server
- vim, neovim
- Various development libraries

### Development Tools

| Tool | Description |
|------|-------------|
| **VSCode** | Visual Studio Code editor |
| **Cursor** | AI-powered code editor |
| **Chrome** | Google Chrome browser |
| **Chromium** | Open-source Chromium browser |
| **Docker** | Container platform |
| **NVM** | Node Version Manager |
| **DBeaver** | Database management tool |
| **Git** | Latest version from PPA |
| **Homebrew** | Linuxbrew package manager |

### Additional Tools

- **lazygit** - Terminal UI for git
- **fzf** - Fuzzy finder
- **bat** - Better `cat` with syntax highlighting
- **eza** - Modern `ls` replacement
- **httpie** - Modern `curl` alternative
- **tmux** - Terminal multiplexer
- **Nerd Fonts** - JetBrainsMono & FiraCode

## Individual Scripts

### Install Development Tools Only

```bash
./scripts/install-dev-tools.sh
```

### Configure Git

```bash
./scripts/setup-git.sh
```

This will configure:
- User name and email
- Default branch (main)
- Pull/push settings
- Useful aliases (`git lg`, `git st`, etc.)
- Optional GPG signing

### Setup GitHub SSH

```bash
./scripts/setup-github-ssh.sh
```

This will:
- Generate Ed25519 SSH key
- Configure SSH for GitHub
- Display public key for adding to GitHub
- Optionally add key via GitHub CLI
- Test the connection

## ZSH Theme

The custom `pongstr.zsh-theme` provides:

```
⌚  10:30 AM
💀 my-project git:(main) ✗
```

- **Clock** - Current time with ⌚ emoji
- **Status** - 💀 (green = success, red = error)
- **Directory** - Current folder name
- **Git info** - Branch name with dirty/clean indicator

## Configuration

### .zshrc Highlights

- **NVM auto-switch** - Automatically uses `.nvmrc` when entering directories
- **Docker aliases** - Quick commands like `dps`, `dc`, `dlogs`
- **Git aliases** - Short commands like `gs`, `gco`, `gp`
- **Modern CLI** - Uses bat, eza, fd when available
- **Useful functions** - `mkcd`, `extract`, `serve`, etc.

### Key Aliases

```bash
# Git
gs    # git status
gco   # git checkout
gp    # git push
gl    # git log (pretty)

# Docker
dps   # docker ps
dc    # docker compose
dlogs # docker logs -f

# Node
ni    # npm install
nrd   # npm run dev
pnr   # pnpm run

# System
update  # apt update && upgrade
ll      # detailed ls
..      # cd ..
```

## Post-Installation

1. **Restart terminal** or run `source ~/.zshrc`

2. **Add SSH key to GitHub**:
   - Go to [GitHub SSH Settings](https://github.com/settings/ssh/new)
   - Paste your public key (copied to clipboard)

3. **Configure Docker** (logout required):
   ```bash
   # After logging out and back in
   docker run hello-world
   ```

4. **Install Node.js projects**:
   ```bash
   nvm install 20  # Install specific version
   nvm use 20      # Use it
   ```

## Mac-like Experience on Ubuntu

### Mac Keyboard & Mouse Layout

```bash
./scripts/setup-keyboard-mac.sh
```

Features:
- Swap Alt/Cmd keys (use Cmd for shortcuts like macOS)
- Magic Mouse support with gestures
- Touchpad gestures (pinch, swipe)
- Scroll speed & pointer speed configuration
- Option to install Kinto for full Mac keyboard emulation

### macOS-style Appearance

```bash
./scripts/setup-macos-appearance.sh
```

Features:
- Dock position (bottom, like macOS)
- Dock icon size customization
- Font scaling (bigger fonts)
- Window button position (left, like macOS)
- WhiteSur GTK theme (macOS Big Sur style)
- macOS icons and cursors
- Optional Plank dock

### Terminal Setup

```bash
./scripts/setup-terminal.sh
```

Features:
- ZSH installation
- Oh-My-Zsh with plugins (autosuggestions, syntax-highlighting)
- Theme selection (pongstr, agnoster, powerlevel10k, spaceship)
- Nerd Fonts (JetBrainsMono, FiraCode, MesloLGS)
- GNOME Terminal configuration (colors, transparency)
- Terminator with macOS keybindings
- tmux configuration

## Customization

### Add Custom Aliases

Edit `~/.zshrc` and add your aliases in the appropriate section.

### Change ZSH Theme

Edit `~/.zshrc`:
```bash
ZSH_THEME="robbyrussell"  # or any other theme
```

### Add Oh-My-Zsh Plugins

Edit `~/.zshrc`:
```bash
plugins=(
    git
    docker
    # add more plugins here
)
```

## Troubleshooting

### Docker Permission Denied

```bash
sudo usermod -aG docker $USER
# Then logout and login again
```

### NVM Not Found

```bash
source ~/.nvm/nvm.sh
```

### Fonts Not Displaying Correctly

Make sure your terminal is using a Nerd Font (JetBrainsMono or FiraCode).

## Requirements

- Ubuntu 20.04+ or Debian 11+
- `sudo` access
- Internet connection

## License

MIT License - Feel free to use and modify!

## Credits

Inspired by [pongstr/dotfiles](https://github.com/pongstr/dotfiles) (macOS version)
