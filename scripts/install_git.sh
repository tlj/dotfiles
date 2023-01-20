#!/usr/bin/env bash

. scripts/lib/detect_os.sh

echo "Installing git and lazygit..."
if isMac; then
  brew install -q git lazygit stow
else
  sudo apt install git stow

  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
fi

stow --target=$HOME --restow lazygit/
