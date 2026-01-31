#!/bin/bash

###############################################################################
#                     macOS-style Appearance for Ubuntu                        #
#                     Dock, fonts, icons, and themes                           #
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
echo "  ███╗   ███╗ █████╗  ██████╗ ██████╗ ███████╗    ██╗   ██╗██╗"
echo "  ████╗ ████║██╔══██╗██╔════╝██╔═══██╗██╔════╝    ██║   ██║██║"
echo "  ██╔████╔██║███████║██║     ██║   ██║███████╗    ██║   ██║██║"
echo "  ██║╚██╔╝██║██╔══██║██║     ██║   ██║╚════██║    ██║   ██║██║"
echo "  ██║ ╚═╝ ██║██║  ██║╚██████╗╚██████╔╝███████║    ╚██████╔╝██║"
echo "  ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═╝"
echo -e "${CYAN}           macOS-style Appearance for Ubuntu${NC}"
echo ""

###############################################################################
# Configure Dock (Ubuntu Dock / Dash-to-Dock)
###############################################################################
configure_dock() {
    print_step "Configuring Dock..."

    # Dock position
    echo ""
    echo "    Dock position:"
    echo "    1) Bottom (like macOS)"
    echo "    2) Left (Ubuntu default)"
    echo "    3) Right"
    echo ""
    read -p "    Select position [1-3]: " DOCK_POSITION

    local dock_position="BOTTOM"
    case $DOCK_POSITION in
        1) dock_position="BOTTOM" ;;
        2) dock_position="LEFT" ;;
        3) dock_position="RIGHT" ;;
    esac

    # Apply dock position
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position "$dock_position" 2>/dev/null || \
    gsettings set org.gnome.shell.extensions.ubuntu-dock dock-position "$dock_position" 2>/dev/null || true
    print_success "Dock position set to: $dock_position"

    # Dock icon size
    echo ""
    echo "    Dock icon size:"
    echo "    1) Small (36px)"
    echo "    2) Medium (48px - Ubuntu default)"
    echo "    3) Large (64px)"
    echo "    4) Extra Large (72px - like macOS)"
    echo "    5) Huge (96px)"
    echo "    6) Custom"
    echo ""
    read -p "    Select icon size [1-6]: " ICON_SIZE_OPTION

    local icon_size=48
    case $ICON_SIZE_OPTION in
        1) icon_size=36 ;;
        2) icon_size=48 ;;
        3) icon_size=64 ;;
        4) icon_size=72 ;;
        5) icon_size=96 ;;
        6)
            read -p "    Enter icon size in pixels (24-128): " icon_size
            ;;
    esac

    # Apply icon size
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size "$icon_size" 2>/dev/null || \
    gsettings set org.gnome.shell.extensions.ubuntu-dock dash-max-icon-size "$icon_size" 2>/dev/null || true
    print_success "Dock icon size set to: ${icon_size}px"

    # Additional dock settings
    print_info "Applying additional dock settings..."

    # Auto-hide dock (like macOS)
    echo ""
    read -p "    Auto-hide dock when windows overlap? (y/N): " AUTOHIDE_DOCK
    if [[ "$AUTOHIDE_DOCK" =~ ^[Yy]$ ]]; then
        gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false 2>/dev/null || \
        gsettings set org.gnome.shell.extensions.ubuntu-dock dock-fixed false 2>/dev/null || true
        gsettings set org.gnome.shell.extensions.dash-to-dock autohide true 2>/dev/null || \
        gsettings set org.gnome.shell.extensions.ubuntu-dock autohide true 2>/dev/null || true
        gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true 2>/dev/null || \
        gsettings set org.gnome.shell.extensions.ubuntu-dock intellihide true 2>/dev/null || true
        print_success "Auto-hide enabled"
    else
        gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true 2>/dev/null || \
        gsettings set org.gnome.shell.extensions.ubuntu-dock dock-fixed true 2>/dev/null || true
        print_info "Dock will always be visible"
    fi

    # Extend dock to full width (like macOS)
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false 2>/dev/null || \
    gsettings set org.gnome.shell.extensions.ubuntu-dock extend-height false 2>/dev/null || true

    # Show trash in dock
    gsettings set org.gnome.shell.extensions.dash-to-dock show-trash true 2>/dev/null || \
    gsettings set org.gnome.shell.extensions.ubuntu-dock show-trash true 2>/dev/null || true

    # Click action (like macOS - minimize on click)
    gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize' 2>/dev/null || \
    gsettings set org.gnome.shell.extensions.ubuntu-dock click-action 'minimize' 2>/dev/null || true

    # Dock transparency
    echo ""
    read -p "    Make dock transparent? (y/N): " DOCK_TRANSPARENT
    if [[ "$DOCK_TRANSPARENT" =~ ^[Yy]$ ]]; then
        gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED' 2>/dev/null || \
        gsettings set org.gnome.shell.extensions.ubuntu-dock transparency-mode 'FIXED' 2>/dev/null || true
        gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.7 2>/dev/null || \
        gsettings set org.gnome.shell.extensions.ubuntu-dock background-opacity 0.7 2>/dev/null || true
        print_success "Dock transparency enabled"
    fi

    print_success "Dock configured"
}

###############################################################################
# Configure Fonts (Bigger, like macOS)
###############################################################################
configure_fonts() {
    print_step "Configuring fonts..."

    echo ""
    echo "    Font scaling options:"
    echo "    1) Small (1.0 - default)"
    echo "    2) Medium (1.15)"
    echo "    3) Large (1.25 - recommended for bigger fonts)"
    echo "    4) Extra Large (1.5)"
    echo "    5) Custom"
    echo ""
    read -p "    Select font scaling [1-5]: " FONT_SCALE_OPTION

    local font_scale=1.0
    case $FONT_SCALE_OPTION in
        1) font_scale=1.0 ;;
        2) font_scale=1.15 ;;
        3) font_scale=1.25 ;;
        4) font_scale=1.5 ;;
        5)
            read -p "    Enter font scaling (0.5-3.0): " font_scale
            ;;
    esac

    # Apply font scaling
    gsettings set org.gnome.desktop.interface text-scaling-factor "$font_scale" 2>/dev/null || true
    print_success "Font scaling set to: $font_scale"

    # Set font sizes directly
    echo ""
    echo "    Set specific font sizes? (for finer control)"
    read -p "    Configure individual font sizes? (y/N): " CONFIG_FONTS

    if [[ "$CONFIG_FONTS" =~ ^[Yy]$ ]]; then
        echo ""
        echo "    Interface font size options:"
        echo "    1) Small (10)"
        echo "    2) Medium (11 - default)"
        echo "    3) Large (12)"
        echo "    4) Extra Large (14)"
        echo "    5) Custom"
        read -p "    Select [1-5]: " INTERFACE_FONT_SIZE

        local interface_size=11
        case $INTERFACE_FONT_SIZE in
            1) interface_size=10 ;;
            2) interface_size=11 ;;
            3) interface_size=12 ;;
            4) interface_size=14 ;;
            5) read -p "    Enter size: " interface_size ;;
        esac

        # Apply font settings
        gsettings set org.gnome.desktop.interface font-name "Ubuntu $interface_size" 2>/dev/null || \
        gsettings set org.gnome.desktop.interface font-name "Cantarell $interface_size" 2>/dev/null || true
        
        gsettings set org.gnome.desktop.interface document-font-name "Sans $interface_size" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface monospace-font-name "Ubuntu Mono $interface_size" 2>/dev/null || \
        gsettings set org.gnome.desktop.interface monospace-font-name "Monospace $interface_size" 2>/dev/null || true
        
        # Window title font (slightly larger)
        local title_size=$((interface_size + 1))
        gsettings set org.gnome.desktop.wm.preferences titlebar-font "Ubuntu Bold $title_size" 2>/dev/null || \
        gsettings set org.gnome.desktop.wm.preferences titlebar-font "Cantarell Bold $title_size" 2>/dev/null || true

        print_success "Font sizes configured"
    fi

    # Use SF Pro fonts if available (macOS-like)
    if [ -f "$HOME/.local/share/fonts/SF-Pro-Display-Regular.otf" ] || [ -f "/usr/share/fonts/SF-Pro-Display-Regular.otf" ]; then
        echo ""
        read -p "    Use SF Pro fonts (macOS style)? (y/N): " USE_SF_FONTS
        if [[ "$USE_SF_FONTS" =~ ^[Yy]$ ]]; then
            gsettings set org.gnome.desktop.interface font-name "SF Pro Display 11" 2>/dev/null || true
            gsettings set org.gnome.desktop.wm.preferences titlebar-font "SF Pro Display Bold 12" 2>/dev/null || true
            print_success "SF Pro fonts applied"
        fi
    fi

    print_success "Font configuration complete"
}

###############################################################################
# Configure Window Appearance
###############################################################################
configure_window_appearance() {
    print_step "Configuring window appearance..."

    # Window button position (like macOS - left side)
    echo ""
    echo "    Window button position:"
    echo "    1) Left (like macOS)"
    echo "    2) Right (default)"
    echo ""
    read -p "    Select position [1-2]: " BUTTON_POSITION

    if [[ "$BUTTON_POSITION" == "1" ]]; then
        gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:" 2>/dev/null || true
        print_success "Window buttons moved to left (like macOS)"
    else
        gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close" 2>/dev/null || true
        print_info "Window buttons on right (default)"
    fi

    # Other appearance settings
    print_info "Applying additional appearance settings..."

    # Show battery percentage
    gsettings set org.gnome.desktop.interface show-battery-percentage true 2>/dev/null || true

    # Clock format (12-hour like macOS default)
    echo ""
    read -p "    Use 12-hour clock format? (Y/n): " CLOCK_12H
    if [[ ! "$CLOCK_12H" =~ ^[Nn]$ ]]; then
        gsettings set org.gnome.desktop.interface clock-format '12h' 2>/dev/null || true
        print_success "12-hour clock enabled"
    fi

    # Show weekday in clock
    gsettings set org.gnome.desktop.interface clock-show-weekday true 2>/dev/null || true

    # Show date in clock
    gsettings set org.gnome.desktop.interface clock-show-date true 2>/dev/null || true

    # Enable animations (macOS has smooth animations)
    gsettings set org.gnome.desktop.interface enable-animations true 2>/dev/null || true

    # Hot corner (like macOS - top left for activities)
    echo ""
    read -p "    Enable hot corner (top-left for Activities)? (y/N): " ENABLE_HOT_CORNER
    if [[ "$ENABLE_HOT_CORNER" =~ ^[Yy]$ ]]; then
        gsettings set org.gnome.desktop.interface enable-hot-corners true 2>/dev/null || true
        print_success "Hot corner enabled"
    else
        gsettings set org.gnome.desktop.interface enable-hot-corners false 2>/dev/null || true
    fi

    print_success "Window appearance configured"
}

###############################################################################
# Configure Desktop Icons
###############################################################################
configure_desktop() {
    print_step "Configuring desktop..."

    echo ""
    echo "    Desktop icon size:"
    echo "    1) Small (48px)"
    echo "    2) Medium (64px)"
    echo "    3) Large (72px)"
    echo "    4) Extra Large (96px - like macOS)"
    echo "    5) Custom"
    echo ""
    read -p "    Select icon size [1-5]: " DESKTOP_ICON_SIZE

    local desktop_icon_size=64
    case $DESKTOP_ICON_SIZE in
        1) desktop_icon_size=48 ;;
        2) desktop_icon_size=64 ;;
        3) desktop_icon_size=72 ;;
        4) desktop_icon_size=96 ;;
        5) read -p "    Enter size (32-128): " desktop_icon_size ;;
    esac

    # Apply desktop icon size (for GNOME with desktop icons extension)
    gsettings set org.gnome.nautilus.icon-view default-zoom-level 'large' 2>/dev/null || true

    # For ding extension (desktop icons ng)
    gsettings set org.gnome.shell.extensions.ding icon-size "$desktop_icon_size" 2>/dev/null || true

    print_success "Desktop icon size configured"

    # Show/hide desktop icons
    echo ""
    read -p "    Show home folder on desktop? (y/N): " SHOW_HOME
    if [[ "$SHOW_HOME" =~ ^[Yy]$ ]]; then
        gsettings set org.gnome.shell.extensions.ding show-home true 2>/dev/null || true
    fi

    read -p "    Show trash on desktop? (y/N): " SHOW_TRASH
    if [[ "$SHOW_TRASH" =~ ^[Yy]$ ]]; then
        gsettings set org.gnome.shell.extensions.ding show-trash true 2>/dev/null || true
    fi

    print_success "Desktop configured"
}

###############################################################################
# Install macOS-style Themes (Optional)
###############################################################################
install_macos_themes() {
    print_step "macOS-style themes (optional)..."

    echo ""
    echo "    Would you like to install macOS-style themes?"
    echo "    This includes:"
    echo "    - WhiteSur GTK theme (macOS Big Sur style)"
    echo "    - macOS-style icons"
    echo "    - macOS cursors"
    echo ""
    read -p "    Install macOS themes? (y/N): " INSTALL_THEMES

    if [[ ! "$INSTALL_THEMES" =~ ^[Yy]$ ]]; then
        print_info "Skipping theme installation"
        return
    fi

    # Install dependencies
    sudo apt install -y git sassc optipng inkscape libglib2.0-dev-bin 2>/dev/null || true

    # Install WhiteSur GTK Theme
    print_info "Installing WhiteSur GTK theme..."
    local theme_dir="$HOME/.local/share/themes-src"
    mkdir -p "$theme_dir"

    if [ ! -d "$theme_dir/WhiteSur-gtk-theme" ]; then
        git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git "$theme_dir/WhiteSur-gtk-theme"
    fi

    cd "$theme_dir/WhiteSur-gtk-theme"
    ./install.sh -l -c Dark 2>/dev/null || ./install.sh 2>/dev/null || true

    # Choose theme variant
    echo ""
    echo "    Theme variant:"
    echo "    1) Light (like macOS default)"
    echo "    2) Dark"
    echo ""
    read -p "    Select variant [1-2]: " THEME_VARIANT

    if [[ "$THEME_VARIANT" == "2" ]]; then
        gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
    else
        gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Light" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null || true
    fi

    # Install WhiteSur Icon Theme
    print_info "Installing WhiteSur icon theme..."
    if [ ! -d "$theme_dir/WhiteSur-icon-theme" ]; then
        git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git "$theme_dir/WhiteSur-icon-theme"
    fi

    cd "$theme_dir/WhiteSur-icon-theme"
    ./install.sh 2>/dev/null || true

    # Apply icon theme
    if [[ "$THEME_VARIANT" == "2" ]]; then
        gsettings set org.gnome.desktop.interface icon-theme "WhiteSur-dark" 2>/dev/null || true
    else
        gsettings set org.gnome.desktop.interface icon-theme "WhiteSur" 2>/dev/null || true
    fi

    # Install macOS cursors
    print_info "Installing macOS cursors..."
    if [ ! -d "$theme_dir/apple_cursor" ]; then
        git clone https://github.com/ful1e5/apple_cursor.git "$theme_dir/apple_cursor" 2>/dev/null || true
    fi

    if [ -d "$theme_dir/apple_cursor" ]; then
        mkdir -p "$HOME/.local/share/icons"
        cp -r "$theme_dir/apple_cursor/dist"/* "$HOME/.local/share/icons/" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface cursor-theme "macOS-BigSur" 2>/dev/null || \
        gsettings set org.gnome.desktop.interface cursor-theme "macOS" 2>/dev/null || true
    fi

    print_success "macOS themes installed!"
    print_info "You may need to log out and back in for all changes to take effect"
}

###############################################################################
# Install Plank Dock (Alternative to Ubuntu Dock)
###############################################################################
install_plank_dock() {
    print_step "Plank Dock (optional - more macOS-like dock)..."

    echo ""
    echo "    Plank is a lightweight dock that looks more like macOS Dock."
    echo "    It can replace or work alongside Ubuntu's built-in dock."
    echo ""
    read -p "    Install Plank dock? (y/N): " INSTALL_PLANK

    if [[ ! "$INSTALL_PLANK" =~ ^[Yy]$ ]]; then
        print_info "Skipping Plank installation"
        return
    fi

    sudo apt install -y plank

    # Create autostart entry
    mkdir -p "$HOME/.config/autostart"
    cat > "$HOME/.config/autostart/plank.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Plank
Comment=macOS-style dock
Exec=plank
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
StartupNotify=false
EOF

    # Disable Ubuntu dock if using Plank
    echo ""
    read -p "    Disable Ubuntu dock (to use only Plank)? (y/N): " DISABLE_UBUNTU_DOCK
    if [[ "$DISABLE_UBUNTU_DOCK" =~ ^[Yy]$ ]]; then
        gnome-extensions disable ubuntu-dock@ubuntu.com 2>/dev/null || true
        gnome-extensions disable dash-to-dock@micxgx.gmail.com 2>/dev/null || true
        print_success "Ubuntu dock disabled"
    fi

    # Start Plank
    plank &

    print_success "Plank installed!"
    print_info "Right-click on Plank and select 'Preferences' to customize"
    print_info "Hold Ctrl and drag icons to rearrange or remove from dock"
}

###############################################################################
# Show Current Appearance Settings
###############################################################################
show_appearance_config() {
    print_step "Current appearance configuration:"
    echo ""

    if command -v gsettings &>/dev/null; then
        echo -e "${CYAN}Dock Settings:${NC}"
        echo "    Position: $(gsettings get org.gnome.shell.extensions.ubuntu-dock dock-position 2>/dev/null || echo 'N/A')"
        echo "    Icon size: $(gsettings get org.gnome.shell.extensions.ubuntu-dock dash-max-icon-size 2>/dev/null || echo 'N/A')"
        echo "    Auto-hide: $(gsettings get org.gnome.shell.extensions.ubuntu-dock autohide 2>/dev/null || echo 'N/A')"
        echo ""

        echo -e "${CYAN}Font Settings:${NC}"
        echo "    Scaling: $(gsettings get org.gnome.desktop.interface text-scaling-factor 2>/dev/null || echo 'N/A')"
        echo "    Interface font: $(gsettings get org.gnome.desktop.interface font-name 2>/dev/null || echo 'N/A')"
        echo "    Title font: $(gsettings get org.gnome.desktop.wm.preferences titlebar-font 2>/dev/null || echo 'N/A')"
        echo ""

        echo -e "${CYAN}Theme Settings:${NC}"
        echo "    GTK theme: $(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null || echo 'N/A')"
        echo "    Icon theme: $(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null || echo 'N/A')"
        echo "    Cursor theme: $(gsettings get org.gnome.desktop.interface cursor-theme 2>/dev/null || echo 'N/A')"
        echo ""

        echo -e "${CYAN}Window Settings:${NC}"
        echo "    Button layout: $(gsettings get org.gnome.desktop.wm.preferences button-layout 2>/dev/null || echo 'N/A')"
        echo "    Animations: $(gsettings get org.gnome.desktop.interface enable-animations 2>/dev/null || echo 'N/A')"
        echo ""
    fi
}

###############################################################################
# Main Menu
###############################################################################
main() {
    echo -e "${YELLOW}This script will configure Ubuntu to look like macOS.${NC}"
    echo ""
    echo "Options:"
    echo "    1) Configure dock (position, icon size, auto-hide)"
    echo "    2) Configure fonts (scaling, sizes)"
    echo "    3) Configure window appearance (buttons, clock)"
    echo "    4) Configure desktop icons"
    echo "    5) Install macOS themes (WhiteSur)"
    echo "    6) Install Plank dock (alternative dock)"
    echo "    7) Show current settings"
    echo "    8) Full macOS appearance setup"
    echo "    0) Exit"
    echo ""
    echo -e "${CYAN}    Note: For terminal setup (ZSH, fonts, themes), run setup-terminal.sh${NC}"
    echo ""

    read -p "Select option [0-8]: " MAIN_OPTION

    case $MAIN_OPTION in
        1)
            configure_dock
            ;;
        2)
            configure_fonts
            ;;
        3)
            configure_window_appearance
            ;;
        4)
            configure_desktop
            ;;
        5)
            install_macos_themes
            ;;
        6)
            install_plank_dock
            ;;
        7)
            show_appearance_config
            ;;
        8)
            # Sync package lists first (fixes 404 errors)
            print_step "Syncing package lists..."
            sudo apt update
            
            # Install GNOME Tweaks if not present (optional GUI tool)
            if ! command -v gnome-tweaks &>/dev/null; then
                print_info "Installing GNOME Tweaks..."
                sudo apt install -y gnome-tweaks --no-install-recommends
            fi

            configure_dock
            configure_fonts
            configure_window_appearance
            configure_desktop
            install_macos_themes
            
            echo ""
            read -p "    Also install Plank dock? (y/N): " ALSO_PLANK
            if [[ "$ALSO_PLANK" =~ ^[Yy]$ ]]; then
                install_plank_dock
            fi
            ;;
        0)
            echo "Exiting..."
            exit 0
            ;;
        *)
            print_warning "Invalid option"
            exit 1
            ;;
    esac

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Appearance Configuration Complete! 🎨                 ║${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║  You may need to log out and back in for all changes to apply.     ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Run main function
main "$@"
