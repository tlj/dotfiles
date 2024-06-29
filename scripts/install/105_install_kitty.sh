#!/usr/bin/env bash

echo "Installing kitty..."
curl -sL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin &> /dev/null

if ! isMac; then
  cd ~/.local/stow
  stow -v kitty.app
  cd -
fi

stow --target=$HOME --restow kitty/ 

