#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Ghostty install — host is not client" || return 0

  print_header "Ghostty"

  if isMac; then
    brew install -q --cask ghostty || true
  elif isArch; then
    sudo pacman -S --noconfirm --quiet ghostty || true
  fi

  stow --target="$HOME" --dotfiles -v --restow ghostty/ || true
}

# No actions on source — setup.sh calls install()
