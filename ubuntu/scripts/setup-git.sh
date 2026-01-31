#!/bin/bash

###############################################################################
#                     Git Configuration Setup Script                           #
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

# Banner
echo -e "${GREEN}"
echo "   ██████╗ ██╗████████╗    ███████╗███████╗████████╗██╗   ██╗██████╗ "
echo "  ██╔════╝ ██║╚══██╔══╝    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗"
echo "  ██║  ███╗██║   ██║       ███████╗█████╗     ██║   ██║   ██║██████╔╝"
echo "  ██║   ██║██║   ██║       ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ "
echo "  ╚██████╔╝██║   ██║       ███████║███████╗   ██║   ╚██████╔╝██║     "
echo "   ╚═════╝ ╚═╝   ╚═╝       ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     "
echo -e "${CYAN}                     Git Configuration Setup${NC}"
echo ""

###############################################################################
# Check if Git is installed
###############################################################################
check_git() {
    if ! command -v git &>/dev/null; then
        print_warning "Git is not installed. Installing..."
        sudo apt update && sudo apt install -y git
    fi
    print_info "Git version: $(git --version)"
}

###############################################################################
# Get user information
###############################################################################
get_user_info() {
    print_step "Configure Git user information..."

    # Get current values if they exist
    local current_name
    local current_email
    current_name=$(git config --global user.name 2>/dev/null || echo "")
    current_email=$(git config --global user.email 2>/dev/null || echo "")

    echo ""
    if [ -n "$current_name" ]; then
        read -p "    Git username [$current_name]: " GIT_USERNAME
        GIT_USERNAME="${GIT_USERNAME:-$current_name}"
    else
        read -p "    Git username: " GIT_USERNAME
    fi

    if [ -n "$current_email" ]; then
        read -p "    Git email [$current_email]: " GIT_EMAIL
        GIT_EMAIL="${GIT_EMAIL:-$current_email}"
    else
        read -p "    Git email: " GIT_EMAIL
    fi

    if [ -z "$GIT_USERNAME" ] || [ -z "$GIT_EMAIL" ]; then
        print_warning "Username and email are required for Git commits"
        exit 1
    fi
}

###############################################################################
# Configure Git
###############################################################################
configure_git() {
    print_step "Applying Git configuration..."

    # User configuration
    git config --global user.name "$GIT_USERNAME"
    git config --global user.email "$GIT_EMAIL"
    print_info "Set user.name: $GIT_USERNAME"
    print_info "Set user.email: $GIT_EMAIL"

    # Core settings
    git config --global core.editor "vim"
    git config --global core.autocrlf input
    git config --global core.safecrlf warn
    git config --global core.whitespace trailing-space,space-before-tab
    print_info "Set core settings"

    # Init settings
    git config --global init.defaultBranch main
    print_info "Set default branch: main"

    # Push settings
    git config --global push.default current
    git config --global push.autoSetupRemote true
    print_info "Set push settings"

    # Pull settings
    git config --global pull.rebase true
    git config --global pull.ff only
    print_info "Set pull settings"

    # Merge settings
    git config --global merge.conflictStyle diff3
    print_info "Set merge conflict style: diff3"

    # Diff settings
    git config --global diff.colorMoved zebra
    print_info "Set diff settings"

    # Credential helper (for HTTPS)
    git config --global credential.helper store
    print_info "Set credential helper: store"

    # Useful aliases
    print_step "Setting up Git aliases..."

    git config --global alias.st "status"
    git config --global alias.co "checkout"
    git config --global alias.br "branch"
    git config --global alias.ci "commit"
    git config --global alias.ca "commit --amend"
    git config --global alias.unstage "reset HEAD --"
    git config --global alias.last "log -1 HEAD"
    git config --global alias.visual "!gitk"
    git config --global alias.undo "reset --soft HEAD~1"
    
    # Pretty log alias
    git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
    
    # Short log alias
    git config --global alias.ll "log --oneline --graph --all --decorate"
    
    # List branches sorted by last modified
    git config --global alias.branches "for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
    
    # Clean merged branches
    git config --global alias.cleanup "!git branch --merged | grep -v '\\*\\|main\\|master\\|develop' | xargs -n 1 git branch -d"
    
    # Who contributed
    git config --global alias.who "shortlog -s --"
    
    # Show all contributors
    git config --global alias.contributors "shortlog --summary --numbered"

    print_success "Git aliases configured"
}

###############################################################################
# Configure GPG signing (optional)
###############################################################################
configure_gpg() {
    print_step "GPG commit signing (optional)..."

    echo ""
    read -p "    Do you want to configure GPG commit signing? (y/N): " CONFIGURE_GPG

    if [[ "$CONFIGURE_GPG" =~ ^[Yy]$ ]]; then
        # Check if GPG is installed
        if ! command -v gpg &>/dev/null; then
            print_info "Installing GPG..."
            sudo apt install -y gnupg
        fi

        # List existing keys
        echo ""
        print_info "Existing GPG keys:"
        gpg --list-secret-keys --keyid-format LONG 2>/dev/null || echo "    No GPG keys found"
        echo ""

        read -p "    Enter your GPG key ID (or press Enter to skip): " GPG_KEY_ID

        if [ -n "$GPG_KEY_ID" ]; then
            git config --global user.signingkey "$GPG_KEY_ID"
            git config --global commit.gpgsign true
            git config --global tag.gpgSign true
            
            # Set GPG TTY
            export GPG_TTY=$(tty)
            echo 'export GPG_TTY=$(tty)' >> "$HOME/.bashrc"
            echo 'export GPG_TTY=$(tty)' >> "$HOME/.zshrc" 2>/dev/null || true

            print_success "GPG signing configured with key: $GPG_KEY_ID"
        else
            print_info "Skipping GPG signing configuration"
        fi
    else
        print_info "GPG signing not configured"
    fi
}

###############################################################################
# Show final configuration
###############################################################################
show_configuration() {
    print_step "Current Git configuration:"
    echo ""
    
    echo -e "${CYAN}User Settings:${NC}"
    echo "    user.name: $(git config --global user.name)"
    echo "    user.email: $(git config --global user.email)"
    echo ""
    
    echo -e "${CYAN}Core Settings:${NC}"
    echo "    init.defaultBranch: $(git config --global init.defaultBranch)"
    echo "    push.default: $(git config --global push.default)"
    echo "    pull.rebase: $(git config --global pull.rebase)"
    echo ""
    
    echo -e "${CYAN}Aliases (use with 'git <alias>'):${NC}"
    git config --global --get-regexp alias | sed 's/alias\./    /' | while read alias command; do
        printf "    %-15s %s\n" "$alias" "$command"
    done
}

###############################################################################
# Main
###############################################################################
main() {
    check_git
    get_user_info
    configure_git
    configure_gpg
    show_configuration

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                  Git Configuration Complete! 🎉                    ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Run main function
main "$@"
