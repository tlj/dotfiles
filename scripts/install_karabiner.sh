#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  echo "Installing karabiner elements..."
  brew install -q --cask karabiner-elements

  mkdir -p $HOME/.config/karabiner/assets/complex_modifications
  stow --target=$HOME/.config/karabiner/assets/complex_modifications --restow karabiner
fi
