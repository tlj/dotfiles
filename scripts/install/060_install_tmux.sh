#!/usr/bin/env bash

install() {
  print_header "Tmux"

  if isMac; then
    brew install -q tmux || true
  elif isArch; then
    sudo pacman -S --noconfirm --quiet tmux || true
  elif isLinux; then
    sudo apt-get -qq install -y tmux || true
  fi

  ubi -v -i "$HOME/.local/bin" -p joshmedeski/sesh || true

  install_with_git ~/.tmux/plugins/tpm https://github.com/tmux-plugins/tpm || true

  stow --target="$HOME" --dotfiles -v --restow tmux/ sesh/ zellij/ || true
}

# No actions on source — setup.sh calls install()
