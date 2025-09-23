#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Hyprland"

if isArch; then
  if isOmarchy; then
    echo "Omarchy found. Not overwriting any config yet."
  else
    sudo pacman -S --noconfirm --quiet hyprland waybar wofi
    stow --target=$HOME --dotfiles -v --restow hypr/ waybar/ wofi/
  fi
fi


