#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "DNS (stubby + NetworkManager)"

if isArch; then
  echo "Updating package database and installing stubby..."
  sudo pacman -S --noconfirm --quiet stubby

  echo "Resolving dns2.tlj.no to an IP address..."
  ip=$(getent ahosts dns2.tlj.no 2>/dev/null | awk '!/:/ {print $1; exit}')
  if [[ -z "$ip" ]]; then
    echo "ERROR: Could not resolve dns2.tlj.no. Aborting stubby configuration."
    exit 1
  fi
  echo "dns2.tlj.no -> $ip"

  echo "Writing stubby config to /etc/stubby/stubby.yml"
  sudo mkdir -p /etc/stubby
  sudo tee /etc/stubby/stubby.yml > /dev/null <<EOF
resolution_type: GETDNS_RESOLUTION_STUB
round_robin_upstreams: 1
# Use TLS for upstream queries
dns_transport_list:
  - GETDNS_TRANSPORT_TLS
idle_timeout: 10000
listen_addresses:
  - 127.0.0.1@53
upstream_recursive_servers:
  - address_data: ${ip}
    tls_auth_name: "dns2.tlj.no"
    tls_port: 853
EOF

  echo "Enabling and starting stubby service"
  sudo systemctl enable --now stubby

  if command -v nmcli >/dev/null 2>&1; then
    echo "Configuring NetworkManager to not manage /etc/resolv.conf"
    sudo mkdir -p /etc/NetworkManager/conf.d
    sudo tee /etc/NetworkManager/conf.d/99-dns-none.conf > /dev/null <<EOF
[main]
dns=none
EOF

    echo "Replacing /etc/resolv.conf to point to local resolver (127.0.0.1)"
    sudo rm -f /etc/resolv.conf
    echo -e "# /etc/resolv.conf - managed by dotfiles install script\nnameserver 127.0.0.1" | sudo tee /etc/resolv.conf > /dev/null

    echo "Restarting NetworkManager to apply the configuration"
    sudo systemctl restart NetworkManager
  else
    echo "NetworkManager not detected; leaving /etc/resolv.conf unchanged"
  fi
else
  echo "Non-Arch system detected; skipping DNS setup"
fi
