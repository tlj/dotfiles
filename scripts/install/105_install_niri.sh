#!/usr/bin/env bash

install() {
  require_all_traits "arch niri" "Skipping Niri install — host is not niri enabled" || return 0

  print_header "Niri"

  sudo pacman -Syu --noconfirm --quiet niri waybar

  stow --target="$HOME" --dotfiles -v --restow niri/ waybar/
}

# No actions on source — setup.sh calls install()
