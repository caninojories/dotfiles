#!/bin/bash

###############################################################################
#                     GitHub SSH Key Setup Script                              #
#                     For Ubuntu/Debian-based systems                          #
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

print_success() {
    echo -e "    ${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "    ${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "    ${RED}✗${NC} $1"
}

# Banner
echo -e "${GREEN}"
echo "  ██████╗ ██╗████████╗██╗  ██╗██╗   ██╗██████╗     ███████╗███████╗██╗  ██╗"
echo "  ██╔════╝ ██║╚══██╔══╝██║  ██║██║   ██║██╔══██╗    ██╔════╝██╔════╝██║  ██║"
echo "  ██║  ███╗██║   ██║   ███████║██║   ██║██████╔╝    ███████╗███████╗███████║"
echo "  ██║   ██║██║   ██║   ██╔══██║██║   ██║██╔══██╗    ╚════██║╚════██║██╔══██║"
echo "  ╚██████╔╝██║   ██║   ██║  ██║╚██████╔╝██████╔╝    ███████║███████║██║  ██║"
echo "   ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝     ╚══════╝╚══════╝╚═╝  ╚═╝"
echo -e "${CYAN}                     GitHub SSH Key Setup${NC}"
echo ""

# Variables
SSH_DIR="$HOME/.ssh"
GITHUB_RSA="$SSH_DIR/github_rsa"

###############################################################################
# Create SSH Directory
###############################################################################
create_ssh_dir() {
    print_step "Setting up SSH directory..."

    if [ ! -d "$SSH_DIR" ]; then
        mkdir -p "$SSH_DIR"
        chmod 700 "$SSH_DIR"
        print_success "Created $SSH_DIR"
    else
        print_info "SSH directory already exists"
    fi
}

###############################################################################
# Write SSH Config
###############################################################################
write_ssh_config() {
    print_step "Configuring SSH..."

    local ssh_config="$SSH_DIR/config"
    
    # Backup existing config
    if [ -f "$ssh_config" ]; then
        cp "$ssh_config" "$ssh_config.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backed up existing SSH config"
    fi

    # Check if GitHub config already exists
    if grep -q "Host github.com" "$ssh_config" 2>/dev/null; then
        print_info "GitHub SSH config already exists"
        return
    fi

    # Write GitHub SSH config
    cat >> "$ssh_config" << EOF

# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_rsa
    IdentitiesOnly yes
    AddKeysToAgent yes

# GitHub (wildcard)
Host *.github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_rsa
    IdentitiesOnly yes
    AddKeysToAgent yes
EOF

    chmod 600 "$ssh_config"
    print_success "SSH config updated"
}

###############################################################################
# Generate SSH Key
###############################################################################
generate_ssh_key() {
    print_step "Generating SSH key..."

    # Check if key already exists
    if [ -f "$GITHUB_RSA" ]; then
        print_warning "SSH key already exists at $GITHUB_RSA"
        read -p "    Do you want to regenerate it? (y/N): " REGENERATE
        
        if [[ ! "$REGENERATE" =~ ^[Yy]$ ]]; then
            print_info "Keeping existing key"
            return
        fi
        
        # Backup existing keys
        mv "$GITHUB_RSA" "$GITHUB_RSA.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$GITHUB_RSA.pub" "$GITHUB_RSA.pub.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backed up existing keys"
    fi

    # Get email address
    echo ""
    read -p "    Enter your GitHub email address: " GITHUB_EMAIL

    if [ -z "$GITHUB_EMAIL" ]; then
        print_error "Email is required"
        exit 1
    fi

    # Get passphrase (optional)
    echo ""
    read -s -p "    Enter SSH passphrase (optional, press Enter for none): " SSH_PASSPHRASE
    echo ""

    # Generate SSH key using Ed25519 (more secure than RSA)
    print_info "Generating Ed25519 SSH key..."
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$GITHUB_RSA" -N "$SSH_PASSPHRASE" -q

    # Also create RSA key for compatibility if needed
    # ssh-keygen -t rsa -b 4096 -C "$GITHUB_EMAIL" -f "$GITHUB_RSA" -N "$SSH_PASSPHRASE" -q

    chmod 600 "$GITHUB_RSA"
    chmod 644 "$GITHUB_RSA.pub"

    print_success "SSH key generated"
}

###############################################################################
# Start SSH Agent and Add Key
###############################################################################
setup_ssh_agent() {
    print_step "Setting up SSH agent..."

    # Start ssh-agent if not running
    eval "$(ssh-agent -s)" > /dev/null 2>&1

    # Add key to agent
    ssh-add "$GITHUB_RSA" 2>/dev/null || true

    print_success "SSH key added to agent"
}

###############################################################################
# Display Public Key
###############################################################################
display_public_key() {
    print_step "Your SSH public key:"

    echo ""
    echo -e "${YELLOW}╔════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║  Copy the following key and add it to your GitHub account:         ║${NC}"
    echo -e "${YELLOW}║  https://github.com/settings/ssh/new                               ║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}"
    cat "$GITHUB_RSA.pub"
    echo -e "${NC}"
    echo ""

    # Copy to clipboard if xclip is available
    if command -v xclip &>/dev/null; then
        cat "$GITHUB_RSA.pub" | xclip -selection clipboard
        print_success "Public key copied to clipboard!"
    else
        print_info "Install xclip to auto-copy to clipboard: sudo apt install xclip"
    fi
}

###############################################################################
# Test GitHub Connection
###############################################################################
test_github_connection() {
    print_step "Testing GitHub connection..."
    echo ""

    read -p "    Have you added the SSH key to GitHub? (y/N): " ADDED_KEY

    if [[ "$ADDED_KEY" =~ ^[Yy]$ ]]; then
        print_info "Testing connection to GitHub..."
        echo ""
        
        # Test SSH connection
        if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            print_success "Successfully authenticated with GitHub!"
        else
            ssh -T git@github.com 2>&1 || true
            echo ""
            print_info "If you see 'successfully authenticated', the setup is complete!"
        fi
    else
        print_info "Please add your SSH key to GitHub and run: ssh -T git@github.com"
    fi
}

###############################################################################
# Install GitHub CLI
###############################################################################
install_gh_cli() {
    print_step "Installing GitHub CLI..."

    # Check if already installed
    if command -v gh &>/dev/null; then
        print_success "GitHub CLI already installed ($(gh --version | head -n1))"
        return 0
    fi

    read -p "    GitHub CLI is not installed. Install it now? (Y/n): " INSTALL_GH

    if [[ "$INSTALL_GH" =~ ^[Nn]$ ]]; then
        print_info "Skipping GitHub CLI installation"
        return 1
    fi

    print_info "Installing GitHub CLI..."

    # Add GitHub CLI repository
    (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
        && sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
        && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && sudo apt update \
        && sudo apt install gh -y

    if command -v gh &>/dev/null; then
        print_success "GitHub CLI installed successfully!"
        return 0
    else
        print_error "Failed to install GitHub CLI"
        return 1
    fi
}

###############################################################################
# Add SSH key using GitHub CLI
###############################################################################
add_key_via_gh_cli() {
    print_step "Add SSH key via GitHub CLI..."

    # Check if public key exists
    if [ ! -f "$GITHUB_RSA.pub" ]; then
        print_error "SSH public key not found at $GITHUB_RSA.pub"
        return 1
    fi

    # Install GitHub CLI if not present
    if ! command -v gh &>/dev/null; then
        if ! install_gh_cli; then
            print_info "Cannot add key via CLI without GitHub CLI installed"
            return 1
        fi
    fi

    read -p "    Do you want to add the SSH key to GitHub via CLI? (Y/n): " USE_GH

    if [[ "$USE_GH" =~ ^[Nn]$ ]]; then
        print_info "Skipping GitHub CLI key upload"
        return 0
    fi

    # Check if logged in
    if ! gh auth status &>/dev/null 2>&1; then
        print_info "Please authenticate with GitHub CLI..."
        echo ""
        print_info "You'll be prompted to authenticate. Choose:"
        print_info "  - GitHub.com"
        print_info "  - HTTPS (recommended)"
        print_info "  - Login with a web browser"
        echo ""
        
        if ! gh auth login; then
            print_error "GitHub CLI authentication failed"
            return 1
        fi
    else
        print_success "Already authenticated with GitHub CLI"
    fi

    # Get key title
    local key_title
    key_title="$(hostname) - $(date +%Y-%m-%d)"
    
    read -p "    Enter a title for this SSH key [$key_title]: " CUSTOM_TITLE
    key_title="${CUSTOM_TITLE:-$key_title}"

    # Check if key already exists on GitHub
    print_info "Checking if key already exists on GitHub..."
    local pub_key_fingerprint
    pub_key_fingerprint=$(ssh-keygen -lf "$GITHUB_RSA.pub" | awk '{print $2}')
    
    if gh ssh-key list 2>/dev/null | grep -q "$pub_key_fingerprint"; then
        print_warning "This SSH key is already added to your GitHub account"
        return 0
    fi

    # Add SSH key to GitHub
    print_info "Adding SSH key to GitHub..."
    if gh ssh-key add "$GITHUB_RSA.pub" --title "$key_title"; then
        print_success "SSH key added to GitHub successfully!"
        
        # List keys to confirm
        echo ""
        print_info "Your SSH keys on GitHub:"
        gh ssh-key list
    else
        print_error "Failed to add SSH key to GitHub"
        return 1
    fi
}

###############################################################################
# Main
###############################################################################
main() {
    create_ssh_dir
    write_ssh_config
    generate_ssh_key
    setup_ssh_agent
    display_public_key
    
    # Add SSH key to GitHub via CLI
    add_key_via_gh_cli
    
    # Test connection
    test_github_connection

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    GitHub SSH Setup Complete! 🔐                    ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Run main function
main "$@"
