#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "1Password"

if isArch; then
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
  rm -rf ~/tmp/1password > /dev/null
  git clone https://aur.archlinux.org/1password.git ~/tmp/1password
  cd ~/tmp/1password
  makepkg -si
  cd -
fi


