#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

VIU_VERION=v1.5.0

. "$HOME/.asdf/asdf.sh"

echo "Installing Neovim..."
if isMac; then
  echo "Installing Neovim dependencies..."
  brew install -q ripgrep fd fzf luacheck gnu-sed gsed bash viu silicon
else
  sudo apt-get install -y ripgrep fd-find fzf luarocks
  sudo luarocks install luacheck

  npm install -g tree-sitter-cli
  mkdir -p ~/.local/bin
  echo "Installing stylua..."
  asdf plugin add stylua https://github.com/jc00ke/asdf-stylua.git
  asdf install stylua
  echo "Installing viu..."
  install_github_release atanunq/viu viu-x86_64-unknown-linux-musl
fi

echo "Installing neovim..."
asdf plugin add neovim
asdf uninstall neovim nightly 
asdf install neovim nightly
  
echo "Installing PHP DAP adapter..."
install_with_git ~/src/vscode-php-debug https://github.com/xdebug/vscode-php-debug.git 
cd ~/src/vscode-php-debug
npm install --silent --no-progress || true
npm run --silent build || true
cd - > /dev/null

stow --target=$HOME --restow nvim/
