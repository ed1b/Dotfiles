#!/usr/bin/env bash
# macOS System & Finder Dracula Appearance Settings

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Enable Dark Mode globally (Finder, System UI, native apps)
defaults write -g AppleInterfaceStyle -string "Dark" 2>/dev/null || true
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' 2>/dev/null || true

# 2. Set Purple Accent Color (Dracula purple accent for Finder, buttons, controls)
defaults write -g AppleAccentColor -int 5 2>/dev/null || true

# 3. Set Dracula Wallpaper
if [ -f "$DOTFILES_DIR/wallpapers/Dracula-macos.png" ]; then
    osascript -e "tell application \"System Events\" to set picture of every desktop to \"$DOTFILES_DIR/wallpapers/Dracula-macos.png\"" 2>/dev/null || true
elif [ -f "$HOME/Developer/Dotfiles/wallpapers/Dracula-macos.png" ]; then
    osascript -e "tell application \"System Events\" to set picture of every desktop to \"$HOME/Developer/Dotfiles/wallpapers/Dracula-macos.png\"" 2>/dev/null || true
fi

echo "macOS Dracula system appearance settings applied!"
