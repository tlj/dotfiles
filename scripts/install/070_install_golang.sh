#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Golang install — host is not client" || return 0

  print_header "Golang"

  if isMac; then
    brew install -q go
  elif isArch; then
    sudo pacman -S --noconfirm --quiet go
  elif isLinux; then
    sudo add-apt-repository -y ppa:longsleep/golang-backports
    sudo apt-get -qq update -y
    sudo apt-get -qq install -y golang-go
  fi

  go install github.com/go-delve/delve/cmd/dlv@latest
}

# No actions on source — setup.sh calls install()
