#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Neovim Plugins"

cd nvim/dot-config/nvim
./update.sh
cd - > /dev/null
