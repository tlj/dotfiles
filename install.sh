#!/usr/bin/env bash

set -e 

git --version >/dev/null
if [[ $? -ne 0 ]]; then
  echo "Git is not installed. Please install git and try again."
  exit 1
fi

echo "Cloning dotfiles..." 
git clone -b master https://github.com/tlj/dotfiles.git ~/dotfiles > /dev/null

cd ~/dotfiles
source ./setup.sh


