#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

if isMac; then
  brew install -q tmux
else
  sudo apt install -y tmux
fi

if [[ "$ARCH" == "aarch64" ]]; then
  install_github_release joshmedeski/sesh sesh_${PLATFORM}_arm64.tar.gz
else
  install_github_release joshmedeski/sesh sesh_${PLATFORM}_${ARCH}.tar.gz
fi

install_with_git ~/.tmux/plugins/tpm https://github.com/tmux-plugins/tpm

stow --target=$HOME --restow tmux/ sesh/
