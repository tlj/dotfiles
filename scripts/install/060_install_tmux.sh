#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/print_utils.sh

print_header "Tmux"

if isMac; then
  brew install -q tmux
elif isArch; then
  sudo pacman -S --noconfirm --quiet tmux
else
  sudo apt-get -qq install -y tmux
fi

ubi -v -i ~/.local/bin -p joshmedeski/sesh

install_with_git ~/.tmux/plugins/tpm https://github.com/tmux-plugins/tpm

stow --target=$HOME --dotfiles -v --restow tmux/ sesh/ zellij/
