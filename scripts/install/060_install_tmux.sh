#!/usr/bin/env bash

install() {
  print_header "Tmux"

  if isMac; then
    brew install -q tmux
  elif isArch; then
    sudo pacman -S --noconfirm --quiet tmux
  elif isLinux; then
    sudo apt-get -qq install -y tmux
  fi

  ubi -v -i "$HOME/.local/bin" -p joshmedeski/sesh

  install_with_git ~/.tmux/plugins/tpm https://github.com/tmux-plugins/tpm

  stow --target="$HOME" --dotfiles -v --restow tmux/ sesh/ zellij/
}

# No actions on source — setup.sh calls install()
