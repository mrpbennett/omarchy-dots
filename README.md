# Omarchy Dots

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Shell: Bash](https://img.shields.io/badge/shell-bash-4EAA25.svg)](install.sh)

Opinionated dotfiles for [Omarchy](https://github.com/omarchy/omarchy) — my
personal take on a polished, terminal-first desktop. Managed with GNU Stow,
built around **ghostty** as the default terminal, **zsh** + **starship**, and
a curated set of CLI tools.

## Features

- **Ghostty-first terminal** — foot, alacritty, and kitty are removed and
  replaced by ghostty
- **Zsh + Starship** prompt out of the box
- **Neovim** with a batteries-included config
- **Hyprland** setup for a clean, minimal desktop
- **Trino CLI** installed and ready for data work
- **Mise** for runtime version management
- **Extras**: atuin, bitwarden, ghostty, gh-dash, lazygit, tmux, yazi,
  visidata, and more

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/mrpbennett/omarchy-dots/main/install.sh | bash
```

The installer will:

1. Clone the repo into `~/.dotfiles/omarchy-dots`
2. Install required packages via `omarchy` (stow, bitwarden, ghostty, zsh)
3. Remove stock webapps and default packages you don't need
4. Install Omarchy plugins (qs-fortivpn, radio-atlas)
5. Stow the dotfiles into your home, backing up any existing configs to
   `~/.local/share/omarchy-dots-backup`
6. Update mise and install the latest Trino CLI

## Layout

The repo mirrors your `$HOME`, so Stow can symlink everything into place:

```
~/.dotfiles/omarchy-dots/
├── .config/       # per-app configs (hypr, ghostty, nvim, tmux, …)
├── .local/        # local additions
├── .zshrc         # zsh setup
└── install.sh     # the bootstrap script
```

## Usage

Re-apply the symlinks anytime with:

```bash
stow --dir="$HOME/.dotfiles" --target="$HOME" --restow omarchy-dots
```

## License

[MIT](LICENSE)
