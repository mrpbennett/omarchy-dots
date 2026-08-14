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

Stow mirrors the repo into `$HOME`, symlinking **each file individually**
(stow 2.4+ defaults to `--no-folding`), so adding or removing a single file
inside an already-stowed directory only touches that file — everything else
stays put.

Re-apply the symlinks anytime with:

```bash
stow --dir="$HOME/.dotfiles" --target="$HOME" --restow omarchy-dots
```

### Add a new app's config

Installed a new app that wrote to `~/.config/foo`? Move the whole directory
into the repo (this also keeps whatever settings the app generated) and restow:

```bash
mv ~/.config/foo ~/.dotfiles/omarchy-dots/.config/
stow --dir="$HOME/.dotfiles" --target="$HOME" --restow omarchy-dots
```

`~/.config/foo` is now a symlink tree into the repo, so edits happen inside the
repo and land in `git status` for committing.

### Add a new file inside an already-stowed directory

Because each file is symlinked individually, a brand-new file an app drops into
a stowed dir (e.g. `~/.config/ghostty/something.conf`) is just sitting there
untracked. Move it into the matching repo dir and restow:

```bash
mv ~/.config/ghostty/something.conf ~/.dotfiles/omarchy-dots/.config/ghostty/
stow --dir="$HOME/.dotfiles" --target="$HOME" --restow omarchy-dots
```

The inverse works too — delete a file from the repo dir and `--restow` removes
its symlink.

### Adopt a regenerated config

Apps sometimes rewrite a file the repo already tracks (e.g. nvim regenerates
`lazy-lock.json`). `--adopt` pulls the live content into the repo, replacing the
real file with a symlink so nothing you configured is lost:

```bash
stow --dir="$HOME/.dotfiles" --target="$HOME" --adopt omarchy-dots
```

Then `git diff` inside the repo to review what changed and commit it.

### Dry run

Check what would change without touching anything:

```bash
stow --dir="$HOME/.dotfiles" --target="$HOME" --restow --simulate omarchy-dots
```

### Excluding machine-specific junk

Runtime files that shouldn't be tracked (or cause repo churn) go in
`.stow-local-ignore` at the repo root — nvim's `lazy-lock.json` is already
listed there as an example.

## License

[MIT](LICENSE)
