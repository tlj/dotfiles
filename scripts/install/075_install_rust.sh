#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  echo "Installing Rust..."
  brew install -q rust
else
  sudo apt install -y rustc cargo
fi
