#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh
. scripts/lib/print_utils.sh

print_header "Tmux"

if isMac; then
  brew install -q tmux
else
  sudo apt install -y tmux
fi

install_github_release joshmedeski/sesh sesh_${PLATFORM}_${ARCH_ALT}.tar.gz

install_with_git ~/.tmux/plugins/tpm https://github.com/tmux-plugins/tpm

stow --target=$HOME --restow tmux/ sesh/ zellij/
