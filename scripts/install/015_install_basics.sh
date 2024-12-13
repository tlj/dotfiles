#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Basic tools and libraries"

if isMac; then
  brew install -q stow btop bat sqlite cmake fortune cowsay
else
  sudo apt-get -qq update -y -q

  echo "Installing basics..."
  sudo apt-get -qq install -y -q curl stow fuse3 bat sqlite3 cmake ca-certificates fortune cowsay
  sudo install -m 0755 -d /etc/apt/keyrings

  echo "Installing btop..."
  ubi -v -i ~/.local/bin -p aristocratos/btop

  ln -sfn /usr/bin/batcat ~/.local/bin/bat

  echo "Install LSD..."
  curl -sLo /tmp/lsd.deb https://github.com/Peltoche/lsd/releases/download/v1.1.2/lsd-musl_1.1.2_${ARCH}.deb

  sudo dpkg -i /tmp/lsd.deb
fi

echo "Building bat cache..."
bat cache --build > /dev/null

stow --target=$HOME --dotfiles -v --restow btop/ bat/ lsd/
