#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Zsh install — host is not client" || return 0

  print_header "Zsh"

  if isArch; then
    sudo pacman -S --noconfirm --quiet zsh
  elif ! isMac; then
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

  chsh -s $(which zsh)

  stow --target="$HOME" --dotfiles -v --restow zsh/ starship/
}

# No actions on source — setup.sh calls install()
