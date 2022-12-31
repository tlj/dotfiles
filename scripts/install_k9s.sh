#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  echo "Installing k9s..."
  brew install -q k9s
fi

stow --target=$HOME --restow k9s/
