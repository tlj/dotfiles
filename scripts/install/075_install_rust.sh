#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Rust"

if isMac; then
  brew install -q rust
elif isArch; then
  sudo pacman -S --noconfirm --quiet rust cargo
else
  sudo apt-get -qq install -y rustc cargo
fi
