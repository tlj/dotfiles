#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Hyperland"

if isArch; then
  stow --target=$HOME --dotfiles -v --restow hypr/ waybar/
fi


