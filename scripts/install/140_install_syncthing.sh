#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Syncthing install — host is not internal" || return 0

  print_header "Syncthing"

  if isArch; then
    sudo pacman -S --noconfirm --quiet syncthing || true
  else
    echo "Non-Arch system detected; skipping Syncthing setup"
  fi
}

# No actions on source — setup.sh calls install()
