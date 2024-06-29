#!/usr/bin/env bash

set -e 

OS=$(uname)
if [[ "$OS" == "Linux" ]]; then
  sudo apt install -y git
fi

echo "Cloning dotfiles..." 
git clone -b master https://github.com/tlj/dotfiles.git ~/dotfiles > /dev/null

cd dotfiles
source ./setup.sh
