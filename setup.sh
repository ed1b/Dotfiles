#!/usr/bin/env bash
# ==============================================================================
# Dracula Theme Automated Setup Script for macOS
# Configures: macOS System, Terminal.app, Oh My Zsh, Vim, Nano, Irssi, Wallpaper
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

info()  { printf "\033[34m[INFO]\033[0m %s\n" "$*"; }
ok()    { printf "\033[32m[OK]\033[0m %s\n" "$*"; }
warn()  { printf "\033[33m[WARN]\033[0m %s\n" "$*"; }
fail()  { printf "\033[31m[FAIL]\033[0m %s\n" "$*"; exit 1; }

backup_if_exists() {
    local target="$1"
    if [ -f "$target" ] || [ -d "$target" ]; then
        local backup="${target}.backup_${BACKUP_TIMESTAMP}"
        info "Backing up existing $(basename "$target") -> $(basename "$backup")"
        cp -a "$target" "$backup"
    fi
}

echo "🧛 Starting Dracula Theme Setup for macOS..."
echo "📂 Dotfiles source: $DOTFILES_DIR"
echo ""

# ------------------------------------------------------------------------------
# 1. macOS System & Finder Appearance
# ------------------------------------------------------------------------------
info "Configuring macOS System & Finder appearance..."

# Enable System-wide Dark Mode
defaults write -g AppleInterfaceStyle -string "Dark" 2>/dev/null || true
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' 2>/dev/null || true
ok "macOS Dark Mode enabled"

# Set Accent Color to Purple (#5 in macOS)
defaults write -g AppleAccentColor -int 5 2>/dev/null || true
ok "macOS Accent Color set to Purple (Dracula theme accent)"

# Set Desktop Wallpaper
if [ -f "$DOTFILES_DIR/wallpapers/Dracula-macos.png" ]; then
    mkdir -p "$HOME/Library/Desktop Pictures"
    cp -p "$DOTFILES_DIR/wallpapers/Dracula-macos.png" "$HOME/Library/Desktop Pictures/Dracula-macos.png"
    [ -f "$DOTFILES_DIR/wallpapers/Dracula-base.png" ] && cp -p "$DOTFILES_DIR/wallpapers/Dracula-base.png" "$HOME/Library/Desktop Pictures/Dracula-base.png"
    osascript -e "tell application \"System Events\" to set picture of every desktop to \"$HOME/Library/Desktop Pictures/Dracula-macos.png\"" 2>/dev/null || true
    ok "Dracula wallpaper applied"
else
    warn "Wallpaper Dracula-macos.png not found, skipping"
fi

# ------------------------------------------------------------------------------
# 2. Terminal.app Dracula Profile
# ------------------------------------------------------------------------------
info "Setting up Terminal.app Dracula profile..."

if [ -f "$DOTFILES_DIR/Dracula.terminal" ]; then
    # Headless import via defaults & python3
    if command -v python3 >/dev/null 2>&1; then
        python3 -c "
import plistlib, subprocess
try:
    with open('$DOTFILES_DIR/Dracula.terminal', 'rb') as f:
        profile = plistlib.load(f)
    out = subprocess.check_output(['defaults', 'export', 'com.apple.Terminal', '-'])
    data = plistlib.loads(out)
    data.setdefault('Window Settings', {})['Dracula'] = profile
    data['Default Window Settings'] = 'Dracula'
    data['Startup Window Settings'] = 'Dracula'
    p = subprocess.Popen(['defaults', 'import', 'com.apple.Terminal', '-'], stdin=subprocess.PIPE)
    p.communicate(plistlib.dumps(data))
except Exception as e:
    pass
" 2>/dev/null || true
    fi

    # Also register via open command as fallback if available
    open "$DOTFILES_DIR/Dracula.terminal" 2>/dev/null || true
    defaults write com.apple.Terminal "Default Window Settings" -string "Dracula" 2>/dev/null || true
    defaults write com.apple.Terminal "Startup Window Settings" -string "Dracula" 2>/dev/null || true
    ok "Terminal.app Dracula profile imported and set as default"
else
    warn "Dracula.terminal file not found in $DOTFILES_DIR"
fi

# ------------------------------------------------------------------------------
# 3. Zsh & Oh My Zsh
# ------------------------------------------------------------------------------
info "Setting up Zsh and Oh My Zsh Dracula theme..."

# Check / Install Oh My Zsh if missing
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Oh My Zsh not found. Installing Oh My Zsh..."
    if command -v git >/dev/null 2>&1; then
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" 2>/dev/null || true
        ok "Oh My Zsh installed"
    else
        warn "git is required to install Oh My Zsh. Please install Xcode Command Line Tools first."
    fi
fi

# Install Dracula theme into Oh My Zsh custom themes
if [ -d "$HOME/.oh-my-zsh" ]; then
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    if [ ! -d "$HOME/.oh-my-zsh/custom/themes/dracula" ]; then
        if command -v git >/dev/null 2>&1; then
            git clone --depth=1 https://github.com/dracula/zsh.git "$HOME/.oh-my-zsh/custom/themes/dracula" 2>/dev/null || true
        fi
        if [ ! -f "$HOME/.oh-my-zsh/custom/themes/dracula/dracula.zsh-theme" ]; then
            mkdir -p "$HOME/.oh-my-zsh/custom/themes/dracula"
            cp -p "$DOTFILES_DIR/dracula.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/dracula/dracula.zsh-theme"
        fi
    fi

    # Ensure symlink in themes/
    mkdir -p "$HOME/.oh-my-zsh/themes"
    ln -sf "$HOME/.oh-my-zsh/custom/themes/dracula/dracula.zsh-theme" "$HOME/.oh-my-zsh/themes/dracula.zsh-theme"
    ok "Oh My Zsh Dracula theme installed and linked"
fi

# Deploy .zshrc
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    backup_if_exists "$HOME/.zshrc"
    cp -p "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    ok "~/.zshrc deployed (includes Dracula prompt, LSCOLORS & LS_COLORS)"
fi

# ------------------------------------------------------------------------------
# 4. Vim
# ------------------------------------------------------------------------------
info "Setting up Vim Dracula configuration..."

if [ -f "$DOTFILES_DIR/.vimrc" ]; then
    backup_if_exists "$HOME/.vimrc"
    cp -p "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
    ok "~/.vimrc deployed"

    # Install vim-plug if missing and download dracula/vim
    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        info "Installing vim-plug..."
        curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null || true
    fi

    if [ -f "$HOME/.vim/autoload/plug.vim" ] && command -v vim >/dev/null 2>&1; then
        info "Installing Vim Dracula plugin via vim-plug..."
        vim +PlugInstall +qall >/dev/null 2>&1 || true
        ok "Vim Dracula plugin installed"
    fi
fi

# ------------------------------------------------------------------------------
# 5. Nano
# ------------------------------------------------------------------------------
info "Setting up GNU Nano Dracula theme..."

if [ -f "$DOTFILES_DIR/.nanorc" ]; then
    backup_if_exists "$HOME/.nanorc"
    cp -p "$DOTFILES_DIR/.nanorc" "$HOME/.nanorc"
    ok "~/.nanorc deployed"
fi

# ------------------------------------------------------------------------------
# 6. Irssi
# ------------------------------------------------------------------------------
info "Setting up Irssi Dracula theme..."

mkdir -p "$HOME/.irssi"

if [ -f "$DOTFILES_DIR/dracula.theme" ]; then
    cp -p "$DOTFILES_DIR/dracula.theme" "$HOME/.irssi/dracula.theme"
    ok "Irssi dracula.theme installed into ~/.irssi/"
fi

if [ -f "$DOTFILES_DIR/irssi/config" ]; then
    backup_if_exists "$HOME/.irssi/config"
    cp -p "$DOTFILES_DIR/irssi/config" "$HOME/.irssi/config"
    ok "Irssi config deployed"
fi

# ------------------------------------------------------------------------------
# 7. Firefox
# ------------------------------------------------------------------------------
if [ -f "$DOTFILES_DIR/firefox/dracula-dark-theme.xpi" ]; then
    if [ -d "/Applications/Firefox.app" ]; then
        info "Firefox detected. You can install the Dracula theme add-on by opening:"
        info "  open -a Firefox \"$DOTFILES_DIR/firefox/dracula-dark-theme.xpi\""
    fi
fi

# ------------------------------------------------------------------------------
# 8. Google Antigravity / Gemini CLI
# ------------------------------------------------------------------------------
info "Setting up Google Antigravity / Gemini CLI Dracula guidelines..."

if [ -f "$DOTFILES_DIR/GEMINI.md" ]; then
    mkdir -p "$HOME/.gemini/config"
    if [ -f "$HOME/.gemini/config/GEMINI.md" ] && [ ! -L "$HOME/.gemini/config/GEMINI.md" ]; then
        backup_if_exists "$HOME/.gemini/config/GEMINI.md"
    fi
    ln -sfn "$DOTFILES_DIR/GEMINI.md" "$HOME/.gemini/config/GEMINI.md"
    ln -sfn "$DOTFILES_DIR/GEMINI.md" "$HOME/.gemini/config/AGENTS.md"
    ok "Antigravity / Gemini Dracula config linked to ~/.gemini/config/GEMINI.md"
fi

# ------------------------------------------------------------------------------
# 9. Verification
# ------------------------------------------------------------------------------
echo ""
echo "=============================================================================="
ok "🎉 Dracula Theme Setup Completed Successfully!"
echo "=============================================================================="
echo ""
echo "Next steps:"
echo "  1. Reload your shell:           source ~/.zshrc (or open a new terminal window)"
echo "  2. Run verification check:      $DOTFILES_DIR/check_zshrc_dracula.sh"
if [ -d "/Applications/Firefox.app" ] && [ -f "$DOTFILES_DIR/firefox/dracula-dark-theme.xpi" ]; then
echo "  3. Install Firefox Dracula add-on: open -a Firefox \"$DOTFILES_DIR/firefox/dracula-dark-theme.xpi\""
fi
echo ""
