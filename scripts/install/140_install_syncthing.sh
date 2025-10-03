#!/usr/bin/env bash

install() {
  require_all_traits "private client" "Skipping Tailscale install — host is not private client" || return 0

  print_header "Syncthing"

  if isArch; then
    sudo pacman -S --noconfirm --quiet syncthing || true
  else
    echo "Non-Arch system detected; skipping Syncthing setup"
  fi
}

# No actions on source — setup.sh calls install()
