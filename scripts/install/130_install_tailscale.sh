#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Tailscale VPN"

if isLinux; then
  curl -fsSL https://tailscale.com/install.sh | sh
  sudo tailscale up
elif isMac; then
  echo "Install the standalone version from https://pkgs.tailscale.com/stable/#macos"
fi
