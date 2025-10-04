#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Golang install — host is not client" || return 0

  print_header "Rust"

  if isMac; then
    brew install -q rust
  elif isArch; then
    sudo pacman -S --noconfirm --quiet rust cargo
  elif isLinux; then
    sudo apt-get -qq install -y rustc cargo
  fi
}

# No actions on source — setup.sh calls install()
