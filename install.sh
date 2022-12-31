#!/bin/bash

systemName=$(uname -s)

install_with_git() {
  REPO=$2
  DIR=$1
  if [[ ! -d "$DIR" ]]; then
    git clone --quiet --depth=1 $REPO $DIR
  else
    git -C $DIR pull --quiet
  fi
}

if [[ $systemName == "Darwin" ]]; then
  echo "Detected MacOS system, installing dependencies with Homebrew."
  if [[ `which brew` == "" ]]; then
    echo "Unable to find brew command. See https://brew.sh for install instructions."
    exit 1
  fi

  echo "Installing ripgrep, fd, neovim, git, lazygit, composer, skhd, fzf"
  brew install -q --quiet ripgrep fd neovim git lazygit composer skhd fzf autojump

  echo "Installing Kitty terminal and Ubersicht"
  brew install -q --quiet --cask kitty ubersicht > /dev/null

  echo "Installing simple-bar for Ubersicht"
  if [ ! -d "${HOME}/Library/Application Support/Übersicht/widgets/simple-bar" ]; then 
    git clone --quiet https://github.com/Jean-Tinland/simple-bar ${HOME}/Library/Application\ Support/Übersicht/widgets/simple-bar > /dev/null
  else
    git -C ${HOME}/Library/Application\ Support/Übersicht/widgets/simple-bar pull > /dev/null
  fi

  echo "Installing yabai"
  brew install -q --quiet koekeishiya/formulae/yabai --head

  echo "Installing Nerd Fonts"
  brew tap homebrew/cask-fonts
  brew install -q --cask font-hack-nerd-font

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

  codesign -v $(which yabai)
  if [ $? -ne 0 ]; then
    certinstalled=$(security find-certificate -c "yabai-cert")
    if [[ "$certinstalled" == "" ]]; then
      cat <<EOF

$(which yabai) is not signed, and there is no self signed certificate.

Yabai needs to be signed to avoid having the Accessability popup every couple of seconds. Follow these instructions:

First, open Keychain Access.app. In its menu, navigate to Keychain Access, then Certificate Assistance, then click Create a Certificate.... This will open the Certificate Assistant. Choose these options:

Name: yabai-cert
Identity Type: Self-Signed Root
Certificate Type: Code Signing
Click Create, then Continue to create the certificate.

EOF
      read -n 1 -p "When you've created the certificate, please hit enter."
    else
      echo "Yabai is not signed, but we have a cert."
    fi
    echo "Signing $(which yabai) with 'yabai-cert'"
    codesign -fs 'yabai-cert' $(which yabai)
  fi
fi

if [[ $systemName == "Linux" ]]; then
  echo "Installing ripgrep, fd-find and neovim"
  sudo apt install ripgrep fd-find neovim fzf
fi

echo "Installing PHP DAP adapter..."
if [[ ! -d ~/src/vscode-php-debug ]]; then
  git clone --quiet https://github.com/xdebug/vscode-php-debug.git ~/src/vscode-php-debug
  cd ~/src/vscode-php-debug
else
  cd ~/src/vscode-php-debug
  git pull --quiet
fi
npm install --silent && npm run --silent build
cd - > /dev/null

echo "Installing dotfiles"
stow --target=$HOME --restow kitty/ lazygit/ nvim/ skhd/ yabai/ zsh/ simplebar/ k9s/


