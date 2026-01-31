#!/bin/bash

###############################################################################
#                     Ubuntu Development Environment Setup                      #
#                     https://github.com/pongstr/dotfiles                       #
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Banner
print_banner() {
    echo -e "${GREEN}"
    echo "  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗"
    echo "  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝"
    echo "  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗"
    echo "  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║"
    echo "  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║"
    echo "  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝"
    echo -e "${CYAN}           Ubuntu Development Environment Setup v1.0.0${NC}"
    echo ""
}

# Helper functions
print_step() {
    echo -e "\n${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_info() {
    echo -e "    ${CYAN}→${NC} $1"
}

print_warning() {
    echo -e "    ${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "    ${RED}✗${NC} $1"
}

print_success() {
    echo -e "    ${GREEN}✓${NC} $1"
}

# Check if running on Ubuntu/Debian
check_os() {
    if [ ! -f /etc/os-release ]; then
        print_error "Cannot detect OS. This script is designed for Ubuntu/Debian."
        exit 1
    fi

    . /etc/os-release
    if [[ "$ID" != "ubuntu" && "$ID" != "debian" && "$ID_LIKE" != *"ubuntu"* && "$ID_LIKE" != *"debian"* ]]; then
        print_error "This script is designed for Ubuntu/Debian-based systems."
        exit 1
    fi

    print_success "Detected: $PRETTY_NAME"
}

# Update system
update_system() {
    print_step "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    print_success "System updated"
}

# Install essential packages
install_essentials() {
    print_step "Installing essential packages..."

    local packages=(
        # Build essentials
        build-essential
        software-properties-common
        apt-transport-https
        ca-certificates
        gnupg
        lsb-release
        
        # Development tools
        curl
        wget
        git
        vim
        neovim
        tree
        unzip
        zip
        htop
        jq
        
        # Shell
        zsh
        terminator
        
        # Networking
        openssh-client
        openssh-server
        
        # Libraries for building Python, Node, etc.
        libssl-dev
        zlib1g-dev
        libbz2-dev
        libreadline-dev
        libsqlite3-dev
        libncurses-dev
        libffi-dev
        liblzma-dev
        libxml2-dev
        libxslt-dev
        
        # Additional utilities
        xclip
        fd-find
        ripgrep
    )

    for package in "${packages[@]}"; do
        print_info "Installing $package..."
        sudo apt install -y "$package" 2>/dev/null || print_warning "$package may already be installed or unavailable"
    done

    print_success "Essential packages installed"
}

# Install Homebrew (Linuxbrew)
install_homebrew() {
    print_step "Installing Homebrew (Linuxbrew)..."

    if command -v brew &>/dev/null; then
        print_info "Homebrew already installed, updating..."
        brew update && brew upgrade
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.profile"
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
        
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    print_success "Homebrew installed"
}

# Install Oh-My-Zsh
install_ohmyzsh() {
    print_step "Installing Oh-My-Zsh..."

    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_info "Oh-My-Zsh already installed, updating..."
        cd "$HOME/.oh-my-zsh" && git pull
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Install custom theme
    print_info "Installing custom ZSH theme..."
    cp "$SCRIPT_DIR/themes/pongstr.zsh-theme" "$HOME/.oh-my-zsh/themes/"

    # Install useful plugins
    print_info "Installing ZSH plugins..."

    # zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    fi

    # zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    fi

    print_success "Oh-My-Zsh installed with plugins"
}

# Copy configuration files
copy_configs() {
    print_step "Copying configuration files..."

    # Backup existing configs
    local backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"

    # Backup and copy .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$backup_dir/"
    fi
    cp "$SCRIPT_DIR/configs/.zshrc" "$HOME/.zshrc"

    # Backup and copy .gitconfig (if exists)
    if [ -f "$HOME/.gitconfig" ]; then
        cp "$HOME/.gitconfig" "$backup_dir/"
    fi

    # Backup and copy .tmux.conf
    if [ -f "$HOME/.tmux.conf" ]; then
        cp "$HOME/.tmux.conf" "$backup_dir/"
    fi
    cp "$SCRIPT_DIR/configs/.tmux.conf" "$HOME/.tmux.conf"

    # Copy .editorconfig
    cp "$SCRIPT_DIR/configs/.editorconfig" "$HOME/.editorconfig"

    print_info "Backup saved to: $backup_dir"
    print_success "Configuration files copied"
}

# Run individual installation scripts
run_installers() {
    print_step "Running installation scripts..."

    # Dev tools
    if [ -f "$SCRIPT_DIR/scripts/install-dev-tools.sh" ]; then
        print_info "Installing development tools..."
        bash "$SCRIPT_DIR/scripts/install-dev-tools.sh"
    fi

    # Git configuration
    if [ -f "$SCRIPT_DIR/scripts/setup-git.sh" ]; then
        print_info "Setting up Git configuration..."
        bash "$SCRIPT_DIR/scripts/setup-git.sh"
    fi

    # SSH/GitHub setup
    if [ -f "$SCRIPT_DIR/scripts/setup-github-ssh.sh" ]; then
        print_info "Setting up GitHub SSH..."
        bash "$SCRIPT_DIR/scripts/setup-github-ssh.sh"
    fi

    print_success "Installation scripts completed"
}

# Set ZSH as default shell
set_default_shell() {
    print_step "Setting ZSH as default shell..."

    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        print_success "ZSH set as default shell (restart required)"
    else
        print_info "ZSH is already the default shell"
    fi
}

# Main installation
main() {
    print_banner

    echo -e "${YELLOW}This script will install development tools and configure your Ubuntu system.${NC}"
    echo -e "${YELLOW}It requires sudo access for some installations.${NC}"
    echo ""
    read -p "Press Enter to continue or Ctrl+C to cancel..."

    # Check OS
    check_os

    # Update system
    update_system

    # Install essential packages
    install_essentials

    # Install Homebrew
    install_homebrew

    # Install Oh-My-Zsh
    install_ohmyzsh

    # Copy configuration files
    copy_configs

    # Run individual installers
    run_installers

    # Set ZSH as default shell
    set_default_shell

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Installation Complete! 🎉                          ║${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║  Please restart your terminal or run: source ~/.zshrc           ║${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}║  Additional setup:                                               ║${NC}"
    echo -e "${GREEN}║  • Run 'setup-github-ssh.sh' to configure GitHub SSH keys        ║${NC}"
    echo -e "${GREEN}║  • Run 'setup-git.sh' to configure Git user settings             ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
}

# Parse arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: ./bootstrap.sh [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h    Show this help message"
        echo "  --minimal     Install only essential packages"
        echo ""
        exit 0
        ;;
    --minimal)
        print_banner
        check_os
        update_system
        install_essentials
        ;;
    *)
        main
        ;;
esac
