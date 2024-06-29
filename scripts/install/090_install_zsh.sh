#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

if isMac; then
  echo "Installing autojump, btop and lsd..."
  brew install -q starship 
else
  echo "Install zsh.."
  sudo apt install -y zsh
  cargo install starship --locked
fi

echo "Installing zsh-vi-mode..."
install_with_git ~/.zsh/zsh-vi-mode https://github.com/jeffreytse/zsh-vi-mode

echo "Installing zsh-autosuggestions..."
install_with_git ~/.zsh/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions

stow --target=$HOME --restow zsh/ starship/
