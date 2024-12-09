#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

VIU_VERION=v1.5.0
NVIM_VERSION=v0.10.2

echo "Installing Neovim..."
if isMac; then
  echo "Installing Neovim dependencies..."
  brew install -q ripgrep fd luacheck gnu-sed gsed bash viu silicon ninja cmake gettext curl
else
  sudo apt-get install -y ripgrep fd-find luarocks ninja-build gettext cmake unzip curl build-essential
  sudo luarocks install luacheck

  echo "Installing viu..."
  install_github_release atanunq/viu viu-${ARCH}-unknown-linux-musl
fi

echo "Installing Neovim from source..."
rm -rf /tmp/neovim-source
git clone --quiet https://github.com/neovim/neovim.git /tmp/neovim-source > /dev/null
cd /tmp/neovim-source
if [[ ! -z "$NVIM_VERSION" ]]; then
  echo "  Checking out version $NVIM_VERSION"
  git switch "$NVIM_VERSION" --detach
fi
rm -rf build
echo "  Building Neovim..."
make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local/neovim -Wno-dev" > /dev/null
echo "  Installing Neovim..."
make install > /dev/null
cd -

echo "Installing stylua..."
install_github_release JohnnyMorganz/StyLua stylua-linux-${ARCH_ALT}.zip v0.20.0

echo "Installing tree-sitter-cli..."
cargo install tree-sitter-cli

echo "Installing PHP DAP adapter..."
install_with_git ~/src/vscode-php-debug https://github.com/xdebug/vscode-php-debug.git 
cd ~/src/vscode-php-debug
~/.local/bin/mise exec nodejs -- npm install --silent --no-progress || true
~/.local/bin/mise exec nodejs -- npm run --silent build || true
cd - > /dev/null

stow --target=$HOME --restow nvim/
