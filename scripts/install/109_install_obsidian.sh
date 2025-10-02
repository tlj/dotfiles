#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Obsidian install — host is not client" || return 0

  print_header "Obsidian"

  if isArch; then
    sudo pacman -S --noconfirm --quiet obsidian || true
  fi
}

# No actions on source — setup.sh calls install()
