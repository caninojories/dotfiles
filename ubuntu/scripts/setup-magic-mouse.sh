#!/bin/bash

###############################################################################
#                     Apple Magic Mouse Setup for Ubuntu                       #
#                     Configures scroll and mouse settings                     #
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
echo "  ║           🍎 Apple Magic Mouse Setup for Ubuntu 🐧               ║"
echo "  ╚══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

###############################################################################
# Configure Scroll Direction
###############################################################################
setup_scroll_direction() {
    print_step "Configuring scroll direction..."

    if ! command -v gsettings &>/dev/null; then
        print_warning "gsettings not found. Skipping..."
        return
    fi

    echo ""
    echo "    Scroll direction options:"
    echo "    1) Natural scrolling (Mac-style: finger down pushes content up)"
    echo "    2) Traditional scrolling (finger down = scroll down)"
    echo ""
    read -p "    Select scroll direction [1-2]: " SCROLL_OPTION

    if [[ "$SCROLL_OPTION" == "2" ]]; then
        gsettings set org.gnome.desktop.peripherals.mouse natural-scroll false 2>/dev/null || true
        print_success "Set traditional scrolling (scroll down = page goes down)"
    else
        gsettings set org.gnome.desktop.peripherals.mouse natural-scroll true 2>/dev/null || true
        print_success "Set natural scrolling (Mac-style)"
    fi
}

###############################################################################
# Configure Mouse Speed and Acceleration
###############################################################################
setup_mouse_speed() {
    print_step "Configuring mouse speed..."

    if ! command -v gsettings &>/dev/null; then
        print_warning "gsettings not found. Skipping..."
        return
    fi

    current_speed=$(gsettings get org.gnome.desktop.peripherals.mouse speed 2>/dev/null || echo "0.0")
    echo ""
    echo "    Current mouse speed: $current_speed"
    echo "    Range: -1.0 (slowest) to 1.0 (fastest)"
    echo ""
    read -p "    Enter new speed (or press Enter to skip): " NEW_SPEED

    if [ -n "$NEW_SPEED" ]; then
        gsettings set org.gnome.desktop.peripherals.mouse speed "$NEW_SPEED" 2>/dev/null || true
        print_success "Mouse speed set to $NEW_SPEED"
    fi

    echo ""
    echo "    Mouse acceleration profiles:"
    echo "    1) default  - Standard acceleration"
    echo "    2) flat     - No acceleration (1:1 movement)"
    echo "    3) adaptive - Speed-based acceleration"
    echo ""
    read -p "    Select profile [1-3] (Enter to skip): " ACCEL_OPTION

    case $ACCEL_OPTION in
        1) gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'default' 2>/dev/null && print_success "Set default acceleration" ;;
        2) gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat' 2>/dev/null && print_success "Set flat acceleration (no acceleration)" ;;
        3) gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'adaptive' 2>/dev/null && print_success "Set adaptive acceleration" ;;
    esac
}

###############################################################################
# Configure Magic Mouse Driver
###############################################################################
setup_magic_mouse_driver() {
    print_step "Configuring Magic Mouse kernel driver..."

    echo ""
    echo "    Scroll speed options:"
    echo "    1) Slow"
    echo "    2) Medium (recommended)"
    echo "    3) Fast"
    echo "    4) Very fast"
    echo ""
    read -p "    Select scroll speed [1-4]: " SCROLL_SPEED_OPTION

    local scroll_speed=32
    case $SCROLL_SPEED_OPTION in
        1) scroll_speed=16 ;;
        2) scroll_speed=32 ;;
        3) scroll_speed=48 ;;
        4) scroll_speed=63 ;;
    esac

    print_info "Setting up hid-magicmouse driver with scroll speed $scroll_speed..."

    sudo tee /etc/modprobe.d/hid-magicmouse.conf > /dev/null << DRIVEREOF
# Magic Mouse configuration
options hid_magicmouse scroll_acceleration=1
options hid_magicmouse scroll_speed=$scroll_speed
options hid_magicmouse emulate_3button=1
options hid_magicmouse emulate_scroll_wheel=1
DRIVEREOF

    # Reload the module
    sudo modprobe -r hid_magicmouse 2>/dev/null || true
    sudo modprobe hid_magicmouse 2>/dev/null || true

    print_success "Magic Mouse driver configured"
    print_info "Reconnect your Magic Mouse for changes to take effect"
}

###############################################################################
# Show current configuration
###############################################################################
show_status() {
    print_step "Current Magic Mouse configuration:"

    echo ""
    if command -v gsettings &>/dev/null; then
        echo "    Scroll direction: $(gsettings get org.gnome.desktop.peripherals.mouse natural-scroll 2>/dev/null || echo 'N/A')"
        echo "    Mouse speed: $(gsettings get org.gnome.desktop.peripherals.mouse speed 2>/dev/null || echo 'N/A')"
        echo "    Acceleration: $(gsettings get org.gnome.desktop.peripherals.mouse accel-profile 2>/dev/null || echo 'N/A')"
    fi

    echo ""
    echo "    Driver config: $(cat /etc/modprobe.d/hid-magicmouse.conf 2>/dev/null | grep scroll_speed || echo 'Not configured')"
}

###############################################################################
# Main Menu
###############################################################################
main() {
    echo ""
    echo "    What would you like to configure?"
    echo ""
    echo "    1) Full setup (recommended for first time)"
    echo "    2) Scroll direction only"
    echo "    3) Mouse speed/acceleration only"
    echo "    4) Configure driver (scroll speed)"
    echo "    5) Show current status"
    echo "    0) Exit"
    echo ""
    read -p "    Select option [0-5]: " OPTION

    case $OPTION in
        1)
            setup_scroll_direction
            setup_mouse_speed
            setup_magic_mouse_driver
            ;;
        2)
            setup_scroll_direction
            ;;
        3)
            setup_mouse_speed
            ;;
        4)
            setup_magic_mouse_driver
            ;;
        5)
            show_status
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
    echo -e "${GREEN}║              Magic Mouse Configuration Complete! 🖱️                ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

main "$@"
