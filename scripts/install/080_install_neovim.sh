#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

VIU_VERION=v1.5.0
INSTALL_NEOVIM=1

echo "Installing Neovim..."
if isMac; then
  echo "Installing Neovim dependencies..."
  brew install -q ripgrep fd fzf luacheck gnu-sed gsed bash viu silicon
else
  sudo apt-get install -y ripgrep fd-find fzf luarocks
  sudo luarocks install luacheck

  npm install -g tree-sitter-cli

  echo "Installing viu..."
  install_github_release atanunq/viu viu-x86_64-unknown-linux-musl

  if [ "$ARCH" = "aarch64" ]; then
    echo "Installing Neovim from apt..."
    apt install -qy neovim
    INSTALL_NEOVIM=0
  fi
fi

if [ "$INSTALL_NEOVIM" = "1" ]; then
  echo "Installing neovim..."
  mise install -qy neovim
fi
  
echo "Installing PHP DAP adapter..."
install_with_git ~/src/vscode-php-debug https://github.com/xdebug/vscode-php-debug.git 
cd ~/src/vscode-php-debug
npm install --silent --no-progress || true
npm run --silent build || true
cd - > /dev/null

stow --target=$HOME --restow nvim/
