#!/bin/bash

###############################################################################
#                     Development Tools Installation Script                     #
#                     For Ubuntu/Debian-based systems                           #
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_step() {
    echo -e "\n${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_info() {
    echo -e "    ${CYAN}→${NC} $1"
}
###############################################################################

print_success() {
    echo -e "    ${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "    ${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "    ${RED}✗${NC} $1"#!/bin/bash

###############################################################################
#                     Development Tools Installation Script                     #
#                     For Ubuntu/Debian-based systems                           #
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_step() {
    echo -e "\n${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_info() {
    echo -e "    ${CYAN}→${NC} $1"
}
###############################################################################

print_success() {
    echo -e "    ${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "    ${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "    ${RED}✗${NC} $1"
}

###############################################################################
# Install Essential Packages (curl, wget, etc.)
###############################################################################
install_essentials() {
    print_step "Installing essential packages..."
    sudo apt update
    sudo apt install -y curl wget git ca-certificates gnupg lsb-release software-properties-common
    print_success "Essential packages installed"
}

###############################################################################
# Visual Studio Code
###############################################################################
install_vscode() {
    print_step "Installing Visual Studio Code..."

    if command -v code &>/dev/null; then
        print_info "VS Code already installed"
        return
    fi

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg

    sudo apt update
    sudo apt install -y code

    print_success "VS Code installed"
}


###############################################################################
# Cursor IDE (AI-powered Editor)
###############################################################################
install_cursor_ide() {
    print_step "Installing Cursor IDE (AI-powered Editor)..."

    if command -v cursor &>/dev/null || [ -f /usr/local/bin/cursor ] || [ -f "$HOME/.local/bin/cursor" ]; then
        print_info "Cursor IDE already installed"
        return
    fi

    # Create applications directory
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share/applications"

    # Download Cursor IDE AppImage from official website
    print_info "Downloading Cursor IDE AppImage..."
    curl -fSL "https://cursor.com/download?platform=linux-x86_64" -o "$HOME/.local/bin/cursor.AppImage"
    chmod +x "$HOME/.local/bin/cursor.AppImage"

    # Create symlink
    ln -sf "$HOME/.local/bin/cursor.AppImage" "$HOME/.local/bin/cursor"

    # Create desktop entry
    cat > "$HOME/.local/share/applications/cursor.desktop" << EOF
[Desktop Entry]
Name=Cursor IDE
Comment=AI-powered Code Editor
Exec=$HOME/.local/bin/cursor.AppImage
Icon=cursor
Terminal=false
Type=Application
Categories=Development;IDE;
StartupNotify=true
EOF

    print_success "Cursor IDE installed"
}

###############################################################################
# Google Chrome
###############################################################################
install_chrome() {
    print_step "Installing Google Chrome..."

    if command -v google-chrome &>/dev/null; then
        print_info "Google Chrome already installed"
        return
    fi

    wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i /tmp/google-chrome.deb || sudo apt install -f -y
    rm /tmp/google-chrome.deb

    print_success "Google Chrome installed"
}

###############################################################################
# Chromium
###############################################################################
install_chromium() {
    print_step "Installing Chromium..."

    if command -v chromium-browser &>/dev/null || command -v chromium &>/dev/null; then
        print_info "Chromium already installed"
        return
    fi

    sudo apt install -y chromium-browser || sudo snap install chromium

    print_success "Chromium installed"
}

###############################################################################
# Docker
###############################################################################
install_docker() {
    print_step "Installing Docker..."

    if command -v docker &>/dev/null; then
        print_info "Docker already installed"
        return
    fi

    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add current user to docker group
    sudo usermod -aG docker "$USER"

    print_success "Docker installed (log out and back in to use docker without sudo)"
}

###############################################################################
# NVM (Node Version Manager)
###############################################################################
install_nvm() {
    print_step "Installing NVM (Node Version Manager)..."

    if [ -d "$HOME/.nvm" ]; then
        print_info "NVM already installed"
        source "$HOME/.nvm/nvm.sh"
    else
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
        
        # Load NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    # Install latest LTS Node.js
    print_info "Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'

    # Install global npm packages
    print_info "Installing global npm packages..."
    npm install -g npm@latest
    npm install -g yarn pnpm typescript ts-node eslint prettier

    print_success "NVM and Node.js installed"
}

###############################################################################
# DBeaver (Database Management Tool)
###############################################################################
install_dbeaver() {
    print_step "Installing DBeaver..."

    if command -v dbeaver &>/dev/null || [ -f /usr/share/applications/dbeaver-ce.desktop ]; then
        print_info "DBeaver already installed"
        return
    fi

    # Download and install DBeaver Community Edition
    wget -q -O /tmp/dbeaver.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
    sudo dpkg -i /tmp/dbeaver.deb || sudo apt install -f -y
    rm /tmp/dbeaver.deb

    print_success "DBeaver installed"
}

###############################################################################
# Git (with latest version)
###############################################################################
install_git() {
    print_step "Ensuring latest Git version..."

    sudo add-apt-repository -y ppa:git-core/ppa
    sudo apt update
    sudo apt install -y git

    print_success "Git installed: $(git --version)"
}

###############################################################################
# Speakeasy CLI (SDK Generator)
###############################################################################
install_speakeasy() {
    print_step "Installing Speakeasy CLI..."

    if command -v speakeasy &>/dev/null; then
        print_info "Speakeasy CLI already installed"
        return
    fi

    # Install Speakeasy CLI using the official installer
    curl -fsSL https://raw.githubusercontent.com/speakeasy-api/speakeasy/main/install.sh | sh

    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.speakeasy:"* ]]; then
        export PATH="$HOME/.speakeasy:$PATH"
        echo 'export PATH="$HOME/.speakeasy:$PATH"' >> "$HOME/.bashrc"
        echo 'export PATH="$HOME/.speakeasy:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
    fi

    print_success "Speakeasy CLI installed"
}

###############################################################################
# Additional Development Tools
###############################################################################
install_additional_tools() {
    print_step "Installing additional development tools..."

    # Lazygit (Git TUI)
    if ! command -v lazygit &>/dev/null; then
        print_info "Installing Lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
        sudo install /tmp/lazygit /usr/local/bin
        rm /tmp/lazygit.tar.gz /tmp/lazygit
    fi

    # HTTPie (modern curl alternative)
    if ! command -v http &>/dev/null; then
        print_info "Installing HTTPie..."
        sudo apt install -y httpie
    fi

    # tmux (terminal multiplexer)
    if ! command -v tmux &>/dev/null; then
        print_info "Installing tmux..."
        sudo apt install -y tmux
    fi

    # fzf (fuzzy finder)
    if ! command -v fzf &>/dev/null; then
        print_info "Installing fzf..."
        sudo apt install -y fzf
    fi

    # bat (modern cat alternative)
    if ! command -v batcat &>/dev/null; then
        print_info "Installing bat..."
        sudo apt install -y bat
    fi

    # eza (modern ls alternative, formerly exa)
    if ! command -v eza &>/dev/null && command -v brew &>/dev/null; then
        print_info "Installing eza..."
        brew install eza
    fi

    print_success "Additional development tools installed"
}

###############################################################################
# Neovim
###############################################################################
install_neovim() {
    print_step "Installing Neovim..."

    if command -v nvim &>/dev/null; then
        print_info "Neovim already installed"
        return
    fi

    # Install latest Neovim
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz

    # Add to PATH (this is also done in .zshrc)
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim

    print_success "Neovim installed"
}

###############################################################################
# Fonts (Nerd Fonts for terminal/coding)
###############################################################################
install_fonts() {
    print_step "Installing Nerd Fonts..."

    local fonts_dir="$HOME/.local/share/fonts"
    mkdir -p "$fonts_dir"

    # Install JetBrainsMono Nerd Font
    if [ ! -f "$fonts_dir/JetBrainsMonoNerdFont-Regular.ttf" ]; then
        print_info "Installing JetBrainsMono Nerd Font..."
        curl -Lo /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
        unzip -o /tmp/JetBrainsMono.zip -d "$fonts_dir"
        rm /tmp/JetBrainsMono.zip
        fc-cache -fv
    fi

    # Install FiraCode Nerd Font
    if [ ! -f "$fonts_dir/FiraCodeNerdFont-Regular.ttf" ]; then
        print_info "Installing FiraCode Nerd Font..."
        curl -Lo /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
        unzip -o /tmp/FiraCode.zip -d "$fonts_dir"
        rm /tmp/FiraCode.zip
        fc-cache -fv
    fi

    print_success "Nerd Fonts installed"
}

###############################################################################
# PostgreSQL
###############################################################################
install_postgresql() {
    print_step "Installing PostgreSQL..."

    if command -v psql &>/dev/null; then
        print_info "PostgreSQL already installed"
        return
    fi

    sudo apt install -y postgresql postgresql-contrib

    # Start and enable PostgreSQL service
    sudo systemctl start postgresql
    sudo systemctl enable postgresql

    print_success "PostgreSQL installed"
}

###############################################################################
# Main Installation
###############################################################################
main() {
    echo -e "${CYAN}Starting development tools installation...${NC}"
    echo ""


    install_essentials
    install_git
    install_vscode
    install_cursor_ide
    install_chrome
    install_chromium
    install_docker
    install_nvm
    install_dbeaver
    install_neovim
    install_fonts
    install_postgresql
    install_speakeasy
    install_additional_tools

    echo ""
    echo -e "${GREEN}All development tools installed successfully!${NC}"
}

# Run main function
main "$@"

}

###############################################################################
# Install Essential Packages (curl, wget, etc.)
###############################################################################
install_essentials() {
    print_step "Installing essential packages..."
    sudo apt update
    sudo apt install -y curl wget git ca-certificates gnupg lsb-release software-properties-common
    print_success "Essential packages installed"
}

###############################################################################
# Visual Studio Code
###############################################################################
install_vscode() {
    print_step "Installing Visual Studio Code..."

    if command -v code &>/dev/null; then
        print_info "VS Code already installed"
        return
    fi

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg

    sudo apt update
    sudo apt install -y code

    print_success "VS Code installed"
}

###############################################################################
# Cursor (AI Code Editor)
###############################################################################
install_cursor() {
    print_step "Installing Cursor..."

    if command -v cursor &>/dev/null || [ -f /usr/local/bin/cursor ] || [ -f "$HOME/.local/bin/cursor" ]; then
        print_info "Cursor already installed"
        return
    fi

    # Create applications directory
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share/applications"

    # Download Cursor AppImage
    print_info "Downloading Cursor AppImage..."
    curl -fSL "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable" -o "$HOME/.local/bin/cursor.AppImage" || \
    curl -fSL "https://download.todesktop.com/230313mzl4w4u92/cursor-0.48.6-build-250128bl183qyaz-x86_64.AppImage" -o "$HOME/.local/bin/cursor.AppImage"
    chmod +x "$HOME/.local/bin/cursor.AppImage"

    # Create symlink
    ln -sf "$HOME/.local/bin/cursor.AppImage" "$HOME/.local/bin/cursor"

    # Create desktop entry
    cat > "$HOME/.local/share/applications/cursor.desktop" << EOF
[Desktop Entry]
Name=Cursor
Comment=AI Code Editor
Exec=$HOME/.local/bin/cursor.AppImage
Icon=cursor
Terminal=false
Type=Application
Categories=Development;IDE;
StartupNotify=true
EOF

    print_success "Cursor installed"
}

###############################################################################
# Google Chrome
###############################################################################
install_chrome() {
    print_step "Installing Google Chrome..."

    if command -v google-chrome &>/dev/null; then
        print_info "Google Chrome already installed"
        return
    fi

    wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i /tmp/google-chrome.deb || sudo apt install -f -y
    rm /tmp/google-chrome.deb

    print_success "Google Chrome installed"
}

###############################################################################
# Chromium
###############################################################################
install_chromium() {
    print_step "Installing Chromium..."

    if command -v chromium-browser &>/dev/null || command -v chromium &>/dev/null; then
        print_info "Chromium already installed"
        return
    fi

    sudo apt install -y chromium-browser || sudo snap install chromium

    print_success "Chromium installed"
}

###############################################################################
# Docker
###############################################################################
install_docker() {
    print_step "Installing Docker..."

    if command -v docker &>/dev/null; then
        print_info "Docker already installed"
        return
    fi

    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add current user to docker group
    sudo usermod -aG docker "$USER"

    print_success "Docker installed (log out and back in to use docker without sudo)"
}

###############################################################################
# NVM (Node Version Manager)
###############################################################################
install_nvm() {
    print_step "Installing NVM (Node Version Manager)..."

    if [ -d "$HOME/.nvm" ]; then
        print_info "NVM already installed"
        source "$HOME/.nvm/nvm.sh"
    else
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
        
        # Load NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    # Install latest LTS Node.js
    print_info "Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'

    # Install global npm packages
    print_info "Installing global npm packages..."
    npm install -g npm@latest
    npm install -g yarn pnpm typescript ts-node eslint prettier

    print_success "NVM and Node.js installed"
}

###############################################################################
# DBeaver (Database Management Tool)
###############################################################################
install_dbeaver() {
    print_step "Installing DBeaver..."

    if command -v dbeaver &>/dev/null || [ -f /usr/share/applications/dbeaver-ce.desktop ]; then
        print_info "DBeaver already installed"
        return
    fi

    # Download and install DBeaver Community Edition
    wget -q -O /tmp/dbeaver.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
    sudo dpkg -i /tmp/dbeaver.deb || sudo apt install -f -y
    rm /tmp/dbeaver.deb

    print_success "DBeaver installed"
}

###############################################################################
# Git (with latest version)
###############################################################################
install_git() {
    print_step "Ensuring latest Git version..."

    sudo add-apt-repository -y ppa:git-core/ppa
    sudo apt update
    sudo apt install -y git

    print_success "Git installed: $(git --version)"
}

###############################################################################
# Speakeasy CLI (SDK Generator)
###############################################################################
install_speakeasy() {
    print_step "Installing Speakeasy CLI..."

    if command -v speakeasy &>/dev/null; then
        print_info "Speakeasy CLI already installed"
        return
    fi

    # Install Speakeasy CLI using the official installer
    curl -fsSL https://raw.githubusercontent.com/speakeasy-api/speakeasy/main/install.sh | sh

    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.speakeasy:"* ]]; then
        export PATH="$HOME/.speakeasy:$PATH"
        echo 'export PATH="$HOME/.speakeasy:$PATH"' >> "$HOME/.bashrc"
        echo 'export PATH="$HOME/.speakeasy:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
    fi

    print_success "Speakeasy CLI installed"
}

###############################################################################
# Additional Development Tools
###############################################################################
install_additional_tools() {
    print_step "Installing additional development tools..."

    # Lazygit (Git TUI)
    if ! command -v lazygit &>/dev/null; then
        print_info "Installing Lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
        sudo install /tmp/lazygit /usr/local/bin
        rm /tmp/lazygit.tar.gz /tmp/lazygit
    fi

    # HTTPie (modern curl alternative)
    if ! command -v http &>/dev/null; then
        print_info "Installing HTTPie..."
        sudo apt install -y httpie
    fi

    # tmux (terminal multiplexer)
    if ! command -v tmux &>/dev/null; then
        print_info "Installing tmux..."
        sudo apt install -y tmux
    fi

    # fzf (fuzzy finder)
    if ! command -v fzf &>/dev/null; then
        print_info "Installing fzf..."
        sudo apt install -y fzf
    fi

    # bat (modern cat alternative)
    if ! command -v batcat &>/dev/null; then
        print_info "Installing bat..."
        sudo apt install -y bat
    fi

    # eza (modern ls alternative, formerly exa)
    if ! command -v eza &>/dev/null && command -v brew &>/dev/null; then
        print_info "Installing eza..."
        brew install eza
    fi

    print_success "Additional development tools installed"
}

###############################################################################
# Neovim
###############################################################################
install_neovim() {
    print_step "Installing Neovim..."

    if command -v nvim &>/dev/null; then
        print_info "Neovim already installed"
        return
    fi

    # Install latest Neovim
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz

    # Add to PATH (this is also done in .zshrc)
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim

    print_success "Neovim installed"
}

###############################################################################
# Fonts (Nerd Fonts for terminal/coding)
###############################################################################
install_fonts() {
    print_step "Installing Nerd Fonts..."

    local fonts_dir="$HOME/.local/share/fonts"
    mkdir -p "$fonts_dir"

    # Install JetBrainsMono Nerd Font
    if [ ! -f "$fonts_dir/JetBrainsMonoNerdFont-Regular.ttf" ]; then
        print_info "Installing JetBrainsMono Nerd Font..."
        curl -Lo /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
        unzip -o /tmp/JetBrainsMono.zip -d "$fonts_dir"
        rm /tmp/JetBrainsMono.zip
        fc-cache -fv
    fi

    # Install FiraCode Nerd Font
    if [ ! -f "$fonts_dir/FiraCodeNerdFont-Regular.ttf" ]; then
        print_info "Installing FiraCode Nerd Font..."
        curl -Lo /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
        unzip -o /tmp/FiraCode.zip -d "$fonts_dir"
        rm /tmp/FiraCode.zip
        fc-cache -fv
    fi

    print_success "Nerd Fonts installed"
}

###############################################################################
# PostgreSQL
###############################################################################
install_postgresql() {
    print_step "Installing PostgreSQL..."

    if command -v psql &>/dev/null; then
        print_info "PostgreSQL already installed"
        return
    fi

    sudo apt install -y postgresql postgresql-contrib

    # Start and enable PostgreSQL service
    sudo systemctl start postgresql
    sudo systemctl enable postgresql

    print_success "PostgreSQL installed"
}

###############################################################################
# Main Installation
###############################################################################
main() {
    echo -e "${CYAN}Starting development tools installation...${NC}"
    echo ""

    install_essentials
    install_git
    install_vscode
    install_cursor
    install_chrome
    install_chromium
    install_docker
    install_nvm
    install_dbeaver
    install_neovim
    install_fonts
    install_postgresql
    install_speakeasy
    install_additional_tools

    echo ""
    echo -e "${GREEN}All development tools installed successfully!${NC}"
}

# Run main function
main "$@"
