#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/print_utils.sh

print_header "Zed"

if isMac; then
  brew install --cask zed
fi

stow --target=$HOME --dotfiles -v --restow zed/
