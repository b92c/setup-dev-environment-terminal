#!/bin/bash

## Author: b92c

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

INSTALL_ZSH=1
INSTALL_KITTY=1
INSTALL_TMUX=1
INSTALL_NEOVIM=1
INSTALL_YAZI=1
INSTALL_BTOP=1
INSTALL_BANDWHICH=1
INSTALL_BROWSH=1
INSTALL_FZF=1
INSTALL_ZOXIDE=1
INSTALL_FONTS=1

declare -a APP_NAMES=(
    "ZSH + Oh-My-Zsh (shell with plugins)"
    "Kitty (terminal emulator)"
    "Tmux (terminal multiplexer)"
    "Neovim + LazyVim (complete IDE)"
    "Yazi (file manager)"
    "Btop (system monitor)"
    "Bandwhich (network monitor)"
    "Browsh (terminal browser)"
    "FZF (fuzzy finder)"
    "Zoxide (smart navigation)"
    "Nerd Fonts (fonts with icons)"
)

declare -a APP_VARS=(
    "INSTALL_ZSH"
    "INSTALL_KITTY"
    "INSTALL_TMUX"
    "INSTALL_NEOVIM"
    "INSTALL_YAZI"
    "INSTALL_BTOP"
    "INSTALL_BANDWHICH"
    "INSTALL_BROWSH"
    "INSTALL_FZF"
    "INSTALL_ZOXIDE"
    "INSTALL_FONTS"
)

show_selection_menu() {
    local current=0
    local total=${#APP_NAMES[@]}

    while true; do
        clear
        echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
        echo -e "${PURPLE}  🚀 DEVELOPMENT ENVIRONMENT SETUP 🚀${NC}"
        echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo -e "${CYAN}Select the applications you want to install:${NC}"
        echo -e "${DIM}Use ↑↓ or j/k to navigate, SPACE or x to toggle${NC}"
        echo -e "${DIM}Use 1-9,0,- for direct toggle | 'a' all | ENTER confirm | 'q' quit${NC}"
        echo ""

        for i in "${!APP_NAMES[@]}"; do
            local var_name="${APP_VARS[$i]}"
            local value="${!var_name}"
            local checkbox
            local num_key

            if [ "$i" -lt 9 ]; then
                num_key="$((i + 1))"
            elif [ "$i" -eq 9 ]; then
                num_key="0"
            else
                num_key="-"
            fi

            if [ "$value" -eq 1 ]; then
                checkbox="${GREEN}[✓]${NC}"
            else
                checkbox="${RED}[ ]${NC}"
            fi

            if [ "$i" -eq "$current" ]; then
                echo -e "  ${WHITE}▶${NC} ${DIM}${num_key}.${NC} $checkbox ${WHITE}${APP_NAMES[$i]}${NC}"
            else
                echo -e "    ${DIM}${num_key}.${NC} $checkbox ${APP_NAMES[$i]}"
            fi
        done

        echo ""
        echo -e "${DIM}────────────────────────────────────────────────────────────${NC}"

        local selected=0
        for var in "${APP_VARS[@]}"; do
            [ "${!var}" -eq 1 ] && ((selected++)) || true
        done
        echo -e "${BLUE}Selected: ${selected}/${total}${NC}"

        local key=""
        IFS= read -rsn1 key

        if [[ "$key" == $'\x1b' ]]; then
            read -rsn2 -t 0.1 rest || true
            key+="$rest"
        fi

        case "$key" in
            $'\x1b[A'|'k')
                ((current--)) || true
                [ "$current" -lt 0 ] && current=$((total - 1))
                ;;
            $'\x1b[B'|'j')
                ((current++)) || true
                [ "$current" -ge "$total" ] && current=0
                ;;
            ' '|'x'|'X')
                local var_name="${APP_VARS[$current]}"
                if [ "${!var_name}" -eq 1 ]; then
                    eval "$var_name=0"
                else
                    eval "$var_name=1"
                fi
                ;;
            '1') eval "INSTALL_ZSH=$((1 - INSTALL_ZSH))" ;;
            '2') eval "INSTALL_KITTY=$((1 - INSTALL_KITTY))" ;;
            '3') eval "INSTALL_TMUX=$((1 - INSTALL_TMUX))" ;;
            '4') eval "INSTALL_NEOVIM=$((1 - INSTALL_NEOVIM))" ;;
            '5') eval "INSTALL_YAZI=$((1 - INSTALL_YAZI))" ;;
            '6') eval "INSTALL_BTOP=$((1 - INSTALL_BTOP))" ;;
            '7') eval "INSTALL_BANDWHICH=$((1 - INSTALL_BANDWHICH))" ;;
            '8') eval "INSTALL_BROWSH=$((1 - INSTALL_BROWSH))" ;;
            '9') eval "INSTALL_FZF=$((1 - INSTALL_FZF))" ;;
            '0') eval "INSTALL_ZOXIDE=$((1 - INSTALL_ZOXIDE))" ;;
            '-') eval "INSTALL_FONTS=$((1 - INSTALL_FONTS))" ;;
            'a'|'A')
                local all_selected=1
                for var in "${APP_VARS[@]}"; do
                    [ "${!var}" -eq 0 ] && all_selected=0 && break
                done

                local new_value=$((1 - all_selected))
                for var in "${APP_VARS[@]}"; do
                    eval "$var=$new_value"
                done
                ;;
            'q'|'Q')
                echo ""
                print_warning "Installation cancelled by user"
                exit 0
                ;;
            $'\x1b')
                echo ""
                print_warning "Installation cancelled by user"
                exit 0
                ;;
            '')
                local any_selected=0
                for var in "${APP_VARS[@]}"; do
                    [ "${!var}" -eq 1 ] && any_selected=1 && break
                done

                if [ "$any_selected" -eq 0 ]; then
                    echo -e "\n${YELLOW}Please select at least one application!${NC}"
                    sleep 1
                else
                    break
                fi
                ;;
            *)
                ;;
        esac
    done

    clear
    echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  📋 INSTALLATION SUMMARY${NC}"
    echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Will be installed:${NC}"

    for i in "${!APP_NAMES[@]}"; do
        local var_name="${APP_VARS[$i]}"
        if [ "${!var_name}" -eq 1 ]; then
            echo -e "  ${GREEN}✓${NC} ${APP_NAMES[$i]}"
        fi
    done

    echo ""
    echo -e "${DIM}Will be skipped:${NC}"
    local any_skipped=0
    for i in "${!APP_NAMES[@]}"; do
        local var_name="${APP_VARS[$i]}"
        if [ "${!var_name}" -eq 0 ]; then
            echo -e "  ${DIM}○ ${APP_NAMES[$i]}${NC}"
            any_skipped=1
        fi
    done
    [ "$any_skipped" -eq 0 ] && echo -e "  ${DIM}(none)${NC}"

    echo ""
    read -p "Confirm and start installation? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ ! -z $REPLY ]]; then
        print_warning "Installation cancelled by user"
        exit 0
    fi
}

print_header() {
    echo -e "\n${PURPLE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  $1${NC}"
    echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}\n"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_installing() {
    echo -e "${CYAN}[INSTALLING]${NC} $1..."
}

detect_package_manager() {
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
        PKG_INSTALL="sudo apt install -y"
        PKG_UPDATE="sudo apt update"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        PKG_INSTALL="sudo dnf install -y"
        PKG_UPDATE="sudo dnf check-update || true"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        PKG_INSTALL="sudo pacman -S --noconfirm"
        PKG_UPDATE="sudo pacman -Sy"
    elif command -v zypper &> /dev/null; then
        PKG_MANAGER="zypper"
        PKG_INSTALL="sudo zypper install -y"
        PKG_UPDATE="sudo zypper refresh"
    else
        print_error "Unsupported package manager!"
        exit 1
    fi
    print_status "Package manager detected: $PKG_MANAGER"
}

command_exists() {
    command -v "$1" &> /dev/null
}

update_repos() {
    print_status "Updating repositories..."
    eval "$PKG_UPDATE"
    print_success "Repositories updated"
}

install_base_dependencies() {
    print_header "Installing Base Dependencies"

    local deps="git curl wget unzip tar build-essential"

    if [ "$PKG_MANAGER" = "pacman" ]; then
        deps="git curl wget unzip tar base-devel"
    elif [ "$PKG_MANAGER" = "dnf" ]; then
        deps="git curl wget unzip tar gcc gcc-c++ make"
    fi

    print_installing "Base dependencies"
    eval "$PKG_INSTALL $deps"
    print_success "Base dependencies installed"
}

install_zsh() {
    print_header "ZSH + Oh-My-Zsh"

    if command_exists zsh; then
        print_success "ZSH is already installed"
    else
        print_installing "ZSH"
        eval "$PKG_INSTALL zsh"
        print_success "ZSH installed"
    fi

    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_success "Oh-My-Zsh is already installed"
    else
        print_installing "Oh-My-Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh-My-Zsh installed"
    fi

    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        print_success "Plugin zsh-autosuggestions is already installed"
    else
        print_installing "Plugin zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        print_success "Plugin zsh-autosuggestions installed"
    fi

    if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        print_success "Plugin zsh-syntax-highlighting is already installed"
    else
        print_installing "Plugin zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        print_success "Plugin zsh-syntax-highlighting installed"
    fi

    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"

        if grep -q "plugins=(git)" "$HOME/.zshrc"; then
            sed -i 's/plugins=(git)/plugins=(git docker zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"
            print_success "Plugins configured in .zshrc"
        elif ! grep -q "zsh-autosuggestions" "$HOME/.zshrc"; then
            sed -i 's/plugins=(\(.*\))/plugins=(\1 docker zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"
            print_success "Plugins added to .zshrc"
        else
            print_success "Plugins already configured in .zshrc"
        fi
    fi

    if [ "$SHELL" != "$(which zsh)" ]; then
        print_status "Setting ZSH as default shell..."
        chsh -s "$(which zsh)"
        print_success "ZSH set as default shell"
    else
        print_success "ZSH is already the default shell"
    fi
}

install_kitty() {
    print_header "Kitty Terminal Emulator"

    if command_exists kitty; then
        print_success "Kitty is already installed"
    else
        print_installing "Kitty"
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

        mkdir -p "$HOME/.local/bin"
        ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/"
        ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/"

        mkdir -p "$HOME/.local/share/applications"
        cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications/"
        cp "$HOME/.local/kitty.app/share/applications/kitty-open.desktop" "$HOME/.local/share/applications/"
        sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" "$HOME/.local/share/applications/kitty*.desktop"

        print_success "Kitty installed"
    fi

    mkdir -p "$HOME/.config/kitty"
    if [ ! -f "$HOME/.config/kitty/kitty.conf" ]; then
        cat > "$HOME/.config/kitty/kitty.conf" << 'EOF'
font_family      JetBrainsMono Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size        12.0

cursor_shape beam
cursor_blink_interval 0.5

scrollback_lines 10000

mouse_hide_wait 3.0
url_style curly

enable_audio_bell no
visual_bell_duration 0.0

remember_window_size  yes
initial_window_width  120c
initial_window_height 35c
window_padding_width  10

tab_bar_edge bottom
tab_bar_style powerline
tab_powerline_style slanted

foreground              #CDD6F4
background              #1E1E2E
selection_foreground    #1E1E2E
selection_background    #F5E0DC

cursor                  #F5E0DC
cursor_text_color       #1E1E2E

url_color               #F5E0DC

color0 #45475A
color8 #585B70

color1 #F38BA8
color9 #F38BA8

color2  #A6E3A1
color10 #A6E3A1

color3  #F9E2AF
color11 #F9E2AF

color4  #89B4FA
color12 #89B4FA

color5  #F5C2E7
color13 #F5C2E7

color6  #94E2D5
color14 #94E2D5

color7  #BAC2DE
color15 #A6ADC8

map ctrl+shift+c copy_to_clipboard
map ctrl+shift+v paste_from_clipboard
map ctrl+shift+t new_tab
map ctrl+shift+q close_tab
map ctrl+shift+right next_tab
map ctrl+shift+left previous_tab
map ctrl+shift+enter new_window
map ctrl+shift+w close_window
EOF
        print_success "Kitty configuration created"
    else
        print_success "Kitty configuration already exists"
    fi
}

install_tmux() {
    print_header "Tmux"

    if command_exists tmux; then
        print_success "Tmux is already installed"
    else
        print_installing "Tmux"
        eval "$PKG_INSTALL tmux"
        print_success "Tmux installed"
    fi

    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        print_success "TPM is already installed"
    else
        print_installing "TPM (Tmux Plugin Manager)"
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        print_success "TPM installed"
    fi

    if [ ! -f "$HOME/.tmux.conf" ]; then
        cat > "$HOME/.tmux.conf" << 'EOF'
unbind C-b
set -g prefix C-a
bind C-a send-prefix

bind r source-file ~/.tmux.conf \; display "Config reloaded!"

set -g mouse on

set -g base-index 1
setw -g pane-base-index 1

set -g renumber-windows on

set -g history-limit 50000

setw -g mode-keys vi

bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

set -g status-position bottom
set -g status-style 'bg=#1e1e2e fg=#cdd6f4'
set -g status-left '#[fg=#1e1e2e,bg=#89b4fa,bold] #S #[fg=#89b4fa,bg=#1e1e2e]'
set -g status-left-length 30
set -g status-right '#[fg=#45475a]#[fg=#cdd6f4,bg=#45475a] %H:%M #[fg=#89b4fa]#[fg=#1e1e2e,bg=#89b4fa,bold] %d/%m/%Y '
set -g status-right-length 50

setw -g window-status-current-style 'fg=#1e1e2e bg=#a6e3a1 bold'
setw -g window-status-current-format ' #I:#W#F '

setw -g window-status-style 'fg=#cdd6f4 bg=#313244'
setw -g window-status-format ' #I:#W#F '

set -g pane-border-style 'fg=#45475a'
set -g pane-active-border-style 'fg=#89b4fa'

set -g message-style 'fg=#1e1e2e bg=#f9e2af bold'

set -sg escape-time 0

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-yank'

set -g @continuum-restore 'on'
set -g @resurrect-capture-pane-contents 'on'

run '~/.tmux/plugins/tpm/tpm'
EOF
        print_success "Tmux configuration created"
        print_status "Run 'prefix + I' inside Tmux to install plugins"
    else
        print_success "Tmux configuration already exists"
    fi
}

install_neovim() {
    print_header "Neovim + LazyVim"

    if command_exists nvim; then
        local nvim_version=$(nvim --version | head -n1 | grep -oP '\d+\.\d+')
        if (( $(echo "$nvim_version >= 0.9" | bc -l) )); then
            print_success "Neovim $nvim_version is already installed"
        else
            print_warning "Neovim outdated. Installing latest version..."
            install_neovim_latest
        fi
    else
        install_neovim_latest
    fi

    print_status "Checking LazyVim dependencies..."

    if ! command_exists rg; then
        print_installing "ripgrep"
        eval "$PKG_INSTALL ripgrep"
    fi

    if ! command_exists fd; then
        print_installing "fd-find"
        if [ "$PKG_MANAGER" = "apt" ]; then
            eval "$PKG_INSTALL fd-find"
            if [ -f "/usr/bin/fdfind" ] && [ ! -f "$HOME/.local/bin/fd" ]; then
                mkdir -p "$HOME/.local/bin"
                ln -s /usr/bin/fdfind "$HOME/.local/bin/fd"
            fi
        else
            eval "$PKG_INSTALL fd"
        fi
    fi

    if ! command_exists lazygit; then
        print_installing "lazygit"
        if [ "$PKG_MANAGER" = "pacman" ]; then
            eval "$PKG_INSTALL lazygit"
        else
            LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            tar xf lazygit.tar.gz lazygit
            sudo install lazygit /usr/local/bin
            rm -f lazygit lazygit.tar.gz
        fi
    fi

    if [ -d "$HOME/.config/nvim" ] && [ -f "$HOME/.config/nvim/lazy-lock.json" ]; then
        print_success "LazyVim is already installed"
    else
        print_installing "LazyVim"

        if [ -d "$HOME/.config/nvim" ]; then
            mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d%H%M%S)"
        fi
        if [ -d "$HOME/.local/share/nvim" ]; then
            mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.backup.$(date +%Y%m%d%H%M%S)"
        fi
        if [ -d "$HOME/.local/state/nvim" ]; then
            mv "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.backup.$(date +%Y%m%d%H%M%S)"
        fi
        if [ -d "$HOME/.cache/nvim" ]; then
            mv "$HOME/.cache/nvim" "$HOME/.cache/nvim.backup.$(date +%Y%m%d%H%M%S)"
        fi

        git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
        rm -rf "$HOME/.config/nvim/.git"

        print_success "LazyVim installed"
    fi

    configure_lazyvim_plugins
}

install_neovim_latest() {
    print_installing "Neovim (latest version)"

    if [ "$PKG_MANAGER" = "pacman" ]; then
        eval "$PKG_INSTALL neovim"
    else
        print_status "Downloading Neovim AppImage..."
        curl -fLo /tmp/nvim.appimage https://github.com/neovim/neovim/releases/latest/download/nvim.appimage

        if [ -f /tmp/nvim.appimage ]; then
            chmod u+x /tmp/nvim.appimage
            sudo mkdir -p /opt/nvim
            sudo mv /tmp/nvim.appimage /opt/nvim/nvim.appimage
            sudo ln -sf /opt/nvim/nvim.appimage /usr/local/bin/nvim
            print_success "Neovim installed via AppImage"
        else
            print_status "AppImage failed, trying tar.gz..."
            local nvim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"

            curl -fL "$nvim_url" -o /tmp/nvim-linux64.tar.gz

            if file /tmp/nvim-linux64.tar.gz | grep -q "gzip"; then
                sudo rm -rf /opt/nvim-linux64
                sudo tar -C /opt -xzf /tmp/nvim-linux64.tar.gz
                sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
                rm -f /tmp/nvim-linux64.tar.gz
                print_success "Neovim installed via tar.gz"
            else
                print_error "Neovim download failed. Trying via package manager..."
                rm -f /tmp/nvim-linux64.tar.gz

                if [ "$PKG_MANAGER" = "apt" ]; then
                    sudo add-apt-repository -y ppa:neovim-ppa/unstable 2>/dev/null || true
                    sudo apt update
                    eval "$PKG_INSTALL neovim"
                elif [ "$PKG_MANAGER" = "dnf" ]; then
                    eval "$PKG_INSTALL neovim"
                fi
            fi
        fi
    fi
}

configure_lazyvim_plugins() {
    print_status "Configuring LazyVim extra plugins..."

    local plugins_dir="$HOME/.config/nvim/lua/plugins"
    mkdir -p "$plugins_dir"

    if [ ! -f "$plugins_dir/obsidian.lua" ]; then
        cat > "$plugins_dir/obsidian.lua" << 'EOF'
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Documents/obsidian-vault",
      },
      {
        name = "work",
        path = "~/Documents/work-vault",
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    new_notes_location = "current_dir",
    wiki_link_func = function(opts)
      return string.format("[[%s]]", opts.path)
    end,
    mappings = {
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
    },
    ui = {
      enable = true,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
      },
    },
  },
}
EOF
        print_success "Plugin obsidian.nvim configured"
    else
        print_success "Plugin obsidian.nvim already configured"
    fi

    if [ ! -f "$plugins_dir/dadbod.lua" ]; then
        cat > "$plugins_dir/dadbod.lua" << 'EOF'
return {
  {
    "tpope/vim-dadbod",
    cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 40

      vim.g.db_ui_table_helpers = {
        postgresql = {
          Count = "SELECT COUNT(*) FROM {optional_schema}{table}",
          List = "SELECT * FROM {optional_schema}{table} LIMIT 100",
        },
        mysql = {
          Count = "SELECT COUNT(*) FROM {table}",
          List = "SELECT * FROM {table} LIMIT 100",
        },
      }

      vim.g.db_ui_icons = {
        expanded = {
          db = "▾ ",
          buffers = "▾ ",
          saved_queries = "▾ ",
          schemas = "▾ ",
          schema = "▾ ",
          tables = "▾ ",
          table = "▾ ",
        },
        collapsed = {
          db = "▸ ",
          buffers = "▸ ",
          saved_queries = "▸ ",
          schemas = "▸ ",
          schema = "▸ ",
          tables = "▸ ",
          table = "▸ ",
        },
        saved_query = "",
        new_query = "󰓰",
        tables = "󰓫",
        buffers = "",
        add_connection = "",
        connection_ok = "✓",
        connection_error = "✕",
      }
    end,
    keys = {
      { "<leader>Du", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<CR>", desc = "Find Buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<CR>", desc = "Rename Buffer" },
      { "<leader>Dq", "<cmd>DBUILastQueryInfo<CR>", desc = "Last Query Info" },
    },
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = "vim-dadbod",
    ft = { "sql", "mysql", "plsql" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          local cmp = require("cmp")
          local sources = vim.tbl_map(function(source)
            return { name = source.name }
          end, cmp.get_config().sources)

          table.insert(sources, { name = "vim-dadbod-completion" })
          cmp.setup.buffer({ sources = sources })
        end,
      })
    end,
  },
}
EOF
        print_success "Plugin DadBod configured"
    else
        print_success "Plugin DadBod already configured"
    fi
}

install_yazi() {
    print_header "Yazi (File Manager)"

    if command_exists yazi; then
        print_success "Yazi is already installed"
    else
        print_installing "Yazi"

        if [ "$PKG_MANAGER" = "pacman" ]; then
            eval "$PKG_INSTALL yazi ffmpegthumbnailer unarchiver jq poppler fd ripgrep fzf zoxide imagemagick"
        else
            if ! command_exists cargo; then
                print_status "Installing Rust..."
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
                source "$HOME/.cargo/env"
            fi

            cargo install --force yazi-build

            print_status "Installing Yazi dependencies..."
            if [ "$PKG_MANAGER" = "apt" ]; then
                eval "$PKG_INSTALL ffmpegthumbnailer unar jq poppler-utils imagemagick"
            elif [ "$PKG_MANAGER" = "dnf" ]; then
                eval "$PKG_INSTALL ffmpegthumbnailer unar jq poppler-utils ImageMagick"
            fi
        fi

        print_success "Yazi installed"
    fi

    mkdir -p "$HOME/.config/yazi"
    if [ ! -f "$HOME/.config/yazi/yazi.toml" ]; then
        cat > "$HOME/.config/yazi/yazi.toml" << 'EOF'
[manager]
ratio = [1, 4, 3]
sort_by = "natural"
sort_sensitive = false
sort_reverse = false
sort_dir_first = true
linemode = "size"
show_hidden = false
show_symlink = true

[preview]
tab_size = 2
max_width = 600
max_height = 900
cache_dir = ""
ueberzug_scale = 1
ueberzug_offset = [0, 0, 0, 0]

[opener]
edit = [
    { run = 'nvim "$@"', block = true, for = "unix" },
]
open = [
    { run = 'xdg-open "$@"', desc = "Open", for = "linux" },
]
reveal = [
    { run = 'xdg-open "$(dirname "$0")"', desc = "Reveal", for = "linux" },
]
extract = [
    { run = 'unar "$1"', desc = "Extract here", for = "unix" },
]

[open]
rules = [
    { name = "*/", use = ["edit", "open", "reveal"] },
    { mime = "text/*", use = ["edit", "reveal"] },
    { mime = "image/*", use = ["open", "reveal"] },
    { mime = "video/*", use = ["open", "reveal"] },
    { mime = "audio/*", use = ["open", "reveal"] },
    { mime = "inode/x-empty", use = ["edit", "reveal"] },
    { mime = "application/json", use = ["edit", "reveal"] },
    { mime = "*/javascript", use = ["edit", "reveal"] },
    { mime = "application/zip", use = ["extract", "reveal"] },
    { mime = "application/gzip", use = ["extract", "reveal"] },
    { mime = "application/x-tar", use = ["extract", "reveal"] },
    { mime = "application/x-bzip", use = ["extract", "reveal"] },
    { mime = "application/x-bzip2", use = ["extract", "reveal"] },
    { mime = "application/x-7z-compressed", use = ["extract", "reveal"] },
    { mime = "application/x-rar", use = ["extract", "reveal"] },
    { mime = "*", use = ["open", "reveal"] },
]

[tasks]
micro_workers = 5
macro_workers = 10
bizarre_retry = 5
image_alloc = 536870912
image_bound = [0, 0]

[log]
enabled = false
EOF
        print_success "Yazi configuration created"
    else
        print_success "Yazi configuration already exists"
    fi

    if [ -f "$HOME/.zshrc" ] && ! grep -q "function yy()" "$HOME/.zshrc"; then
        cat >> "$HOME/.zshrc" << 'EOF'

function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
EOF
        print_success "Function yy() added to .zshrc"
    fi
}

install_btop() {
    print_header "Btop (System Monitor)"

    if command_exists btop; then
        print_success "Btop is already installed"
    else
        print_installing "Btop"

        if [ "$PKG_MANAGER" = "apt" ]; then
            eval "$PKG_INSTALL btop"
        elif [ "$PKG_MANAGER" = "pacman" ]; then
            eval "$PKG_INSTALL btop"
        elif [ "$PKG_MANAGER" = "dnf" ]; then
            eval "$PKG_INSTALL btop"
        else
            print_status "Installing btop via snap..."
            if command_exists snap; then
                sudo snap install btop
            else
                print_warning "Could not install btop automatically"
            fi
        fi

        print_success "Btop installed"
    fi

    mkdir -p "$HOME/.config/btop"
    if [ ! -f "$HOME/.config/btop/btop.conf" ]; then
        cat > "$HOME/.config/btop/btop.conf" << 'EOF'
color_theme = "catppuccin_mocha"
theme_background = True
truecolor = True
force_tty = False
presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty"
vim_keys = True
rounded_corners = True
graph_symbol = "braille"
shown_boxes = "cpu mem net proc"
update_ms = 1000
proc_sorting = "cpu lazy"
proc_reversed = False
proc_tree = False
proc_colors = True
proc_gradient = True
proc_per_core = True
proc_mem_bytes = True
proc_cpu_graphs = True
proc_info_smaps = False
proc_left = False
proc_filter_kernel = False
cpu_graph_upper = "total"
cpu_graph_lower = "total"
cpu_invert_lower = True
cpu_single_graph = False
cpu_bottom = False
show_uptime = True
check_temp = True
cpu_sensor = "Auto"
show_coretemp = True
cpu_core_map = ""
temp_scale = "celsius"
base_10_sizes = False
show_cpu_freq = True
clock_format = "%X"
background_update = True
custom_cpu_name = ""
disks_filter = ""
mem_graphs = True
mem_below_net = False
zfs_arc_cached = True
show_swap = True
swap_disk = True
show_disks = True
only_physical = True
use_fstab = True
zfs_hide_datasets = False
disk_free_priv = False
show_io_stat = True
io_mode = False
io_graph_combined = False
io_graph_speeds = ""
net_download = 100
net_upload = 100
net_auto = True
net_sync = True
net_iface = ""
show_battery = True
selected_battery = "Auto"
log_level = "WARNING"
EOF
        print_success "Btop configuration created"
    else
        print_success "Btop configuration already exists"
    fi
}

install_bandwhich() {
    print_header "Bandwhich (Network Monitor)"

    if command_exists bandwhich; then
        print_success "Bandwhich is already installed"
    else
        print_installing "Bandwhich"

        if [ "$PKG_MANAGER" = "pacman" ]; then
            eval "$PKG_INSTALL bandwhich"
        else
            if ! command_exists cargo; then
                print_status "Installing Rust..."
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
                source "$HOME/.cargo/env"
            fi

            cargo install bandwhich

            if [ -f "$HOME/.cargo/bin/bandwhich" ]; then
                sudo setcap cap_sys_ptrace,cap_dac_read_search,cap_net_raw,cap_net_admin+ep "$HOME/.cargo/bin/bandwhich"
            fi
        fi

        print_success "Bandwhich installed"
    fi
}

install_browsh() {
    print_header "Browsh (Terminal Browser)"

    if ! command_exists firefox; then
        print_installing "Firefox (dependency for Browsh)"
        if [ "$PKG_MANAGER" = "apt" ]; then
            eval "$PKG_INSTALL firefox-esr || $PKG_INSTALL firefox"
        else
            eval "$PKG_INSTALL firefox"
        fi
        print_success "Firefox installed"
    fi

    if command_exists browsh; then
        print_success "Browsh is already installed"
    else
        print_installing "Browsh"

        if ! command_exists firefox; then
            print_status "Installing Firefox (Browsh dependency)..."
            if [ "$PKG_MANAGER" = "apt" ]; then
                eval "$PKG_INSTALL firefox-esr"
            else
                eval "$PKG_INSTALL firefox"
            fi
        fi

        local browsh_version="1.8.2"
        local arch="linux_amd64"

        curl -LO "https://github.com/browsh-org/browsh/releases/download/v${browsh_version}/browsh_${browsh_version}_${arch}.deb" 2>/dev/null || \
        curl -LO "https://github.com/browsh-org/browsh/releases/download/v${browsh_version}/browsh_${browsh_version}_linux_amd64.deb"

        if [ -f "browsh_${browsh_version}_${arch}.deb" ] || [ -f "browsh_${browsh_version}_linux_amd64.deb" ]; then
            if [ "$PKG_MANAGER" = "apt" ]; then
                sudo dpkg -i browsh_*.deb || sudo apt-get install -f -y
            else
                ar x browsh_*.deb
                tar xf data.tar.xz
                sudo mv usr/local/bin/browsh /usr/local/bin/
                rm -rf usr control.tar.* data.tar.* debian-binary
            fi
            rm -f browsh_*.deb
            print_success "Browsh installed"
        else
            print_warning "Could not download Browsh. Try installing manually."
        fi
    fi
}

install_fzf() {
    print_header "FZF (Fuzzy Finder)"

    if ! command_exists fd; then
        print_installing "fd (dependency for fzf)"
        if [ "$PKG_MANAGER" = "apt" ]; then
            eval "$PKG_INSTALL fd-find"
            if [ -f "/usr/bin/fdfind" ] && [ ! -f "$HOME/.local/bin/fd" ]; then
                mkdir -p "$HOME/.local/bin"
                ln -sf /usr/bin/fdfind "$HOME/.local/bin/fd"
            fi
        else
            eval "$PKG_INSTALL fd"
        fi
        print_success "fd installed"
    fi

    if command_exists fzf; then
        print_success "FZF is already installed"
    else
        print_installing "FZF"

        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install" --all --no-bash --no-fish

        print_success "FZF installed"
    fi

    if [ -f "$HOME/.zshrc" ] && ! grep -q "FZF Configuration" "$HOME/.zshrc"; then
        cat >> "$HOME/.zshrc" << 'EOF'

# FZF Configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='
  --height 60%
  --layout=reverse
  --border rounded
  --preview-window=right:60%:wrap
  --bind ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'

export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
EOF
        print_success "FZF configuration added to .zshrc"
    fi
}

install_zoxide() {
    print_header "Zoxide (Smart Directory Jumper)"

    if command_exists zoxide; then
        print_success "Zoxide is already installed"
    else
        print_installing "Zoxide"

        if [ "$PKG_MANAGER" = "pacman" ]; then
            eval "$PKG_INSTALL zoxide"
        else
            curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        fi

        print_success "Zoxide installed"
    fi

    if [ -f "$HOME/.zshrc" ] && ! grep -q 'eval "$(zoxide init' "$HOME/.zshrc"; then
        cat >> "$HOME/.zshrc" << 'EOF'

eval "$(zoxide init zsh)"

alias cd="z"
alias cdi="zi"
EOF
        print_success "Zoxide configured in .zshrc"
    fi
}

setup_path() {
    print_header "Configuring PATH"

    local path_additions='
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
'

    if [ -f "$HOME/.zshrc" ] && ! grep -q 'HOME/.local/bin' "$HOME/.zshrc"; then
        echo "$path_additions" >> "$HOME/.zshrc"
        print_success "PATH configured in .zshrc"
    fi
}

install_fonts() {
    print_header "Installing Nerd Fonts"

    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    if ls "$font_dir" | grep -qi "JetBrains" 2>/dev/null; then
        print_success "JetBrainsMono Nerd Font is already installed"
    else
        print_installing "JetBrainsMono Nerd Font"

        curl -fLo "$font_dir/JetBrainsMono.zip" \
            https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip

        unzip -o "$font_dir/JetBrainsMono.zip" -d "$font_dir"
        rm "$font_dir/JetBrainsMono.zip"

        fc-cache -fv

        print_success "JetBrainsMono Nerd Font installed"
    fi
}

main() {
    show_selection_menu

    echo ""
    print_header "🚀 STARTING INSTALLATION 🚀"

    detect_package_manager

    update_repos

    install_base_dependencies

    [ "$INSTALL_FONTS" -eq 1 ] && install_fonts

    [ "$INSTALL_ZSH" -eq 1 ] && install_zsh
    [ "$INSTALL_KITTY" -eq 1 ] && install_kitty
    [ "$INSTALL_TMUX" -eq 1 ] && install_tmux
    [ "$INSTALL_NEOVIM" -eq 1 ] && install_neovim
    [ "$INSTALL_YAZI" -eq 1 ] && install_yazi
    [ "$INSTALL_BTOP" -eq 1 ] && install_btop
    [ "$INSTALL_BANDWHICH" -eq 1 ] && install_bandwhich
    [ "$INSTALL_BROWSH" -eq 1 ] && install_browsh
    [ "$INSTALL_FZF" -eq 1 ] && install_fzf
    [ "$INSTALL_ZOXIDE" -eq 1 ] && install_zoxide

    setup_path

    print_header "✅ INSTALLATION COMPLETE!"

    echo -e "${GREEN}Selected tools have been installed and configured!${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    [ "$INSTALL_ZSH" -eq 1 ] && echo "  • Restart terminal or run: source ~/.zshrc"
    [ "$INSTALL_NEOVIM" -eq 1 ] && echo "  • Open Neovim to install plugins: nvim"
    [ "$INSTALL_TMUX" -eq 1 ] && echo "  • In Tmux, press 'prefix + I' to install plugins"
    [ "$INSTALL_NEOVIM" -eq 1 ] && echo "  • Configure your Obsidian vaults in ~/.config/nvim/lua/plugins/obsidian.lua"
    [ "$INSTALL_NEOVIM" -eq 1 ] && echo "  • Configure your database connections in DadBod"
    echo ""
    echo -e "${CYAN}Useful commands:${NC}"
    [ "$INSTALL_KITTY" -eq 1 ] && echo "  • kitty          - Terminal emulator"
    [ "$INSTALL_TMUX" -eq 1 ] && echo "  • tmux           - Terminal multiplexer"
    [ "$INSTALL_NEOVIM" -eq 1 ] && echo "  • nvim           - Neovim IDE"
    [ "$INSTALL_YAZI" -eq 1 ] && echo "  • yy             - Yazi file manager (with cd on exit)"
    [ "$INSTALL_BTOP" -eq 1 ] && echo "  • btop           - System monitor"
    [ "$INSTALL_BANDWHICH" -eq 1 ] && echo "  • bandwhich      - Network monitor (may need sudo)"
    [ "$INSTALL_BROWSH" -eq 1 ] && echo "  • browsh         - Terminal browser"
    [ "$INSTALL_FZF" -eq 1 ] && echo "  • fzf            - Fuzzy finder (Ctrl+T, Ctrl+R, Alt+C)"
    [ "$INSTALL_ZOXIDE" -eq 1 ] && echo "  • z <dir>        - Smart directory jump"
    [ "$INSTALL_ZOXIDE" -eq 1 ] && echo "  • zi             - Interactive directory jump"
    echo ""
    echo -e "${PURPLE}Enjoy your new development environment! 🎉${NC}"
}

main "$@"
