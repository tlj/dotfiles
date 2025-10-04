#!/usr/bin/env bash

install() {
  require_all_traits "private client" "Skipping 1Password install — host is not private client" || return 0

  print_header "1Password"

  if isArch; then
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
    rm -rf ~/tmp/1password >/dev/null 2>&1
    git clone https://aur.archlinux.org/1password.git ~/tmp/1password
    pushd ~/tmp/1password >/dev/null
    makepkg -si
    popd >/dev/null

    yay -S 1password-cli
  elif isMac; then
    brew install --cask 1password-cli
  fi
}

# No actions on source — setup.sh calls install()
