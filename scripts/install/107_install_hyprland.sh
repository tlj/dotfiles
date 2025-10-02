#!/usr/bin/env bash

install() {
  require_trait "arch" "Skipping Hyprland install — host is not arch" || return 0

  print_header "Hyprland"

  if isArch; then
    if isOmarchy; then
      echo "Installing Omarchy stuff"

      echo "Installing ACPI"
      sudo pacman -S --noconfirm --quiet --needed acpid || true
      sudo systemctl enable --now acpid || true

      sudo stow -v -t /etc etc || true

      echo "Installing dotfiles"
      stow --target="$HOME" --dotfiles -v --restow --ignore ".*\.bak.*" omarchy/ || true

      hyprctl reload || true

      if ! hyprpm list | grep -q split-monitor-workspaces; then
        echo "Installing split-monitor-workspaces plugin"
        sudo pacman -S --noconfirm --quiet meson cpio || true

        hyprpm update || true
        hyprpm add https://github.com/shezdy/hyprsplit || true
        hyprpm enable hyprsplit || true
      else
        hyprpm update || true
      fi

      hyprpm reload -n || true

      echo 'ALL ALL=(root) NOPASSWD: /etc/acpi/check-lid-on-startup.sh' | sudo tee /etc/sudoers.d/check-lid-on-startup >/dev/null && sudo chmod 0440 /etc/sudoers.d/check-lid-on-startup || true
    else
      sudo pacman -S --noconfirm --quiet hyprland waybar wofi || true
      stow --target="$HOME" --dotfiles -v --restow hypr/ waybar/ wofi/ || true
    fi
  fi
}

# No actions on source — setup.sh calls install()
