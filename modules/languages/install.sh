APT_PACKAGES="golang"
PACMAN_PACKAGES="go"
YAY_PACKAGES=""
BREW_PACKAGES="go"
UBI_PACKAGES=""
BREW_CASK_PACKAGES=""
SNAP_PACKAGES=""

install_packages

echo " - Installing Delve for Go..."
go install github.com/go-delve/delve/cmd/dlv@latest

PATH=$HOME/.cargo/bin:$PATH

if ! command -v rustup >/dev/null 2>&1; then
  echo " - Installing Rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -q -y
fi

echo " - Rustup update..."
rustup default stable
rustup update

echo " - Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
. "$HOME/.config/nvm/nvm.sh"

nvm install 22

stow_package "languages"
