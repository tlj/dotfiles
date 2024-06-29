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
  install_github_release aristocratos/btop btop-${ARCH}-linux-musl.tbz

  ln -sfn /usr/bin/batcat ~/.local/bin/bat

  echo "Install LSD..."
  curl -sLo /tmp/lsd.deb https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_${ARCH}.deb

  sudo dpkg -i /tmp/lsd.deb
fi

echo "Building bat cache..."
bat cache --build > /dev/null

mkdir -p ~/.local/bin
mkdir -p ~/src

PATH=$HOME/.local/bin:$PATH

stow --target=$HOME --restow btop/ bat/ lsd/
