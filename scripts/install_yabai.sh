#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh

if isMac; then
  echo "Installing Yabai, skhd and ubersicht ..."
  brew install -q --cask ubersicht 
  brew install -q skhd
  brew install -q koekeishiya/formulae/yabai --head
  
  echo "Installing Sketchybar..."
  brew tap FelixKratz/formulae
  brew install sketchybar

  install_with_git "${HOME}/Library/Application\ Support/Übersicht/widgets/simple-bar" https://github.com/Jean-Tinland/simple-bar 

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

stow --target=$HOME --restow yabai/ simplebar/ skhd/ sketchybar/

