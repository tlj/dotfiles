#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

echo "Installing git and lazygit..."
if isMac; then
  brew install -q git gh 
  brew install -q --cask git-credential-manager

  echo "Installing commitizen-go"
  brew tap lintingzhen/tap
  brew install -q commitizen-go
  commitizen-go install
else
  echo "Installing git and gh..."
  sudo mkdir -p -m 755 /etc/apt/keyrings 
  wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update -y
  sudo apt install -y git gh 
fi

echo "Installing commitizen-go..."
if [[ "$ARCH" == "aarch64" ]]; then
  install_github_release lintingzhen/commitizen-go commitizen-go_1.0.3_${PLATFORM}_arm64.tar.gz v1.0.3
else
  install_github_release lintingzhen/commitizen-go commitizen-go_1.0.3_${PLATFORM}_${ARCH}.tar.gz v1.0.3
fi

echo "Installing lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
if [[ "$ARCH" == "aarch64" ]]; then
  install_github_release jesseduffield/lazygit lazygit_${LAZYGIT_VERSION}_${PLATFORM}_arm64.tar.gz v${LAZYGIT_VERSION}
else
  install_github_release jesseduffield/lazygit lazygit_${LAZYGIT_VERSION}_${PLATFORM}_${ARCH}.tar.gz v${LAZYGIT_VERSION}
fi

echo "Installing gh-dash..."
# check if gh-dash is already installed
export GH_TOKEN=foobar
if gh extension list | grep -q gh-dash; then
  echo "gh-dash is already installed. Skipping..."
else
  install_with_git ~/.local/share/gh-dash https://github.com/dlvhdr/gh-dash.git
  cd ~/.local/share/gh-dash
  gh extension install .
  cd -
  rm -rf /tmp/gh-dash
fi

stow --target=$HOME --restow lazygit/

