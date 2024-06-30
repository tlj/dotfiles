#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_github_release.sh

if isMac; then
  brew install -q stow btop bat sqlite
else
  sudo apt update -y

  echo "Installing basics..."
  sudo apt install -y curl stow fuse libfuse2t64 bat sqlite3 cmake

  echo "Installing btop..."
  install_github_release aristocratos/btop btop-${ARCH}-linux-musl.tbz

  ln -sfn /usr/bin/batcat ~/.local/bin/bat

  echo "Install LSD..."
  if [[ "$ARCH" == "aarch64" ]]; then
    curl -sLo /tmp/lsd.deb https://github.com/Peltoche/lsd/releases/download/v1.1.2/lsd-musl_1.1.2_arm64.deb
  else
    curl -sLo /tmp/lsd.deb https://github.com/Peltoche/lsd/releases/download/v1.1.2/lsd-musl_1.1.2_${ARCH}.deb
  fi

  sudo dpkg -i /tmp/lsd.deb
fi

echo "Building bat cache..."
bat cache --build > /dev/null

stow --target=$HOME --restow btop/ bat/ lsd/
