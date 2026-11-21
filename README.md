# 🧛 Dracula macOS Dotfiles

A cohesive, automated [Dracula Theme](https://draculatheme.com) environment for macOS, shell, editors, and CLI tools.

---

## ✨ Features

- **macOS System**: Enables Dark Mode, sets native Purple accent color, and applies Dracula desktop wallpapers.
- **Terminal.app**: Pre-configured `Dracula.terminal` profile imported as default.
- **Zsh & Oh My Zsh**: Dracula prompt theme (`dracula.zsh-theme`), Dracula-styled `LSCOLORS` / `LS_COLORS`, and colored tab completions.
- **Vim**: Dracula color scheme with automated `vim-plug` setup.
- **GNU Nano**: Full Dracula syntax highlighting rules and interface palette.
- **Irssi**: Matching Dracula IRC client theme and configuration.
- **Firefox**: Bundled Dracula Dark Theme add-on (`.xpi`).
- **Antigravity / Gemini**: Dracula palette rules for charts, Mermaid diagrams, and UI artifacts (`GEMINI.md`).

---

## 🚀 Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/your-username/Dotfiles.git ~/Developer/Dotfiles
cd ~/Developer/Dotfiles
```

### 2. Run the automated installer

```bash
chmod +x setup.sh
./setup.sh
```

> **Note:** The script automatically creates timestamped backups (e.g., `~/.zshrc.backup_<timestamp>`) before modifying existing configuration files.

### 3. Reload your environment

```bash
source ~/.zshrc
```

---

## 🔍 Verification

Run the built-in test script to verify your Zsh and Oh My Zsh Dracula configuration:

```bash
./check_zshrc_dracula.sh
```

---

## 📁 Repository Structure

```text
├── .nanorc                    # GNU Nano Dracula palette & syntax rules
├── .vimrc                     # Vim configuration with Dracula plugin
├── .zshrc                     # Zsh configuration (Dracula theme, LSCOLORS)
├── Dracula.terminal           # Apple Terminal Dracula color scheme
├── GEMINI.md                  # Antigravity & Gemini Dracula theme rules
├── dracula.zsh-theme          # Oh My Zsh Dracula theme file
├── dracula.theme              # Irssi Dracula theme
├── check_zshrc_dracula.sh     # Health-check script for shell configuration
├── setup.sh                   # Main automated installation & backup script
├── macos-dracula-settings.sh  # Standalone macOS UI appearance script
├── firefox/                   # Firefox Dracula extension (.xpi)
├── irssi/                     # Irssi configuration files
└── wallpapers/                # Dracula macOS desktop wallpapers
```

---

## 🌐 Firefox Theme (Optional)

To apply the Dracula theme to Firefox:

```bash
open -a Firefox "firefox/dracula-dark-theme.xpi"
```

---

## 📜 Credits

- Built using the [Dracula Theme](https://draculatheme.com/) color palette.
