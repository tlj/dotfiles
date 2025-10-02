#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Syncthing"

if isArch; then
  sudo pacman -S --noconfirm --quiet syncthing
else
  echo "Non-Arch system detected; skipping DNS setup"
fi
