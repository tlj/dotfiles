#!/usr/bin/env bash

install() {
  require_trait "private" "Skipping Tailscale install — host is not private" || return 0

  print_header "Tailscale VPN"

  if isLinux; then
    curl -fsSL https://tailscale.com/install.sh | sh
    sudo tailscale up
  elif isMac; then
    echo "Install the standalone version from https://pkgs.tailscale.com/stable/#macos"
  fi
}

# No actions on source — setup.sh calls install()
