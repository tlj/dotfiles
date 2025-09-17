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
elif isArch; then
  echo "Not installing anything for arch..."
  pacman -S --noconfirm --quiet git-delta
else
  echo "Installing git and gh..."
  sudo mkdir -p -m 755 /etc/apt/keyrings 
  wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt-get -qq update -y
  sudo apt-get -qq install -y git gh 
fi

ubi -v -i ~/.local/bin -p lintingzhen/commitizen-go
ubi -v -i ~/.local/bin -p jesseduffield/lazygit
ubi -v -i ~/.local/bin -p mislav/hub

echo "Installing gh cli extensions..."
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "  * GITHUB_TOKEN is not set. Set it and rerun if github extensions are needed."
else
  gh extension install dlvhdr/gh-dash
  gh extension install meiji163/gh-notify
fi

stow --target=$HOME --dotfiles -v --restow lazygit/

