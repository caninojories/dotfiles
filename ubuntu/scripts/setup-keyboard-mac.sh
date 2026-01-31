#!/bin/bash

###############################################################################
#                     Mac Keyboard Layout for Ubuntu                           #
#                     Makes Ubuntu keyboard behave like macOS                  #
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
echo "  ╔══════════════════════════════════════════════════════════════════╗"
echo "  ║           ⌨️  Mac Keyboard Layout for Ubuntu 🐧                   ║"
echo "  ╚══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo "  This script will remap your keyboard to behave like a Mac:"
echo "  • Cmd (Super/Win) key will work like macOS Command key"
echo "  • Cmd+C/V/X for copy/paste/cut"
echo "  • Cmd+Q to quit, Cmd+W to close tab"
echo "  • Cmd+Space for search"
echo ""

###############################################################################
# Method 1: XKB Key Swap (Simple, built-in)
###############################################################################
setup_xkb_swap() {
    print_step "Setting up keyboard with XKB options..."

    echo ""
    echo "    Choose your preferred key layout:"
    echo ""
    echo "    1) Swap Ctrl and Cmd (Super) - RECOMMENDED"
    echo "       Makes Cmd+C/V/X work like Mac (Cmd becomes Ctrl)"
    echo ""
    echo "    2) Swap Alt and Cmd (Super)"
    echo "       Keeps Ctrl as Ctrl, swaps Alt and Cmd positions"
    echo ""
    echo "    3) Full Mac layout (Ctrl-Cmd-Alt → Ctrl-Alt-Super)"
    echo "       Physical order matches Mac keyboard"
    echo ""
    echo "    4) Skip"
    echo ""
    read -p "    Select option [1-4]: " XKB_OPTION

    local xkb_options=""
    case $XKB_OPTION in
        1)
            xkb_options="ctrl:swap_lwin_lctl,ctrl:swap_rwin_rctl"
            print_info "Swapping Ctrl and Cmd keys..."
            ;;
        2)
            xkb_options="altwin:swap_alt_win"
            print_info "Swapping Alt and Cmd keys..."
            ;;
        3)
            xkb_options="altwin:ctrl_alt_win"
            print_info "Applying full Mac layout..."
            ;;
        4)
            print_info "Skipping key swap"
            return
            ;;
        *)
            print_warning "Invalid option, skipping..."
            return
            ;;
    esac

    # Apply using setxkbmap (for current X session)
    setxkbmap -option "$xkb_options" 2>/dev/null || true

    # Make persistent via GNOME settings
    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.input-sources xkb-options "['$xkb_options']" 2>/dev/null || true
        print_success "Applied via GNOME settings"
    fi

    # Make persistent via /etc/default/keyboard
    if [ -f /etc/default/keyboard ]; then
        print_info "Updating /etc/default/keyboard..."
        sudo cp /etc/default/keyboard /etc/default/keyboard.backup
        sudo sed -i "s/^XKBOPTIONS=.*/XKBOPTIONS=\"$xkb_options\"/" /etc/default/keyboard
        
        # If XKBOPTIONS line doesn't exist, add it
        if ! grep -q "^XKBOPTIONS=" /etc/default/keyboard; then
            echo "XKBOPTIONS=\"$xkb_options\"" | sudo tee -a /etc/default/keyboard > /dev/null
        fi
        print_success "Updated /etc/default/keyboard"
    fi

    print_success "Keyboard layout configured!"
    print_info "Changes applied immediately. Will persist after reboot."
}

###############################################################################
# Method 2: Install Kinto (Comprehensive Mac keyboard remapping)
###############################################################################
install_kinto() {
    print_step "Installing Kinto..."

    print_info "Kinto provides comprehensive Mac-like keyboard shortcuts"
    print_info "It remaps shortcuts per-application (Terminal, Browser, etc.)"
    echo ""

    # Check if already installed
    if [ -d "$HOME/.config/kinto" ] || command -v kinto.py &>/dev/null; then
        print_info "Kinto appears to be already installed"
        read -p "    Reinstall? (y/N): " REINSTALL_KINTO
        if [[ ! "$REINSTALL_KINTO" =~ ^[Yy]$ ]]; then
            return
        fi
    fi

    # Install dependencies
    print_info "Installing dependencies..."
    sudo apt install -y git python3 python3-pip xdotool

    # Clone and install Kinto
    print_info "Downloading Kinto..."
    cd /tmp
    rm -rf kinto
    git clone https://github.com/rbreaves/kinto.git
    cd kinto

    print_info "Installing Kinto..."
    ./setup.py

    print_success "Kinto installed!"
    print_info "Kinto runs as a service and remaps keys automatically"
    print_info "Run 'kinto.py' to configure or check status"
}

###############################################################################
# Method 3: Setup GNOME keyboard shortcuts (Mac-like)
###############################################################################
setup_gnome_shortcuts() {
    print_step "Setting up Mac-like GNOME shortcuts..."

    if ! command -v gsettings &>/dev/null; then
        print_warning "gsettings not found. Skipping..."
        return
    fi

    # Common Mac shortcuts
    print_info "Configuring common shortcuts..."

    # Cmd+Space for search (like Spotlight)
    gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>space']" 2>/dev/null || true

    # Cmd+Q to quit
    gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q', '<Alt>F4']" 2>/dev/null || true

    # Cmd+H to hide/minimize
    gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>h']" 2>/dev/null || true

    # Cmd+M to minimize (alternative)
    gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>m', '<Super>h']" 2>/dev/null || true

    # Cmd+Tab for app switching
    gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']" 2>/dev/null || true

    # Cmd+` for window switching within app
    gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>grave']" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Super>grave']" 2>/dev/null || true

    # Screenshot shortcuts (Cmd+Shift+3, Cmd+Shift+4, Cmd+Shift+5)
    gsettings set org.gnome.shell.keybindings screenshot "['<Shift><Super>numbersign']" 2>/dev/null || true
    gsettings set org.gnome.shell.keybindings screenshot-window "['<Shift><Super>dollar']" 2>/dev/null || true
    gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift><Super>percent', 'Print']" 2>/dev/null || true

    # Workspace navigation (Ctrl+Left/Right like Mac)
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Control>Left', '<Super>Left']" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Control>Right', '<Super>Right']" 2>/dev/null || true

    # Mission Control / Overview (Ctrl+Up or F3)
    gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>space', '<Control>Up']" 2>/dev/null || true

    # Lock screen (Cmd+Ctrl+Q like Mac)
    gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super><Control>q']" 2>/dev/null || true

    print_success "GNOME shortcuts configured!"
}

###############################################################################
# Setup Terminal shortcuts
###############################################################################
setup_terminal_shortcuts() {
    print_step "Setting up terminal shortcuts..."

    # GNOME Terminal
    if command -v gnome-terminal &>/dev/null; then
        print_info "Configuring GNOME Terminal..."

        # Get the default profile
        local profile
        profile=$(gsettings get org.gnome.Terminal.ProfilesList default 2>/dev/null | tr -d "'")

        if [ -n "$profile" ]; then
            local schema="org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/"

            # Cmd+T for new tab
            gsettings set $schema new-tab '<Super>t' 2>/dev/null || true
            # Cmd+N for new window
            gsettings set $schema new-window '<Super>n' 2>/dev/null || true
            # Cmd+W for close tab
            gsettings set $schema close-tab '<Super>w' 2>/dev/null || true
            # Cmd+Shift+W for close window
            gsettings set $schema close-window '<Super><Shift>w' 2>/dev/null || true
            # Cmd+C for copy (in terminal, use Cmd+Shift+C to avoid conflict)
            gsettings set $schema copy '<Super><Shift>c' 2>/dev/null || true
            # Cmd+V for paste
            gsettings set $schema paste '<Super><Shift>v' 2>/dev/null || true
            # Cmd+F for find
            gsettings set $schema find '<Super>f' 2>/dev/null || true

            print_success "GNOME Terminal shortcuts configured"
        fi
    fi

    # Create shell aliases for common Mac commands
    print_info "Creating shell aliases..."

    local shell_rc="$HOME/.bashrc"
    if [ -f "$HOME/.zshrc" ]; then
        shell_rc="$HOME/.zshrc"
    fi

    # Add Mac-like aliases if not already present
    if ! grep -q "# Mac-like aliases" "$shell_rc" 2>/dev/null; then
        cat >> "$shell_rc" << 'EOF'

# Mac-like aliases
alias open='xdg-open'          # open files/URLs like macOS
alias pbcopy='xclip -selection clipboard'    # copy to clipboard
alias pbpaste='xclip -selection clipboard -o' # paste from clipboard
alias ldd='ldd'                 # otool -L equivalent
alias top='htop 2>/dev/null || top'
EOF
        print_success "Added Mac-like aliases to $shell_rc"
    fi
}

###############################################################################
# Show current keyboard configuration
###############################################################################
show_config() {
    print_step "Current keyboard configuration:"

    echo ""
    if command -v gsettings &>/dev/null; then
        echo "    XKB Options: $(gsettings get org.gnome.desktop.input-sources xkb-options 2>/dev/null || echo 'N/A')"
    fi

    if [ -f /etc/default/keyboard ]; then
        echo "    System keyboard: $(grep XKBOPTIONS /etc/default/keyboard 2>/dev/null || echo 'Not set')"
    fi

    echo ""
    echo "    Kinto: $([ -d "$HOME/.config/kinto" ] && echo 'Installed' || echo 'Not installed')"

    echo ""
    echo "    Current key mapping (setxkbmap):"
    setxkbmap -query 2>/dev/null | grep options || echo "    No options set"
}

###############################################################################
# Reset to default
###############################################################################
reset_keyboard() {
    print_step "Resetting keyboard to default..."

    # Clear XKB options
    setxkbmap -option 2>/dev/null || true

    if command -v gsettings &>/dev/null; then
        gsettings reset org.gnome.desktop.input-sources xkb-options 2>/dev/null || true
    fi

    if [ -f /etc/default/keyboard.backup ]; then
        sudo cp /etc/default/keyboard.backup /etc/default/keyboard
    fi

    print_success "Keyboard reset to default"
    print_info "Log out and back in for full effect"
}

###############################################################################
# Set US keyboard layout (fixes Shift+` showing ± instead of ~)
###############################################################################
set_us_layout() {
    print_step "Setting US keyboard layout..."
    
    # Set input sources to US layout only
    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us')]" 2>/dev/null || true
        print_success "Set keyboard layout to US"
    fi
    
    # Apply immediately
    setxkbmap us 2>/dev/null || true
}

###############################################################################
# Main Menu
###############################################################################
main() {
    echo ""
    echo "    What would you like to configure?"
    echo ""
    echo "    1) Quick setup - Swap Ctrl and Cmd keys (recommended)"
    echo "    2) Choose key swap option (Ctrl/Cmd, Alt/Cmd, etc.)"
    echo "    3) Install Kinto (comprehensive Mac keyboard)"
    echo "    4) Setup GNOME shortcuts (Cmd+Space, Cmd+Q, etc.)"
    echo "    5) Setup terminal shortcuts (Cmd+T, Cmd+W, etc.)"
    echo "    6) Full setup (key swap + shortcuts)"
    echo "    7) Show current configuration"
    echo "    8) Reset to default"
    echo "    0) Exit"
    echo ""
    read -p "    Select option [0-8]: " OPTION

    case $OPTION in
        1)
            # Quick swap Ctrl and Cmd
            local xkb_options="ctrl:swap_lwin_lctl,ctrl:swap_rwin_rctl"
            # Set US layout first to avoid gb+mac issues (Shift+` = ~ not ±)
            gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us')]" 2>/dev/null || true
            setxkbmap -option "" 2>/dev/null || true
            setxkbmap us -option "$xkb_options" 2>/dev/null || true
            gsettings set org.gnome.desktop.input-sources xkb-options "['$xkb_options']" 2>/dev/null || true
            print_success "Ctrl and Cmd keys swapped!"
            print_info "Cmd+C/V/X now works like Mac"
            ;;
        2)
            setup_xkb_swap
            ;;
        3)
            install_kinto
            ;;
        4)
            setup_gnome_shortcuts
            ;;
        5)
            setup_terminal_shortcuts
            ;;
        6)
            # Apply quick Ctrl/Cmd swap directly (best for Mac-like behavior)
            local xkb_options="ctrl:swap_lwin_lctl,ctrl:swap_rwin_rctl"
            # Set US layout first to avoid gb+mac issues (Shift+` = ~ not ±)
            gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us')]" 2>/dev/null || true
            setxkbmap -option "" 2>/dev/null || true
            setxkbmap us -option "$xkb_options" 2>/dev/null || true
            gsettings set org.gnome.desktop.input-sources xkb-options "['$xkb_options']" 2>/dev/null || true
            print_success "Ctrl and Cmd keys swapped!"
            setup_gnome_shortcuts
            setup_terminal_shortcuts
            ;;
        7)
            show_config
            ;;
        8)
            reset_keyboard
            ;;
        0)
            echo "    Exiting..."
            exit 0
            ;;
        *)
            print_warning "Invalid option"
            exit 1
            ;;
    esac

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Keyboard Configuration Complete! ⌨️                   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    print_info "You may need to log out and back in for all changes to take effect."
    echo ""
}

main "$@"
