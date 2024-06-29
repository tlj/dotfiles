#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_github_release.sh

if isMac; then
  brew install -q stow btop bat
else
  sudo apt update -y

  echo "Installing basics..."
  sudo apt install -y curl stow fuse libfuse2t64 bat lsd

  echo "Installing btop..."
  if [[ "$ARCH" == "arm64" ]]; then
    install_github_release aristocratos/btop btop-aarch64-linux-musl.tbz
  else
    install_github_release aristocratos/btop btop-${ARCH}-linux-musl.tbz
  fi

  ln -sfn /usr/bin/batcat ~/.local/bin/bat

  echo "Install LSD..."
  if [[ "$ARCH" == "arm64" ]]; then
    curl -sLo /tmp/lsd.deb https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_arm64.deb
  else 
    curl -sLo /tmp/lsd.deb https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
  fi

  sudo dpkg -i /tmp/lsd.deb
fi

echo "Building bat cache..."
bat cache --build > /dev/null

mkdir -p ~/.local/bin
mkdir -p ~/src

PATH=$HOME/.local/bin:$PATH

stow --target=$HOME --restow btop/ bat/ lsd/
