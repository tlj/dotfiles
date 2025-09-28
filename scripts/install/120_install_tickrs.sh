#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Tickrs (stock ticker)"

if isArch; then
  sudo pacman -S --noconfirm --quiet tickrs
elif isLinux; then
  cargo install -q tickrs
elif isMac; then
  brew tap tarkah/tickrs
  brew install -q tickrs
else
  echo "Non-Arch system detected; skipping DNS setup"
fi
