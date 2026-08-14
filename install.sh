#!/usr/bin/bash

set -euo pipefail

REPO_DIR="$HOME/.local/share/omarchy-dots"
BACKUP_DIR="$HOME/.local/share/omarchy-dots-backup"

cat <<'EOF'

________  ________  ________  _________  ________
|\   ____\|\   ___ \|\   __  \|\___   ___\\   ____\
\ \  \___|\ \  \_|\ \ \  \|\  \|___ \  \_\ \  \___|_
 \ \_____  \ \  \ \\ \ \  \\\  \   \ \  \ \ \_____  \
  \|____|\  \ \  \_\\ \ \  \\\  \   \ \  \ \|____|\  \
    ____\_\  \ \_______\ \_______\   \ \__\  ____\_\  \
   |\_________\|_______|\|_______|    \|__| |\_________\
   \|_________|                             \|_________|

EOF

# Resolve the dotfiles directory: prefer the repo beside this script, fall back
# to REPO_DIR, and clone from GitHub if neither exists yet.
DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$REPO_DIR}")" 2>/dev/null && pwd || true)

if [[ ! -d $DOTFILES_DIR/.git ]]; then
  DOTFILES_DIR=$REPO_DIR
  [[ -d $DOTFILES_DIR/.git ]] || git clone --depth 1 https://github.com/mrpbennett/omarchy-dots.git "$DOTFILES_DIR"
fi

# remove default webapps and packages
clean_omarchy(){
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
    "foot"
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
    "foot"
    "kitty"
  )

  for dir in "${stale_config_directories[@]}"; do
    [[ -d "$HOME/.config/$dir" ]] && rm -r "$HOME/.config/$dir"
  done

}

# install packages that aren't default
install_required_packages(){
  packages=(
    "stow"
    "bitwarden"
    "bitwarden-cli"
  )

  for package in "${packages[@]}"; do
    omarchy pkg add "${package}"
  done
}

# switch from bash to zsh
setup_zsh(){
  omarchy pkg add omarchy-zsh
  omarchy-setup-zsh
}

# symlink the dotfiles repo into $HOME (repo root mirrors $HOME layout)
stow_dotfiles(){
  local stow_dir package conflict
  stow_dir=$(dirname "$DOTFILES_DIR")
  package=$(basename "$DOTFILES_DIR")

  mkdir -p "$BACKUP_DIR"

  # dry-run first: back up only the exact files/dirs stow reports as real
  # (non-symlink) conflicts, so unrelated files sitting alongside them are
  # left alone and the repo's version wins on the real stow run
  while IFS= read -r conflict; do
    [[ -e "$HOME/$conflict" && ! -L "$HOME/$conflict" ]] || continue
    mkdir -p "$(dirname "$BACKUP_DIR/$conflict")"
    mv "$HOME/$conflict" "$BACKUP_DIR/$conflict"
    echo "backed up existing $HOME/$conflict -> $BACKUP_DIR/$conflict"
  done < <(stow --dir="$stow_dir" --target="$HOME" --simulate --verbose=2 "$package" 2>&1 \
            | sed -n \
                -e 's/^CONFLICT when stowing [^:]*: cannot stow .* over existing target \(.*\) since neither a link nor a directory.*/\1/p' \
                -e 's/^CONFLICT when stowing [^:]*: existing target is not owned by stow: \(.*\)/\1/p')

  stow --dir="$stow_dir" --target="$HOME" --restow --verbose "$package"
}

omarchy_update_mise(){
  omarchy update mise
}

# download the Trino CLI self-executing jar and install it as `trino`
# https://trino.io/docs/current/client/cli.html#installation
install_trino_cli(){
  local version bin_dir
  version=$(curl -fsSL https://api.github.com/repos/trinodb/trino/releases/latest \
    | grep -m1 '"tag_name"' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')
  bin_dir="$HOME/.local/bin"

  mkdir -p "$bin_dir"
  curl -fsSL -o "$bin_dir/trino" \
    "https://github.com/trinodb/trino/releases/download/${version}/trino-cli-${version}"
  chmod +x "$bin_dir/trino"
}


# FUNCTIONS ---
clean_omarchy
install_required_packages
setup_zsh
stow_dotfiles
omarchy_update_mise
install_trino_cli
