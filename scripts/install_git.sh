#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_github_release.sh

echo "Installing git and lazygit..."
if isMac; then
  brew install -q git lazygit stow gh 
  brew install -q --cask git-credential-manager
else
  sudo apt install git stow

  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
  install_github_release jesseduffield/lazygit lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz v${LAZYGIT_VERSION}

  echo "Installing gh..."
  sudo mkdir -p -m 755 /etc/apt/keyrings 
  wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update
  sudo apt install gh -y
fi

echo "Installing gh-dash..."
gh extension install dlvhdr/gh-dash

stow --target=$HOME --restow lazygit/
