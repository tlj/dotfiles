#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

VIU_VERION=v1.5.0

echo "Installing Neovim..."
if isMac; then
  echo "Installing Neovim dependencies..."
  brew install -q ripgrep fd luacheck gnu-sed gsed bash viu silicon

  echo "Installing Neovim from github..."
  install_github_release neovim/neovim nvim-macos-arm64.tar.gz stable

  echo "Installing Stylua..."
  install_github_release JohnnyMorganz/StyLua stylua-macos-aarch64.zip v0.20.0

else
  sudo apt-get install -y ripgrep fd-find luarocks
  sudo luarocks install luacheck

  echo "Installing viu..."
  install_github_release atanunq/viu viu-${ARCH}-unknown-linux-musl

  if [ "$ARCH" = "aarch64" ]; then
    echo "Installing Neovim from alternative github..."
    install_github_release matsuu/neovim-aarch64-appimage nvim-v0.10.0-${ARCH}.appimage latest
    ln -sfn ~/.local/bin/nvim-v0.10.0-${ARCH}.appimage ~/.local/bin/nvim
  else
    echo "Installing Neovim from github..."
    install_github_release neovim/neovim nvim-linux64.zip stable
  fi

  echo "Installing stylua..."
  install_github_release JohnnyMorganz/StyLua stylua-linux-${ARCH}.zip v0.20.0
fi

echo "Installing tree-sitter-cli..."
cargo install tree-sitter-cli

echo "Installing PHP DAP adapter..."
install_with_git ~/src/vscode-php-debug https://github.com/xdebug/vscode-php-debug.git 
cd ~/src/vscode-php-debug
~/.local/bin/mise exec nodejs -- npm install --silent --no-progress || true
~/.local/bin/mise exec nodejs -- npm run --silent build || true
cd - > /dev/null

stow --target=$HOME --restow nvim/
