#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

echo "Installing tmux, zoxide and tmux package manager..." 
if isMac; then
  brew install -q tmux zoxide joshmedeski/sesh/sesh
else
  install_github_release nelsonenzo/tmux-appimage tmux.appimage
  mv -v ~/.local/bin/tmux-appimage ~/.local/bin/tmux
fi

install_with_git ~/.tmux/plugins/tpm https://github.com/tmux-plugins/tpm

stow --target=$HOME --restow tmux/ sesh/
