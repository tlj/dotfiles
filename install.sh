#!/usr/bin/env bash

set -e 

git --version >/dev/null
if [[ $? -ne 0 ]]; then
  echo "Git is not installed. Please install git and try again."
  exit 1
fi

REPO_LOCATION=~/dotfiles

echo "Cloning into dotfiles..." 
if cd "$REPO_LOCATION"; then
  git pull > /dev/null
else
  git clone -b master https://github.com/tlj/dotfiles.git "$REPO_LOCATION" > /dev/null
fi

cd "$REPO_LOCATION"
source ./setup.sh


