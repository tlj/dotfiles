#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Hyprland"

if isArch; then
  if isOmarchy; then
    echo "Installing Omarchy stuff"

    echo "Installing ACPI"
    sudo pacman -S --noconfirm --quiet --needed acpid
    sudo systemctl enable --now acpid

    sudo stow -v -t /etc etc

    echo "Installing dotfiles"
    stow --target=$HOME --dotfiles -v --restow --ignore ".*\.bak.*" omarchy/

    hyprctl reload

    if ! hyprpm list | grep -q split-monitor-workspaces; then
      echo "Installing split-monitor-workspaces plugin"
      sudo pacman -S --noconfirm --quiet meson cpio
      
      hyprpm update
      hyprpm add https://github.com/Duckonaut/split-monitor-workspaces
      hyprpm enable split-monitor-workspaces
    else
      hyprpm update
    fi

    hyprpm reload -n
  else
    sudo pacman -S --noconfirm --quiet hyprland waybar wofi
    stow --target=$HOME --dotfiles -v --restow hypr/ waybar/ wofi/
  fi

fi


