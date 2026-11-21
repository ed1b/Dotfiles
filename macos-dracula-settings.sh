#!/usr/bin/env bash
# macOS System & Finder Dracula Appearance Settings

# 1. Enable Dark Mode globally (Finder, System UI, native apps)
defaults write -g AppleInterfaceStyle -string "Dark"
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

# 2. Set Purple Accent Color (Dracula purple accent for Finder, buttons, controls)
defaults write -g AppleAccentColor -int 5

# 3. Set Dracula Wallpaper
if [ -f "$HOME/Developer/Dotfiles/wallpapers/Dracula-macos.png" ]; then
    osascript -e "tell application \"System Events\" to set picture of every desktop to \"$HOME/Developer/Dotfiles/wallpapers/Dracula-macos.png\""
fi

echo "macOS Dracula system appearance settings applied!"
