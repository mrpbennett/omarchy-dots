#!/usr/bin/bash

set -euo pipefail

REPO_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.local/share/omarchy-dots-backup"

cat <<'EOF'

 ________  _____ ______   ________  ________  ________  ___  ___      ___    ___      ________  ________  _________  ________      
|\   __  \|\   _ \  _   \|\   __  \|\   __  \|\   ____\|\  \|\  \    |\  \  /  /|    |\   ___ \|\   __  \|\___   ___\\   ____\     
\ \  \|\  \ \  \\\__\ \  \ \  \|\  \ \  \|\  \ \  \___|\ \  \\\  \   \ \  \/  / /    \ \  \_|\ \ \  \|\  \|___ \  \_\ \  \___|_    
 \ \  \\\  \ \  \\|__| \  \ \   __  \ \   _  _\ \  \    \ \   __  \   \ \    / /      \ \  \ \\ \ \  \\\  \   \ \  \ \ \_____  \   
  \ \  \\\  \ \  \    \ \  \ \  \ \  \ \  \\  \\ \  \____\ \  \ \  \   \/   / /        \ \  \_\\ \ \  \\\  \   \ \  \ \|____|\  \  
   \ \_______\ \__\    \ \__\ \__\ \__\ \__\\ _\\ \_______\ \__\ \__\__/   / /          \ \_______\ \_______\   \ \__\  ____\_\  \ 
    \|_______|\|__|     \|__|\|__|\|__|\|__|\|__|\|_______|\|__|\|__|\____/ /            \|_______|\|_______|    \|__| |\_________\
                                                                    \|____|/                                           \|_________|

EOF

# Resolve the dotfiles directory: prefer the repo beside this script, fall back
# to REPO_DIR, and clone from GitHub if neither exists yet.
DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$REPO_DIR}")" 2>/dev/null && pwd || true)

if [[ ! -d $DOTFILES_DIR/.git ]]; then
  DOTFILES_DIR=$REPO_DIR
  if [[ ! -d $DOTFILES_DIR/.git ]]; then
    mkdir -p "$(dirname "$DOTFILES_DIR")"
    git clone --depth 1 https://github.com/mrpbennett/omarchy-dots.git "$DOTFILES_DIR"
  fi
fi

# remove default webapps and packages
clean_omarchy() {
  # standard webapps i want to remove
  webapps=(
    "Basecamp"
    "Google Contacts"
    "Google Maps"
    "Google Messages"
    "Google Photos"
    "HEY"
  )

  for webapp in "${webapps[@]}"; do
    omarchy webapp remove "$webapp" || true
  done

  # standard packages i want to remove
  packages=(
    "alacritty"
    "kitty"
    "kdenlive"
    "pinta"
    "obs-studio"
  )

  for package in "${packages[@]}"; do
    omarchy pkg drop "$package" || true
  done

  # remove stale config dirs
  stale_config_directories=(
    "alacritty"
    "kitty"
  )

  for dir in "${stale_config_directories[@]}"; do
    if [[ -d "$HOME/.config/$dir" ]]; then
      rm -r "$HOME/.config/$dir"
    fi
  done

}

# install packages that aren't default
install_required_packages() {
  packages=(
    "stow"
    "bitwarden"
    "bitwarden-cli"
  )

  for package in "${packages[@]}"; do
    omarchy pkg add "${package}"
  done

  # set ghostty as default
  omarchy-install-terminal ghostty

}

# switch from bash to zsh
setup_zsh() {
  omarchy pkg add omarchy-zsh
  omarchy-setup-zsh
}

# install omarchy shell plugins from their git remotes
install_omarchy_plugins() {
  plugin_urls=(
    "https://github.com/mrpbennett/qs-fortivpn.git"
    "https://github.com/mrpbennett/qs-dusk.git"
    "https://github.com/mrpbennett/qs-herdr-agents.git"
    "https://github.com/sspaeti/omarchy-timezones-plugin.git"
    "https://github.com/AksharP5/omarchy-radio-atlas.git"
  )

  for url in "${plugin_urls[@]}"; do
    omarchy plugin add "$url" --enable --yes || true
  done

  # disable default lock screen for a custom one
  omarchy plugin disable omarchy.lock

}

# symlink the dotfiles repo into $HOME (repo root mirrors $HOME layout)
stow_dotfiles() {
  local stow_dir package conflict stow_bin config
  local required_configs=(.zshrc .config/starship.toml)

  if ! stow_bin=$(command -v stow); then
    echo "ERROR: GNU Stow was not found on PATH. Install it with: omarchy pkg add stow" >&2
    return 1
  fi
  echo "Stow executable: $stow_bin"
  if ! stow --version; then
    echo "ERROR: Stow is installed but cannot run successfully." >&2
    return 1
  fi

  echo "Stow source: $DOTFILES_DIR"
  echo "Stow target: $HOME"
  for config in "${required_configs[@]}"; do
    if [[ ! -f "$DOTFILES_DIR/$config" ]]; then
      echo "ERROR: Expected repo config is missing: $DOTFILES_DIR/$config" >&2
      return 1
    fi
  done

  # Stow the repo itself as package ".". Using its parent as --dir makes
  # --dir equal --target for ~/.dotfiles, which Stow skips with a warning.
  stow_dir=$DOTFILES_DIR
  package=.

  mkdir -p "$BACKUP_DIR"

  # dry-run first: back up only the exact paths stow reports as conflicts,
  # including foreign/broken symlinks, leaving unrelated files alone.
  # Move links themselves and retain older backups on repeated runs.
  while IFS= read -r conflict; do
    [[ -e "$HOME/$conflict" || -L "$HOME/$conflict" ]] || continue
    mkdir -p "$(dirname "$BACKUP_DIR/$conflict")"
    mv --backup=numbered --no-target-directory -- "$HOME/$conflict" "$BACKUP_DIR/$conflict"
    echo "backed up existing $HOME/$conflict -> $BACKUP_DIR/$conflict"
  done < <(stow --dir="$stow_dir" --target="$HOME" --no-folding --simulate --verbose=2 "$package" 2>&1 |
    sed -n \
      -e 's/^CONFLICT when stowing [^:]*: cannot stow .* over existing target \(.*\) since neither a link nor a directory.*/\1/p' \
      -e 's/^CONFLICT when stowing [^:]*: existing target is not owned by stow: \(.*\)/\1/p')

  if ! stow --dir="$stow_dir" --target="$HOME" --no-folding --restow --verbose "$package"; then
    echo "ERROR: Stow failed to link dotfiles from $DOTFILES_DIR into $HOME." >&2
    return 1
  fi

  for config in "${required_configs[@]}"; do
    if [[ ! -L "$HOME/$config" || ! "$HOME/$config" -ef "$DOTFILES_DIR/$config" ]]; then
      echo "ERROR: Stow finished, but $HOME/$config is not linked to $DOTFILES_DIR/$config." >&2
      return 1
    fi
    echo "Verified: $HOME/$config -> $DOTFILES_DIR/$config"
  done
  echo "Stow completed; .zshrc and Starship config links verified."
}

omarchy_update_mise_and_dev() {
  omarchy update mise

  # install krew: plugin manager for kubectl
  (
    set -x
    cd "$(mktemp -d)" &&
      OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
      ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
      KREW="krew-${OS}_${ARCH}" &&
      curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
      tar zxvf "${KREW}.tar.gz" &&
      ./"${KREW}" install krew
  )
}

omarchy_final_touches() {
  # enabling my custom lock screen
  omarchy plugin enable omarchy-custom.lock

  # set global font size
  omarchy display text size 13

  # restart shell
  omarchy restart shell
}

# FUNCTIONS ---
# Install ghostty and set it as default before removing foot, so the system
# never has a default terminal pointing at an uninstalled package.
install_required_packages
clean_omarchy
setup_zsh
install_omarchy_plugins
stow_dotfiles
omarchy_update_mise_and_dev
omarchy_final_touches
