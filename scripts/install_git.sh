#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  brew install -q git lazygit
else
  apt install git lazygit
fi

stow --target=$HOME --restow lazygit/
