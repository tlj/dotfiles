#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh

echo "Installing tmux, zoxide and tmux package manager..." 
if isMac; then
  brew install -q tmux zoxide
  install_with_git ~/.tmux/plugins/tpm https://github.com/tmux-plugins/tpm
else
  sudo apt install tmux zoxide
fi

stow --target=$HOME --restow tmux/
