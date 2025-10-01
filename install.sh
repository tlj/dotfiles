#!/usr/bin/env bash

set -e 

check_command() {
  if ! command -v $1 &> /dev/null; then
    echo "$1 is not installed. Please install $1 and try again."
    return 1
  fi
  return 0
}

check_command git || missing_deps=1
check_command bzip2 || missing_deps=1
check_command stow || missing_deps=1

if [ "$missing_deps" = 1 ]; then
  echo "Please install the missing dependencies and try again."
  exit 1
fi

REPO_LOCATION=~/dotfiles

echo "Cloning into dotfiles..." 
if cd "$REPO_LOCATION" &> /dev/null; then
  git pull > /dev/null
else
  git clone -b master https://github.com/tlj/dotfiles.git "$REPO_LOCATION" > /dev/null
fi

cd "$REPO_LOCATION"
source ./setup.sh


