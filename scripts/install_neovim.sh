#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh

echo "Installing Neovim..."
if isMac; then
  brew install -q neovim ripgrep fd fzf luacheck
else
  apt-get install neovim ripgred fd-find fzf luacheck
fi

echo "Installing PHP DAP adapter..."
install_with_git ~/src/vscode-php-debug https://github.com/xdebug/vscode-php-debug.git 
cd ~/src/vscode-php-debug
npm install --silent && npm run --silent build
cd - > /dev/null

stow --target=$HOME --restow nvim/
