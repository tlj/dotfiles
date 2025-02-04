#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Atuin"

if isMac; then
  brew install -q atuin
else 
  cargo install atuin
fi

stow --target=$HOME --adopt --dotfiles -v --restow atuin/
