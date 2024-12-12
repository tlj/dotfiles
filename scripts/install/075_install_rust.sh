#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Rust"

if isMac; then
  brew install -q rust
else
  sudo apt-get -qq install -y rustc cargo
fi
