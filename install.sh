#!/usr/bin/env bash
# Zero Terminal - Installer for macOS/Linux
# Usage: bash <(curl -s https://raw.githubusercontent.com/tanvir-cpp/zero-terminal/main/install.sh)

set -e

THEME_NAME="zero"
THEME_FILE="${THEME_NAME}.omp.json"
REPO_OWNER="tanvir-cpp"
REPO_NAME="zero-terminal"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}"
THEME_URL="${RAW_BASE}/theme/${THEME_FILE}"
THEMES_DIR="${HOME}/.config/oh-my-posh/themes"
FONT="CascadiaCode"

NO_FONT=false
NO_PROFILE=false
UNINSTALL=false

# ─── Parse args ──────────────────────────────────────────────────────────────
for arg in "$@"; do
  case $arg in
    --no-font)    NO_FONT=true ;;
    --no-profile) NO_PROFILE=true ;;
    --uninstall)  UNINSTALL=true ;;
  esac
done

# ─── Colors ──────────────────────────────────────────────────────────────────
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
RESET='\033[0m'

step()  { echo -e "  ${CYAN}-->  $1${RESET}"; }
ok()    { echo -e "  ${GREEN}[OK] $1${RESET}"; }
warn()  { echo -e "  ${YELLOW}[!!] $1${RESET}"; }
fail()  { echo -e "  ${RED}[XX] $1${RESET}"; exit 1; }

banner() {
  echo -e "${BLUE}"
  echo '  ███████╗███████╗██████╗  ██████╗     ████████╗███████╗██████╗ ███╗   ███╗'
  echo '     ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║'
  echo '       ███╔╝ █████╗  ██████╔╝██║   ██║       ██║   █████╗  ██████╔╝██╔████╔██║'
  echo '      ███╔╝  ██╔══╝  ██╔══██╗██║   ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║'
  echo '     ███████╗███████╗██║  ██║╚██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║'
  echo '     ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝'
  echo -e "${RESET}"
  echo -e "                    Terminal Theme  |  github.com/${REPO_OWNER}/${REPO_NAME}"
  echo ""
}

# ─── Detect shell profile ────────────────────────────────────────────────────
detect_profile() {
  if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "$(which zsh)" ]; then
    echo "${HOME}/.zshrc"
  elif [ -n "$BASH_VERSION" ] || [ "$SHELL" = "$(which bash)" ]; then
    echo "${HOME}/.bashrc"
  else
    echo "${HOME}/.profile"
  fi
}

# ─── Uninstall ───────────────────────────────────────────────────────────────
uninstall() {
  step "Removing Zero Terminal theme..."

  local target="${THEMES_DIR}/${THEME_FILE}"
  if [ -f "$target" ]; then
    rm -f "$target"
    ok "Theme file removed."
  fi

  local profile
  profile=$(detect_profile)
  if [ -f "$profile" ]; then
    grep -v "zero-terminal\|oh-my-posh init" "$profile" > "${profile}.tmp" && mv "${profile}.tmp" "$profile"
    ok "Shell profile cleaned: $profile"
  fi

  echo ""
  ok "Zero Terminal uninstalled. Restart your terminal."
  exit 0
}

# ─── Install Oh My Posh ──────────────────────────────────────────────────────
install_omp() {
  if command -v oh-my-posh &>/dev/null; then
    ok "Oh My Posh already installed."
    return
  fi

  step "Installing Oh My Posh..."

  if [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew &>/dev/null; then
      brew install jandedobbeleer/oh-my-posh/oh-my-posh
    else
      warn "Homebrew not found. Installing via official script..."
      curl -s https://ohmyposh.dev/install.sh | bash -s
    fi
  else
    curl -s https://ohmyposh.dev/install.sh | bash -s
  fi

  if command -v oh-my-posh &>/dev/null; then
    ok "Oh My Posh installed."
  else
    fail "Oh My Posh installation failed. Install manually: https://ohmyposh.dev/docs/installation/linux"
  fi
}

# ─── Install Nerd Font ───────────────────────────────────────────────────────
install_font() {
  if [ "$NO_FONT" = true ]; then
    warn "Skipping font installation (--no-font)."
    return
  fi

  step "Installing ${FONT} Nerd Font..."
  if oh-my-posh font install "$FONT"; then
    ok "Font installed. Set it in your terminal: 'CaskaydiaCove Nerd Font'."
  else
    warn "Font install failed. Install manually: https://www.nerdfonts.com/font-downloads"
  fi
}

# ─── Install Theme ───────────────────────────────────────────────────────────
install_theme() {
  mkdir -p "$THEMES_DIR"
  local target="${THEMES_DIR}/${THEME_FILE}"

  # If running locally (theme folder exists next to script), copy directly
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local local_theme="${script_dir}/theme/${THEME_FILE}"

  if [ -f "$local_theme" ]; then
    step "Copying theme from local source..."
    cp "$local_theme" "$target"
  else
    step "Downloading theme from GitHub..."
    if command -v curl &>/dev/null; then
      curl -fsSL "$THEME_URL" -o "$target" || fail "Could not download theme from: $THEME_URL"
    elif command -v wget &>/dev/null; then
      wget -q "$THEME_URL" -O "$target" || fail "Could not download theme from: $THEME_URL"
    else
      fail "Neither curl nor wget found. Please install one and retry."
    fi
  fi

  ok "Theme installed to: $target"
  THEME_PATH="$target"
}

# ─── Update Shell Profile ────────────────────────────────────────────────────
update_profile() {
  if [ "$NO_PROFILE" = true ]; then
    warn "Skipping profile update (--no-profile)."
    echo "  Add this manually to your shell profile:"
    echo "    eval \"\$(oh-my-posh init \$(basename \$SHELL) --config \"${THEME_PATH}\")\""
    return
  fi

  local profile
  profile=$(detect_profile)

  # Remove any existing oh-my-posh init line
  if grep -q "oh-my-posh init" "$profile" 2>/dev/null; then
    step "Updating existing Oh My Posh config in profile..."
    grep -v "oh-my-posh init\|zero-terminal" "$profile" > "${profile}.tmp" && mv "${profile}.tmp" "$profile"
  else
    step "Adding Zero Terminal theme to shell profile..."
  fi

  echo "" >> "$profile"
  echo "eval \"\$(oh-my-posh init \$(basename \$SHELL) --config \"${THEME_PATH}\")\"  # zero-terminal" >> "$profile"

  ok "Profile updated: $profile"
}

# ─── Complete ────────────────────────────────────────────────────────────────
show_complete() {
  echo ""
  echo -e "  ${BLUE}=================================================================${RESET}"
  echo -e "  ${GREEN} Zero Terminal installed!${RESET}"
  echo -e "  ${BLUE}=================================================================${RESET}"
  echo ""
  echo "  Next steps:"
  echo "   1. Restart your terminal (or run: source ~/.zshrc)"
  echo "   2. Set font to 'CaskaydiaCove Nerd Font' in your terminal app"
  echo ""
}

# ─── Entry Point ─────────────────────────────────────────────────────────────
banner

[ "$UNINSTALL" = true ] && uninstall

install_omp
install_font
install_theme
update_profile
show_complete
