#!/usr/bin/env bash
# Zero Terminal - Uninstaller for macOS/Linux
# Usage: bash <(curl -s https://raw.githubusercontent.com/tanvir-cpp/zero-terminal/main/uninstall.sh)

set -e

THEME_FILE="zero.omp.json"
THEMES_DIR="${HOME}/.config/oh-my-posh/themes"

CYAN='\033[0;36m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

step() { echo -e "  ${CYAN}-->  $1${RESET}"; }
ok()   { echo -e "  ${GREEN}[OK] $1${RESET}"; }

echo -e "${BLUE}"
echo "  Zero Terminal - Uninstaller"
echo -e "${RESET}"

# Remove theme file
target="${THEMES_DIR}/${THEME_FILE}"
if [ -f "$target" ]; then
  step "Removing theme file..."
  rm -f "$target"
  ok "Theme file removed."
else
  ok "Theme file not found, skipping."
fi

# Detect and clean shell profile
if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "$(which zsh 2>/dev/null)" ]; then
  PROFILE="${HOME}/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ "$SHELL" = "$(which bash 2>/dev/null)" ]; then
  PROFILE="${HOME}/.bashrc"
else
  PROFILE="${HOME}/.profile"
fi

if [ -f "$PROFILE" ] && grep -q "zero-terminal\|oh-my-posh init" "$PROFILE"; then
  step "Cleaning shell profile: $PROFILE..."
  grep -v "zero-terminal\|oh-my-posh init" "$PROFILE" > "${PROFILE}.tmp" && mv "${PROFILE}.tmp" "$PROFILE"
  ok "Profile cleaned."
else
  ok "No Oh My Posh entry found in profile, skipping."
fi

echo ""
ok "Zero Terminal uninstalled. Restart your terminal."
