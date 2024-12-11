#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Git and LazyGit"

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
ubi -v -i ~/.local/bin -p lintingzhen/commitizen-go

echo "Installing lazygit..."
ubi -v -i ~/.local/bin -p jesseduffield/lazygit

echo "Installing gh-dash..."
# check if gh-dash is already installed
export GH_TOKEN=foobar
if gh extension list | grep -q "gh dash"; then
  echo "gh-dash is already installed. Skipping..."
else
  gh extension install dlvhdr/gh-dash
fi

stow --target=$HOME --restow lazygit/

