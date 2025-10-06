APT_PACKAGES="curl stow git tmux docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin fzf neovim unzip snap gpg syncthing"
PACMAN_PACKAGES="curl stow yay sqlite3 cmake ca-certificates git git-delta tmux mise docker docker-compose docker-buildx fzf neovim unzip syncthing"
YAY_PACKAGES=""
BREW_PACKAGES="stow cmake sqlite git git-delta tmux mise orbstack fzf neovim unzip syncthing"
BREW_CASK_PACKAGES=""
UBI_PACKAGES="aristocratos/btop lsd-rs/lsd sharkdp/bat jesseduffield/lazygit joshmedeski/sesh jqlang/jq noahgorstein/jqp sxyazi/yazi jesseduffield/lazydocker"
SNAP_PACKAGES=""

# We want to install binaries into a local bin folder to avoid sudo
mkdir -p "$HOME/.local/bin"

PATH=$HOME/.local/bin:$PATH

# Install ubi bootstrap if not present
if ! command -v ubi >/dev/null 2>&1; then
  echo " - Installing ubi bootstrap..."
  curl --silent --location https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh | sudo sh
fi

if isMac && ! command -v brew > /dev/null 2>&1; then
    echo " - Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    PATH="/opt/homebrew/bin:$PATH"
fi

if command -v apt >/dev/null 2>&1; then
  if [ ! -f /etc/apt/sources.list.d/mise.list ]; then
    sudo install -dm 755 /etc/apt/keyrings
    wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | safe_write_root /etc/apt/sources.list.d/mise.list
  fi

  if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "Adding apt source for docker engine..."
    echo \ 
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo \"$UBUNTU_CODENAME\") stable" | \
      safe_write_root /etc/apt/sources.list.d/docker.list
  fi

  if [ ! -f /etc/apt/sources.list.d/syncthing.list ]; then
    curl -fsSL https://syncthing.net/release-key.txt | gpg --dearmor -o /etc/apt/trusted.gpg.d/syncthing.gpg
    echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | safe_write_root /etc/apt/sources.list.d/syncthing.list
  fi

  sudo apt-get -qq update
fi

install_packages

echo " - Activating Mise..."
eval "$(~/.local/bin/mise activate bash)"

echo " - Installing TPM..."
install_with_git ~/.tmux/plugins/tpm https://github.com/tmux-plugins/tpm

echo " - Stowing..."
stow_package "basics"

# Perform any preparation steps that should happen before stowing
echo " - Building Bat cache..."
bat cache --build > /dev/null 2>&1

