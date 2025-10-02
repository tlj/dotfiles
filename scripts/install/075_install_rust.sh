#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Golang install — host is not client" || return 0

  print_header "Rust"

  if isMac; then
    brew install -q rust || true
  elif isArch; then
    sudo pacman -S --noconfirm --quiet rust cargo || true
  elif isLinux; then
    sudo apt-get -qq install -y rustc cargo || true
  fi
}

# No actions on source — setup.sh calls install()
