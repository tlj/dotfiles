APT_PACKAGES=""
PACMAN_PACKAGES="stubby"
YAY_PACKAGES=""
BREW_PACKAGES=""
UBI_PACKAGES=""
BREW_CASK_PACKAGES=""
SNAP_PACKAGES=""

install_packages

if isArch; then
  echo " - Resolving dns2.tlj.no to an IP address..."
  ip=$(getent ahosts dns2.tlj.no 2>/dev/null | awk '!/:/ {print $1; exit}') || ip=""
  if [[ -z "$ip" ]]; then
    echo "ERROR: Could not resolve dns2.tlj.no. Aborting stubby configuration."
    return 1
  fi
  echo " - dns2.tlj.no -> $ip"

  echo " - Writing stubby config to /etc/stubby/stubby.yml"
  sudo mkdir -p /etc/stubby
  cat <<EOF | safe_write_root /etc/stubby/stubby.yml
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

  echo " - Enabling and starting stubby service"
  sudo systemctl disable --now systemd-resolved
  sudo systemctl enable --now stubby

  if command -v nmcli >/dev/null 2>&1; then
    echo " - Configuring NetworkManager to not manage /etc/resolv.conf"
    sudo mkdir -p /etc/NetworkManager/conf.d
    cat <<EOF | safe_write_root /etc/NetworkManager/conf.d/99-dns-none.conf
[main]
dns=none
EOF

    echo " - Restarting NetworkManager to apply the configuration"
    sudo systemctl restart NetworkManager
  fi
else
  echo "WARNING: Not using Stubby for anything other than Arch based systems, as it is not tested yet."
fi

stow_package "dns"
