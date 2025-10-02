#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Tickrs install — host is not client" || return 0

  print_header "Tickrs (stock ticker)"

  if isArch; then
    sudo pacman -S --noconfirm --quiet tickrs || true
  elif isLinux; then
    cargo install -q tickrs || true
  elif isMac; then
    brew tap tarkah/tickrs || true
    brew install -q tickrs || true
  else
    echo "Non-Arch system detected; skipping Tickrs setup"
  fi
}

# No actions on source — setup.sh calls install()
