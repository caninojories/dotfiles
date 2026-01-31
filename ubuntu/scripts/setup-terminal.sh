#!/bin/bash

###############################################################################
#                     Terminal Setup for Ubuntu                                #
#                     ZSH, Oh-My-Zsh, themes, fonts, and more                 #
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

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Banner
echo -e "${GREEN}"
echo "  ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗     "
echo "  ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║     "
echo "     ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║     "
echo "     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║     "
echo "     ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗"
echo "     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝"
echo -e "${CYAN}                    Terminal Setup for Ubuntu${NC}"
echo ""

###############################################################################
# Install ZSH
###############################################################################
install_zsh() {
    print_step "Installing ZSH..."

    if command -v zsh &>/dev/null; then
        print_info "ZSH already installed: $(zsh --version)"
    else
        sudo apt update
        sudo apt install -y zsh
        print_success "ZSH installed"
    fi
}

###############################################################################
# Install Oh-My-Zsh
###############################################################################
install_oh_my_zsh() {
    print_step "Installing Oh-My-Zsh..."

    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_info "Oh-My-Zsh already installed, updating..."
        cd "$HOME/.oh-my-zsh" && git pull
    else
        print_info "Downloading Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    print_success "Oh-My-Zsh installed"
}

###############################################################################
# Install ZSH Plugins
###############################################################################
install_zsh_plugins() {
    print_step "Installing ZSH plugins..."

    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]; then
        print_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
    else
        print_info "zsh-autosuggestions already installed"
    fi

    # zsh-syntax-highlighting
    if [ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]; then
        print_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"
    else
        print_info "zsh-syntax-highlighting already installed"
    fi

    # zsh-completions
    if [ ! -d "$zsh_custom/plugins/zsh-completions" ]; then
        print_info "Installing zsh-completions..."
        git clone https://github.com/zsh-users/zsh-completions "$zsh_custom/plugins/zsh-completions"
    else
        print_info "zsh-completions already installed"
    fi

    # zsh-history-substring-search
    if [ ! -d "$zsh_custom/plugins/zsh-history-substring-search" ]; then
        print_info "Installing zsh-history-substring-search..."
        git clone https://github.com/zsh-users/zsh-history-substring-search "$zsh_custom/plugins/zsh-history-substring-search"
    else
        print_info "zsh-history-substring-search already installed"
    fi

    print_success "ZSH plugins installed"
}

###############################################################################
# Install ZSH Themes
###############################################################################
install_zsh_themes() {
    print_step "Installing ZSH themes..."

    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local theme_file="$SCRIPT_DIR/../themes/pongstr.zsh-theme"

    # Install pongstr theme from our dotfiles
    if [ -f "$theme_file" ]; then
        cp "$theme_file" "$HOME/.oh-my-zsh/themes/"
        print_success "pongstr.zsh-theme installed"
    else
        print_warning "pongstr.zsh-theme not found, creating fallback..."
        cat > "$HOME/.oh-my-zsh/themes/pongstr.zsh-theme" << 'THEME'
# pongstr ZSH Theme
local time_emoji="⌚"
local skull_emoji="💀"
local ret_status="%(?:%{$fg_bold[green]%}$skull_emoji:%{$fg_bold[red]%}$skull_emoji)"
PROMPT='${time_emoji} %{$fg[white]%}%T%{$reset_color%}
${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
THEME
        print_success "pongstr.zsh-theme created"
    fi

    # Theme selection
    echo ""
    echo "    Available ZSH themes:"
    echo "    1) pongstr (custom theme with skull emoji)"
    echo "    2) agnoster (powerline style - requires Nerd Font)"
    echo "    3) robbyrussell (Oh-My-Zsh default)"
    echo "    4) powerlevel10k (highly customizable - recommended)"
    echo "    5) spaceship (async prompt)"
    echo "    6) Keep current theme"
    echo ""
    read -p "    Select theme [1-6]: " THEME_OPTION

    local selected_theme="pongstr"
    case $THEME_OPTION in
        1) selected_theme="pongstr" ;;
        2) selected_theme="agnoster" ;;
        3) selected_theme="robbyrussell" ;;
        4)
            # Install powerlevel10k
            if [ ! -d "$zsh_custom/themes/powerlevel10k" ]; then
                print_info "Installing Powerlevel10k..."
                git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$zsh_custom/themes/powerlevel10k"
            fi
            selected_theme="powerlevel10k/powerlevel10k"
            print_info "Run 'p10k configure' after restart to customize"
            ;;
        5)
            # Install spaceship
            if [ ! -d "$zsh_custom/themes/spaceship-prompt" ]; then
                print_info "Installing Spaceship prompt..."
                git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$zsh_custom/themes/spaceship-prompt" --depth=1
                ln -sf "$zsh_custom/themes/spaceship-prompt/spaceship.zsh-theme" "$zsh_custom/themes/spaceship.zsh-theme"
            fi
            selected_theme="spaceship"
            ;;
        6)
            print_info "Keeping current theme"
            return
            ;;
    esac

    # Update .zshrc with theme
    if [ -f "$HOME/.zshrc" ]; then
        if grep -q "^ZSH_THEME=" "$HOME/.zshrc"; then
            sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"$selected_theme\"/" "$HOME/.zshrc"
        else
            echo "ZSH_THEME=\"$selected_theme\"" >> "$HOME/.zshrc"
        fi
        print_success "Theme set to: $selected_theme"
    else
        print_warning ".zshrc not found, theme not set"
    fi
}

###############################################################################
# Install Nerd Fonts
###############################################################################
install_nerd_fonts() {
    print_step "Installing Nerd Fonts..."

    local fonts_dir="$HOME/.local/share/fonts"
    mkdir -p "$fonts_dir"

    echo ""
    echo "    Available fonts:"
    echo "    1) JetBrainsMono Nerd Font (recommended for coding)"
    echo "    2) FiraCode Nerd Font (ligatures)"
    echo "    3) MesloLGS NF (recommended for Powerlevel10k)"
    echo "    4) Hack Nerd Font"
    echo "    5) All of the above"
    echo "    6) Skip"
    echo ""
    read -p "    Select fonts to install [1-6]: " FONT_OPTION

    install_jetbrains() {
        if [ ! -f "$fonts_dir/JetBrainsMonoNerdFont-Regular.ttf" ]; then
            print_info "Downloading JetBrainsMono Nerd Font..."
            curl -Lo /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
            unzip -o /tmp/JetBrainsMono.zip -d "$fonts_dir"
            rm /tmp/JetBrainsMono.zip
            print_success "JetBrainsMono installed"
        else
            print_info "JetBrainsMono already installed"
        fi
    }

    install_firacode() {
        if [ ! -f "$fonts_dir/FiraCodeNerdFont-Regular.ttf" ]; then
            print_info "Downloading FiraCode Nerd Font..."
            curl -Lo /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
            unzip -o /tmp/FiraCode.zip -d "$fonts_dir"
            rm /tmp/FiraCode.zip
            print_success "FiraCode installed"
        else
            print_info "FiraCode already installed"
        fi
    }

    install_meslo() {
        if [ ! -f "$fonts_dir/MesloLGS NF Regular.ttf" ]; then
            print_info "Downloading MesloLGS NF..."
            curl -fLo "$fonts_dir/MesloLGS NF Regular.ttf" \
                https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
            curl -fLo "$fonts_dir/MesloLGS NF Bold.ttf" \
                https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
            curl -fLo "$fonts_dir/MesloLGS NF Italic.ttf" \
                https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
            curl -fLo "$fonts_dir/MesloLGS NF Bold Italic.ttf" \
                https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
            print_success "MesloLGS NF installed"
        else
            print_info "MesloLGS NF already installed"
        fi
    }

    install_hack() {
        if [ ! -f "$fonts_dir/HackNerdFont-Regular.ttf" ]; then
            print_info "Downloading Hack Nerd Font..."
            curl -Lo /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
            unzip -o /tmp/Hack.zip -d "$fonts_dir"
            rm /tmp/Hack.zip
            print_success "Hack installed"
        else
            print_info "Hack already installed"
        fi
    }

    case $FONT_OPTION in
        1) install_jetbrains ;;
        2) install_firacode ;;
        3) install_meslo ;;
        4) install_hack ;;
        5)
            install_jetbrains
            install_firacode
            install_meslo
            install_hack
            ;;
        6)
            print_info "Skipping font installation"
            return
            ;;
    esac

    # Refresh font cache
    print_info "Refreshing font cache..."
    fc-cache -fv 2>/dev/null

    print_success "Fonts installed!"
    print_info "Restart your terminal and select the font in preferences"
}

###############################################################################
# Configure GNOME Terminal
###############################################################################
configure_gnome_terminal() {
    print_step "Configuring GNOME Terminal..."

    if ! command -v gnome-terminal &>/dev/null; then
        print_warning "GNOME Terminal not found"
        return
    fi

    # Get the default profile
    local profile_id=$(gsettings get org.gnome.Terminal.ProfilesList default 2>/dev/null | tr -d "'")
    
    if [ -z "$profile_id" ]; then
        print_warning "Could not get GNOME Terminal profile"
        return
    fi

    local profile_path="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile_id/"

    # Theme options
    echo ""
    echo "    Terminal color scheme:"
    echo "    1) Dark (VS Code style)"
    echo "    2) Dracula"
    echo "    3) Solarized Dark"
    echo "    4) Nord"
    echo "    5) Monokai"
    echo "    6) Skip"
    echo ""
    read -p "    Select theme [1-6]: " TERM_THEME

    gsettings set "$profile_path" use-theme-colors false 2>/dev/null || true

    case $TERM_THEME in
        1)
            # VS Code Dark
            gsettings set "$profile_path" background-color '#1e1e1e'
            gsettings set "$profile_path" foreground-color '#d4d4d4'
            gsettings set "$profile_path" bold-color '#ffffff'
            print_success "VS Code Dark theme applied"
            ;;
        2)
            # Dracula
            gsettings set "$profile_path" background-color '#282a36'
            gsettings set "$profile_path" foreground-color '#f8f8f2'
            gsettings set "$profile_path" bold-color '#ffffff'
            print_success "Dracula theme applied"
            ;;
        3)
            # Solarized Dark
            gsettings set "$profile_path" background-color '#002b36'
            gsettings set "$profile_path" foreground-color '#839496'
            gsettings set "$profile_path" bold-color '#93a1a1'
            print_success "Solarized Dark theme applied"
            ;;
        4)
            # Nord
            gsettings set "$profile_path" background-color '#2e3440'
            gsettings set "$profile_path" foreground-color '#d8dee9'
            gsettings set "$profile_path" bold-color '#eceff4'
            print_success "Nord theme applied"
            ;;
        5)
            # Monokai
            gsettings set "$profile_path" background-color '#272822'
            gsettings set "$profile_path" foreground-color '#f8f8f2'
            gsettings set "$profile_path" bold-color '#ffffff'
            print_success "Monokai theme applied"
            ;;
        6)
            print_info "Keeping current theme"
            ;;
    esac

    # Transparency
    echo ""
    read -p "    Enable transparency? (y/N): " ENABLE_TRANS
    if [[ "$ENABLE_TRANS" =~ ^[Yy]$ ]]; then
        gsettings set "$profile_path" use-transparent-background true
        echo ""
        echo "    Transparency level:"
        echo "    1) Slight (10%)"
        echo "    2) Medium (20%)"
        echo "    3) Heavy (30%)"
        read -p "    Select [1-3]: " TRANS_LEVEL

        case $TRANS_LEVEL in
            1) gsettings set "$profile_path" background-transparency-percent 10 ;;
            2) gsettings set "$profile_path" background-transparency-percent 20 ;;
            3) gsettings set "$profile_path" background-transparency-percent 30 ;;
        esac
        print_success "Transparency enabled"
    fi

    # Font configuration
    if fc-list | grep -qi "JetBrainsMono\|Meslo\|FiraCode"; then
        echo ""
        echo "    Terminal font:"
        echo "    1) JetBrainsMono Nerd Font"
        echo "    2) MesloLGS NF"
        echo "    3) FiraCode Nerd Font"
        echo "    4) Keep system font"
        read -p "    Select [1-4]: " FONT_CHOICE

        gsettings set "$profile_path" use-system-font false 2>/dev/null || true
        case $FONT_CHOICE in
            1) gsettings set "$profile_path" font 'JetBrainsMono Nerd Font 12' ;;
            2) gsettings set "$profile_path" font 'MesloLGS NF 12' ;;
            3) gsettings set "$profile_path" font 'FiraCode Nerd Font 12' ;;
            4) gsettings set "$profile_path" use-system-font true ;;
        esac
        print_success "Font configured"
    fi

    # Other settings
    gsettings set "$profile_path" cursor-shape 'block' 2>/dev/null || true
    gsettings set "$profile_path" scrollback-unlimited true 2>/dev/null || true
    gsettings set "$profile_path" audible-bell false 2>/dev/null || true

    print_success "GNOME Terminal configured"
}

###############################################################################
# Install Terminator
###############################################################################
install_terminator() {
    print_step "Installing Terminator..."

    if command -v terminator &>/dev/null; then
        print_info "Terminator already installed"
    else
        sudo apt install -y terminator
    fi

    # Create Terminator config directory
    mkdir -p "$HOME/.config/terminator"

    # Create Terminator config with macOS-like styling
    cat > "$HOME/.config/terminator/config" << 'EOF'
[global_config]
  title_transmit_bg_color = "#1e1e1e"
  title_receive_bg_color = "#2d2d2d"
  title_inactive_bg_color = "#3d3d3d"
  suppress_multiple_term_dialog = True

[keybindings]
  split_horiz = <Super>d
  split_vert = <Super><Shift>d
  close_term = <Super>w
  new_tab = <Super>t
  go_next = <Super><Shift>bracketright
  go_prev = <Super><Shift>bracketleft
  copy = <Super>c
  paste = <Super>v
  search = <Super>f
  zoom_in = <Super>plus
  zoom_out = <Super>minus
  zoom_normal = <Super>0
  toggle_zoom = <Super>Return

[profiles]
  [[default]]
    background_color = "#1e1e1e"
    background_darkness = 0.92
    background_type = transparent
    cursor_color = "#ffffff"
    cursor_shape = block
    font = JetBrainsMono Nerd Font 12
    foreground_color = "#d4d4d4"
    show_titlebar = False
    scrollbar_position = hidden
    scrollback_infinite = True
    use_system_font = False
    bold_is_bright = True
    copy_on_selection = True

  [[dracula]]
    background_color = "#282a36"
    cursor_color = "#f8f8f2"
    foreground_color = "#f8f8f2"
    font = JetBrainsMono Nerd Font 12
    use_system_font = False
    show_titlebar = False

  [[nord]]
    background_color = "#2e3440"
    cursor_color = "#d8dee9"
    foreground_color = "#d8dee9"
    font = JetBrainsMono Nerd Font 12
    use_system_font = False
    show_titlebar = False

  [[solarized-dark]]
    background_color = "#002b36"
    cursor_color = "#839496"
    foreground_color = "#839496"
    font = JetBrainsMono Nerd Font 12
    use_system_font = False
    show_titlebar = False

[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
      size = 1200, 800
    [[[child1]]]
      type = Terminal
      parent = window0
      profile = default

[plugins]
EOF

    print_success "Terminator installed and configured"
    print_info "Keybindings use Super (Cmd) key like macOS"
}

###############################################################################
# Install tmux
###############################################################################
install_tmux() {
    print_step "Installing tmux..."

    if command -v tmux &>/dev/null; then
        print_info "tmux already installed: $(tmux -V)"
    else
        sudo apt install -y tmux
    fi

    # Copy tmux config if it exists
    local tmux_config="$SCRIPT_DIR/../configs/.tmux.conf"
    if [ -f "$tmux_config" ]; then
        cp "$tmux_config" "$HOME/.tmux.conf"
        print_success "tmux configuration copied"
    else
        # Create a basic tmux config
        cat > "$HOME/.tmux.conf" << 'EOF'
# Set prefix to Ctrl+A (like screen, and easier than Ctrl+B)
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Enable mouse support
set -g mouse on

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Increase scrollback buffer
set -g history-limit 50000

# Better colors
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",*256col*:Tc"

# Split panes using | and -
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Vim-style pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Status bar
set -g status-style bg=colour235,fg=colour136
set -g status-left '#[fg=green]#S '
set -g status-right '#[fg=yellow]%Y-%m-%d #[fg=green]%H:%M'
EOF
        print_success "tmux configuration created"
    fi

    print_success "tmux installed"
}

###############################################################################
# Copy ZSH Configuration
###############################################################################
copy_zsh_config() {
    print_step "Copying ZSH configuration..."

    local zshrc_file="$SCRIPT_DIR/../configs/.zshrc"
    
    if [ -f "$zshrc_file" ]; then
        # Backup existing .zshrc
        if [ -f "$HOME/.zshrc" ]; then
            cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
            print_info "Backed up existing .zshrc"
        fi
        
        cp "$zshrc_file" "$HOME/.zshrc"
        print_success ".zshrc copied"
    else
        print_warning ".zshrc not found in configs, keeping existing"
    fi
}

###############################################################################
# Set ZSH as Default Shell
###############################################################################
set_zsh_default() {
    print_step "Setting ZSH as default shell..."

    local current_shell=$(basename "$SHELL")
    
    if [ "$current_shell" = "zsh" ]; then
        print_info "ZSH is already your default shell"
    else
        echo ""
        read -p "    Set ZSH as default shell? (Y/n): " SET_DEFAULT
        if [[ ! "$SET_DEFAULT" =~ ^[Nn]$ ]]; then
            chsh -s $(which zsh)
            print_success "ZSH set as default shell"
            print_info "Log out and back in for the change to take effect"
        fi
    fi
}

###############################################################################
# Show Current Configuration
###############################################################################
show_config() {
    print_step "Current terminal configuration:"
    echo ""

    echo -e "${CYAN}Shell:${NC}"
    echo "    Current shell: $SHELL"
    echo "    ZSH version: $(zsh --version 2>/dev/null || echo 'Not installed')"
    echo ""

    echo -e "${CYAN}Oh-My-Zsh:${NC}"
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "    Installed: Yes"
        if [ -f "$HOME/.zshrc" ]; then
            local theme=$(grep "^ZSH_THEME=" "$HOME/.zshrc" | cut -d'"' -f2)
            echo "    Theme: ${theme:-Not set}"
        fi
    else
        echo "    Installed: No"
    fi
    echo ""

    echo -e "${CYAN}Installed Fonts:${NC}"
    if fc-list | grep -qi "JetBrainsMono"; then
        echo "    ✓ JetBrainsMono Nerd Font"
    fi
    if fc-list | grep -qi "FiraCode"; then
        echo "    ✓ FiraCode Nerd Font"
    fi
    if fc-list | grep -qi "MesloLGS"; then
        echo "    ✓ MesloLGS NF"
    fi
    if fc-list | grep -qi "Hack"; then
        echo "    ✓ Hack Nerd Font"
    fi
    echo ""

    echo -e "${CYAN}Terminals:${NC}"
    command -v gnome-terminal &>/dev/null && echo "    ✓ GNOME Terminal"
    command -v terminator &>/dev/null && echo "    ✓ Terminator"
    command -v tilix &>/dev/null && echo "    ✓ Tilix"
    command -v tmux &>/dev/null && echo "    ✓ tmux ($(tmux -V))"
    echo ""
}

###############################################################################
# Main Menu
###############################################################################
main() {
    echo -e "${YELLOW}Terminal Setup for Ubuntu${NC}"
    echo ""
    echo "Options:"
    echo "    1) Install ZSH"
    echo "    2) Install Oh-My-Zsh + plugins"
    echo "    3) Install/select ZSH theme"
    echo "    4) Install Nerd Fonts"
    echo "    5) Configure GNOME Terminal (colors, transparency)"
    echo "    6) Install Terminator"
    echo "    7) Install tmux"
    echo "    8) Copy ZSH configuration"
    echo "    9) Show current configuration"
    echo "    10) Full terminal setup (recommended)"
    echo "    0) Exit"
    echo ""

    read -p "Select option [0-10]: " MAIN_OPTION

    case $MAIN_OPTION in
        1) install_zsh ;;
        2)
            install_zsh
            install_oh_my_zsh
            install_zsh_plugins
            ;;
        3) install_zsh_themes ;;
        4) install_nerd_fonts ;;
        5) configure_gnome_terminal ;;
        6) install_terminator ;;
        7) install_tmux ;;
        8) copy_zsh_config ;;
        9) show_config ;;
        10)
            # Full setup
            install_zsh
            install_nerd_fonts
            install_oh_my_zsh
            install_zsh_plugins
            install_zsh_themes
            copy_zsh_config
            configure_gnome_terminal
            install_tmux
            set_zsh_default
            
            echo ""
            read -p "    Also install Terminator? (y/N): " ALSO_TERMINATOR
            if [[ "$ALSO_TERMINATOR" =~ ^[Yy]$ ]]; then
                install_terminator
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
    echo -e "${GREEN}║              Terminal Configuration Complete! 🖥️                   ║${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║  Restart your terminal or run: source ~/.zshrc                     ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Run main function
main "$@"
