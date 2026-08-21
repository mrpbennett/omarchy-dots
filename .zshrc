# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load zsh options, keybindings, and completion
[[ -f /usr/share/omarchy-zsh/shell/zoptions ]] && source /usr/share/omarchy-zsh/shell/zoptions

# Load shared shell configuration (aliases, functions, environment, tool init)
[[ -f /usr/share/omarchy-zsh/shell/all ]] && source /usr/share/omarchy-zsh/shell/all

# Add your own customizations below
#
# VI MODE START ---
bindkey -v
KEYTIMEOUT=1

zle-keymap-select() {
  local cursor=$( [[ $KEYMAP == vicmd ]] && echo '\e[1 q' || echo '\e[5 q' )
  echo -ne "$cursor"
}

zle-line-init() { echo -ne '\e[5 q'; }  # beam cursor on new prompt (insert mode)

zle -N zle-keymap-select
zle -N zle-line-init

# VIM MODE END ---
#
# CUSTOM aliases ---

# Stow ---
# add new files to stow
# alias re-omarchy-dots="stow --dir="$HOME/.dotfiles" --target="$HOME" --restow omarchy-dots"
alias re-omarchy-dots="stow --dir="$HOME/Projects" --target="$HOME" --no-folding --restow omarchy-dots"

# adopt new files to stow
# alias ad-omarchy-dots="stow --dir="$HOME/.dotfiles" --target="$HOME" --adopt omarchy-dots"
alias ad-omarchy-dots="stow --dir="$HOME/Projects" --target="$HOME" --no-folding --adopt omarchy-dots"

# dry run stow
# alias dr-omarchy-dots="stow --dir="$HOME/.dotfiles" --target="$HOME" --restow --simulate omarchy-dots"
alias dr-omarchy-dots="stow --dir="$HOME/Projects" --target="$HOME" --no-folding --restow --simulate omarchy-dots"

alias e="exit"
alias v="nvim"
alias h="herdr"
alias bt="btop"
alias cat="bat"
alias curl="curlie"

alias lzg='lazygit'
alias lzd='lazydocker'

alias mi="mise install"
alias mup="mise upgrade"

alias oc="opencode"
alias rtui="redis-tui"

alias dl="cd ~/Downloads/"
alias dev="cd ~/Projects/"
alias devp="cd ~/Work/pulsepoint/"

alias vpn='omarchy-fortivpn start --push'
alias svpn="omarchy-fortivpn stop"
alias osh="omarchy-sesh"

# UV ---
alias ui="uv init"
alias ua="uv add"
alias us="uv sync"
alias ur="uv run"

# KUBERNETES ---
export KUBECONFIG=$HOME/.kube/config/home.yaml
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

alias k="kubectl"
alias ka="k apply -f"
alias kg="k get"
alias kd="k describe"
alias kdel="k delete"
alias kgpo="k get pod"
alias kl='k logs -f'
alias kgd="k get deployments"
alias kns="kubens"
alias ke="k exec -it"
alias kcns='k config set-context --current --namespace'
alias kw-token="cat ~/.kube/cache/oidc-login/lga-dm-dev/* | jq -r '.id_token'"
alias kc='k config'
alias kctx='tv k8s-contexts'

# HELM ---
alias hrl="helm repo list"
alias hru="helm repo update"
alias hsr="helm search repo ''"
hsv() {
  helm show values "$@" | bat -l yaml
}

# INITS ---
eval "$(atuin init zsh)"

# FUNCTIONS ---
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# encodes a string and copies to clipboard
function b64e() {
  echo -n "$1" | base64 | wl-copy
}

# decodes a string and copies to clipboard
function b64d() {
  echo -n "$1" | base64 -d | wl-copy
}

# work related items ---
source "$HOME/pulsepoint.sh"
