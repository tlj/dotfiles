#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/print_utils.sh

print_header "Opencode"

echo "Installing OpenCode..."
ubi -v -i ~/.local/bin -p sst/opencode

stow --target=$HOME --dotfiles -v --restow opencode/
