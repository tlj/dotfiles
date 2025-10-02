#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Golang install — host is not client" || return 0

  print_header "Golang"

  if isMac; then
    brew install -q go || true
  elif isArch; then
    sudo pacman -S --noconfirm --quiet go || true
  elif isLinux; then
    sudo add-apt-repository -y ppa:longsleep/golang-backports || true
    sudo apt-get -qq update -y || true
    sudo apt-get -qq install -y golang-go || true
  fi

  go install github.com/go-delve/delve/cmd/dlv@latest || true
}

# No actions on source — setup.sh calls install()
