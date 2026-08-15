# AGENTS.md

## What this repo is

Opinionated dotfiles for [Omarchy](https://github.com/omarchy/omarchy), a
Hyprland-based desktop. Personal config for ghostty (default terminal),
zsh + starship, neovim (LazyVim), hyprland, tmux, yazi, and assorted CLI tools.

## Critical concept: the repo mirrors `$HOME`

The repo root mirrors `$HOME`, and GNU Stow symlinks each file individually
into place with `--no-folding` (stow 2.4+). **Edits happen inside this repo**,
then are re-applied with stow. After an edit, `git status` in the repo shows the
real diff — the repo is the source of truth, not `~/.config`.

Because each file is symlinked individually (no directory folding), files an app
drops into a stowed dir stay untracked until you move them into the repo dir and
restow.

## Key commands

Use the zsh aliases (`~/.zshrc:30-41`) or run stow directly against this repo
path:

```bash
# re-apply symlinks after editing files in this repo
stow --dir="$HOME/Projects" --target="$HOME" --no-folding --restow omarchy-dots

# adopt a config an app regenerated on disk back into the repo
stow --dir="$HOME/Projects" --target="$HOME" --no-folding --adopt omarchy-dots

# dry run — show what would change without touching anything
stow --dir="$HOME/Projects" --target="$HOME" --no-folding --restow --simulate omarchy-dots
```

After `--adopt`, always `git diff` to review what changed before committing.

## Layout

```
.config/     per-app configs (hypr, ghostty, nvim, tmux, yazi, …)
.local/      local additions (icons, .desktop files)
.zshrc       zsh setup (vi mode, aliases, stow aliases)
install.sh   bootstrap script; runs omarchy installs then stows
```

## Conventions & gotchas

- **Secrets**: `.config/omarchy/shell.json` contains a real FortiVPN username
  and host. Do not commit new credentials; flag if a config is leaking secrets.
- **Machine-specific junk** that must not be committed goes in `.gitignore`
  (repo tracking) and `.stow-local-ignore` (stow exclusion). Examples already
  there: nvim `lazy-lock.json` (churn), `theme.lua` (managed by omarchy theme
  machinery).
- **`.stow-local-ignore` REPLACES** stow's built-in ignore list rather than
  adding to it — stow's defaults are reproduced verbatim there, keep them.
- **install.sh ordering is intentional**: ghostty is installed/set as default
  *before* foot/kitty/alacritty are removed (`install.sh:149-155`).
- Do not edit `~/.config/omarchy/backgrounds/` images or nvim
  `theme.lua` — the omarchy theme machinery owns those.
- **GitHub is read-only** for this repo — no commits, pushes, or PRs unless
  explicitly asked.
- `.md` output files belong in `docs/`, never loose in the repo root.