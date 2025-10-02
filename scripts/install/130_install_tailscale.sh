#!/usr/bin/env bash

install() {
  print_header "Tailscale VPN"

  if isLinux; then
    curl -fsSL https://tailscale.com/install.sh | sh || true
    sudo tailscale up || true
  elif isMac; then
    echo "Install the standalone version from https://pkgs.tailscale.com/stable/#macos"
  fi
}

# No actions on source — setup.sh calls install()
