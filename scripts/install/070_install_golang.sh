#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Golang"

if isMac; then
  brew install -q go
else
  sudo add-apt-repository ppa:longsleep/golang-backports
  sudo apt update -y
  sudo apt install -y golang-go
fi
