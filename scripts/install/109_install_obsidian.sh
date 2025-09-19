#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Obsidian"

if isArch; then
  sudo pacman -S --noconfirm --quiet obsidian

  # ubi -v -i ~/.local/bin -p syncthing/syncthing
fi


