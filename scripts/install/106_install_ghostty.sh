#!/usr/bin/env bash

. scripts/lib/print_utils.sh

print_header "Ghostty"

stow --target=$HOME --dotfiles -v --restow ghostty/ 

