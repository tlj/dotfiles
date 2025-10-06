APT_PACKAGES=""
PACMAN_PACKAGES=""
YAY_PACKAGES=""
BREW_PACKAGES=""
UBI_PACKAGES=""
BREW_CASK_PACKAGES=""
SNAP_PACKAGES=""

curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale set --operator=$(whoami)
sudo tailscale up

stow_package "ssh"
