#!/usr/bin/env bash
set -euo pipefail

# Helper functions with proper colour handling (using printf)
status() { printf '\e[32m[OK]\e[0m %s\n' "$*"; }
fail()   { printf '\e[31m[FAIL]\e[0m %s\n' "$*"; exit 1; }
warn()   { printf '\e[33m[WARN]\e[0m %s\n' "$*"; }

# 1️⃣ .zshrc exists
if [[ ! -f "$HOME/.zshrc" ]]; then
  fail ".zshrc does not exist"
fi
status ".zshrc exists"

# 2️⃣ ZSH_THEME is dracula (plain string match, no regex brackets)
if grep -q '^ZSH_THEME="dracula"$' "$HOME/.zshrc"; then
  status "ZSH_THEME is set to dracula"
else
  fail "ZSH_THEME is not set to dracula"
fi

# 3️⃣ Dracula theme file reachable
DRACULA_THEME_PATH=$(zsh -c 'source ${HOME}/.zshrc; echo $ZSH/custom/themes/dracula/dracula.zsh-theme')
if [[ -f "$DRACULA_THEME_PATH" ]]; then
  status "Dracula theme file found at $DRACULA_THEME_PATH"
else
  fail "Dracula theme file not found (expected at $DRACULA_THEME_PATH)"
fi

# 4️⃣ Sourcing .zshrc succeeds
if zsh -c 'source "$HOME/.zshrc"'; then
  status "Sourcing .zshrc succeeds"
else
  fail "Sourcing .zshrc produced errors"
fi

# 5️⃣ Loaded theme is dracula
LOADED_THEME=$(zsh -c 'source "$HOME/.zshrc"; echo $ZSH_THEME')
if [[ "$LOADED_THEME" == "dracula" ]]; then
  status "Loaded theme confirmed: $LOADED_THEME"
else
  fail "Loaded theme mismatch (got $LOADED_THEME)"
fi

# 6️⃣ Prompt colour verification – look for magenta colour codes inside the theme file
if grep -qE "(%F\{magenta\}|%F\{135\})" "$DRACULA_THEME_PATH"; then
  status "Dracula theme file contains magenta colour codes (prompt colour)"
else
  warn "Could not verify magenta colour in the prompt (no explicit magenta code found)"
fi

# 7️⃣ Git plugin is loaded – check that the plugin name appears in the plugins list
if grep -E 'plugins=\([^)]*git' "$HOME/.zshrc" >/dev/null; then
  status "Git plugin is listed in the plugins array"
else
  fail "Git plugin not listed in plugins array"
fi

# 8️⃣ Verify that the git plugin file exists (in $ZSH/custom/plugins or $ZSH/plugins)
GIT_PLUGIN_PATH1="$ZSH/custom/plugins/git/git.plugin.zsh"
GIT_PLUGIN_PATH2="$ZSH/plugins/git/git.plugin.zsh"
if [[ -f "$GIT_PLUGIN_PATH1" || -f "$GIT_PLUGIN_PATH2" ]]; then
  status "Git plugin script file is present"
else
  fail "Git plugin script file not found in $ZSH/custom/plugins or $ZSH/plugins"
fi

printf "\n\e[32m✅ All Zsh/Dracula checks passed!\e[0m\n"
