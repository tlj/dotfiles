#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/print_utils.sh

print_header "Zsh"

if ! isMac; then
  sudo apt-get -qq install -y zsh
fi

echo "Install starship..."
cargo install -q starship --locked

echo "Install zoxide..."
cargo install -q zoxide --locked

echo "Installing zsh-vi-mode..."
install_with_git ~/.zsh/zsh-vi-mode https://github.com/jeffreytse/zsh-vi-mode

echo "Installing zsh-autosuggestions..."
install_with_git ~/.zsh/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions

stow --target=$HOME --dotfiles -v --restow zsh/ starship/
