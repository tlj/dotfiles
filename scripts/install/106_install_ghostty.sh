#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Ghostty"

if isMac; then
  brew install -q --cask ghostty
fi

stow --target=$HOME --dotfiles -v --restow ghostty/ 

