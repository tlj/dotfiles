#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  echo "Installing golang..."
  brew install -q go
else
  sudo add-apt-repository ppa:longsleep/golang-backports
  sudo apt update -y
  sudo apt install -y golang-go
fi
