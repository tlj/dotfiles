#!/bin/bash

systemName=$(uname -s)

if [[ $systemName == "Darwin" ]]; then
  echo "Detected MacOS system, installing dependencies with Homebrew."
  if [[ `which brew` == "" ]]; then
    echo "Unable to find brew command. See https://brew.sh for install instructions."
    exit 1
  fi

  echo "Installing ripgrep, fd, neovim, git, lazygit, composer, skhd"
  brew install --quiet ripgrep fd neovim git lazygit composer skhd

  echo "Installing Kitty terminal and Ubersicht"
  brew install --quiet --cask kitty ubersicht > /dev/null

  echo "Installing simple-bar for Ubersicht"
  if [ ! -d "${HOME}/Library/Application Support/Übersicht/widgets/simple-bar" ]; then 
    git clone https://github.com/Jean-Tinland/simple-bar ${HOME}/Library/Application\ Support/Übersicht/widgets/simple-bar > /dev/null
  else
    git -C ${HOME}/Library/Application\ Support/Übersicht/widgets/simple-bar pull > /dev/null
  fi

  echo "Installing yabai"
  brew install --quiet koekeishiya/formulae/yabai --head

  echo "Installing Monaco Nerd Fonts"
  curl --silent -o "~/Library/Fonts/Monaco Nerd Font Complete Mono.ttf" https://github.com/Karmenzind/monaco-nerd-fonts/raw/master/fonts/Monaco%20Nerd%20Font%20Complete%20Mono.ttf

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
  sudo apt install ripgrep fd-find neovim
fi

echo "Installing dotfiles"
stow --target=$HOME --restow kitty/ lazygit/ nvim/ skhd/ yabai/ zsh/ simplebar/



