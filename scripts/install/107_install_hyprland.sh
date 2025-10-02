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
      hyprpm add https://github.com/shezdy/hyprsplit
      hyprpm enable hyprsplit
    else
      hyprpm update
    fi

    hyprpm reload -n

    echo 'ALL ALL=(root) NOPASSWD: /etc/acpi/check-lid-on-startup.sh' | sudo tee /etc/sudoers.d/check-lid-on-startup > /dev/null && sudo chmod 0440 /etc/sudoers.d/check-lid-on-startup
  else
    sudo pacman -S --noconfirm --quiet hyprland waybar wofi
    stow --target=$HOME --dotfiles -v --restow hypr/ waybar/ wofi/
  fi

fi


