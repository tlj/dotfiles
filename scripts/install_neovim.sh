#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh

echo "Installing Neovim..."
if isMac; then
  brew install -q ripgrep fd fzf luacheck

  brew install -q --HEAD neovim
  #brew install -q neovim
  brew install -q npm
else
  sudo apt-get install ripgrep fd-find fzf luarocks npm
  sudo luarocks install luacheck

  sudo npm install -g tree-sitter-cli

  curl -sLo /tmp/neovim.deb https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb
  sudo dpkg -i /tmp/neovim.deb
fi

echo "Installing PHP DAP adapter..."
install_with_git ~/src/vscode-php-debug https://github.com/xdebug/vscode-php-debug.git 
cd ~/src/vscode-php-debug
npm install --silent || true
npm run --silent build || true
cd - > /dev/null

stow --target=$HOME --restow nvim/
