#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping 1Password install — host is not client" || return 0

  print_header "1Password"

  if isArch; then
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import || true
    rm -rf ~/tmp/1password >/dev/null 2>&1 || true
    git clone https://aur.archlinux.org/1password.git ~/tmp/1password || true
    pushd ~/tmp/1password >/dev/null || true
    makepkg -si || true
    popd >/dev/null || true

    yay -S 1password-cli || true
  elif isMac; then
    brew install --cask 1password-cli || true
  fi
}

# No actions on source — setup.sh calls install()
