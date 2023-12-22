#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

if isMac; then
  echo "Installing kitty..."
  brew install -q --cask kitty
  curl -sL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin &> /dev/null

  echo "Installing autojump, bat, btop and lsd..."
  brew install -q autojump bat lsd btop jq

  echo "Installing Nerd Fonts"
  brew tap homebrew/cask-fonts
  brew install -q --cask font-hack-nerd-font font-fira-code-nerd-font font-symbols-only-nerd-font font-jetbrains-mono

  echo "Installing commitizen-go"
  brew tap lintingzhen/tap
  brew install commitizen-go
  commitizen-go install
else
  echo "Install zsh.."
  sudo apt install zsh

  echo "Install LSD..."
  curl -sLo /tmp/lsd.deb https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
  sudo dpkg -i /tmp/lsd.deb

  echo "Install bat, delta and autojump..."
  sudo apt install autojump bat git-delta
  mkdir -p ~/.local/bin
  if [[ ! -f ~/.local/bin/bat ]]; then
    ln -s /usr/bin/batcat ~/.local/bin/bat
  fi

  echo "Installing btop..."
  install_github_release aristocratos/btop btop-x86_64-linux-musl.tbz
fi

echo "Installing oh-my-zsh"
ZSH_DIR=$HOME/.oh-my-zsh
if [[ ! -d "$ZSH_DIR" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
else
  git -C $ZSH_DIR pull --quiet
fi

#echo "Installing bat catppuccin theme"
#BAT_THEME_DIR=$(bat --config-dir)/themes
#if [[ ! -d "$BAT_THEME_DIR" ]]; then
#  mkdir -p $BAT_THEME_DIR
#fi
#install_with_git ~/src/bat-catppuccin https://github.com/catppuccin/bat
#cp ~/src/bat-catppuccin/*.tmTheme $BAT_THEME_DIR
bat cache --build > /dev/null

echo "Installing Powerlevel10k"
install_with_git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k https://github.com/romkatv/powerlevel10k.git 

echo "Installing zsh-syntax-highlighting..."
install_with_git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git

echo "Installing zsh-autosuggestions..."
install_with_git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git

echo "Installing fzf from git..."
install_with_git ~/.fzf https://github.com/junegunn/fzf.git

echo "Installing better vim mode for zsh..."
install_with_git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode https://github.com/jeffreytse/zsh-vi-mode.git

stow --target=$HOME --restow kitty/ btop/ zsh/ bat/ lsd/
