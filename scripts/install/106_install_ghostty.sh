#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Ghostty install — host is not client" || return 0

  print_header "Ghostty"

  if isMac; then
    brew install -q --cask ghostty
  elif isArch; then
    sudo pacman -S --noconfirm --quiet ghostty
  fi

  stow --target="$HOME" --dotfiles -v --restow ghostty/
}

# No actions on source — setup.sh calls install()
