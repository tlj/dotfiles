#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh

if isMac; then
  echo "Installing kitty..."
  brew install -q --cask kitty

  echo "Installing autojump, bat and lsd..."
  brew install -q autojump bat lsd 

  echo "Installing Nerd Fonts"
  brew tap homebrew/cask-fonts
  brew install -q --cask font-hack-nerd-font

  echo "Installing bat catppuccin theme"
  BAT_THEME_DIR=$(bat --config-dir)/themes
  if [[ ! -d "$BAT_THEME_DIR" ]]; then
    mkdir $BAT_THEME_DIR
  fi
  install_with_git ~/src/bat-catppuccin https://github.com/catppuccin/bat
  cp ~/src/bat-catppuccin/*.tmTheme $BAT_THEME_DIR
  bat cache --build > /dev/null

  echo "Installing oh-my-zsh"
  ZSH_DIR=$HOME/.oh-my-zsh
  if [[ ! -d "$ZSH_DIR" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null
  else
    git -C $ZSH_DIR pull --quiet
  fi

  echo "Installing Powerlevel10k"
  install_with_git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k https://github.com/romkatv/powerlevel10k.git 
  
  echo "Installing zsh-syntax-highlighting..."
  install_with_git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
  
  echo "Installing zsh-autosuggestions..."
  install_with_git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git

  echo "Installing fzf from git..."
  install_with_git ~/.fzf https://github.com/junegunn/fzf.git
fi

stow --target=$HOME --restow kitty/ zsh/ bat/ lsd/