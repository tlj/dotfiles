#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_github_release.sh

echo "Installing git and lazygit..."
if isMac; then
  brew install -q git lazygit stow gh 
  brew install -q --cask git-credential-manager
  echo "Installing gh-dash..."
  gh extension install dlvhdr/gh-dash
else
  sudo apt install git stow

  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
  install_github_release jesseduffield/lazygit lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz v${LAZYGIT_VERSION}
fi

stow --target=$HOME --restow lazygit/
