#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/print_utils.sh

VIU_VERION=v1.5.0
NVIM_VERSION=

print_header "Neovim"

if isMac; then
  [[ $VERBOSE -eq 1 ]] && echo "  Installing Neovim dependencies..."
  brew install -q ripgrep fd luacheck gnu-sed gsed bash silicon ninja cmake gettext curl
else
  [[ $VERBOSE -eq 1 ]] && echo "  Installing Neovim dependencies..."
  sudo apt-get install -y ripgrep fd-find luarocks ninja-build gettext cmake unzip curl build-essential
  sudo luarocks install luacheck
fi

ubi -v -i ~/.local/bin -p atanunq/viu

[[ $VERBOSE -eq 1 ]] && echo "  Cloning Neovim repository"
rm -rf /tmp/neovim-source
git clone --quiet https://github.com/neovim/neovim.git /tmp/neovim-source > /dev/null
cd /tmp/neovim-source
if [[ ! -z "$NVIM_VERSION" ]]; then
  [[ $VERBOSE -eq 1 ]] && echo "  Checking out version $NVIM_VERSION"
  git switch "$NVIM_VERSION" --detach
fi
rm -rf build
[[ $VERBOSE -eq 1 ]] && echo "  Building Neovim..."
make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local/neovim -Wno-dev" > /dev/null
[[ $VERBOSE -eq 1 ]] && echo "  Installing Neovim..."
make install > /dev/null
cd - > /dev/null

INSTALLED_NVIM_VERSION=$($HOME/.local/neovim/bin/nvim --version | head -n1 | cut -d' ' -f2 | cut -d'+' -f1)
echo "Installed Neovim ${INSTALLED_NVIM_VERSION}"

echo "Installing stylua..."
ubi -v -i ~/.local/bin -p JohnnyMorganz/stylua

echo "Installing tree-sitter-cli..."
cargo install -q tree-sitter-cli

echo "Installing PHP DAP adapter..."
install_with_git ~/src/vscode-php-debug https://github.com/xdebug/vscode-php-debug.git 
cd ~/src/vscode-php-debug
~/.local/bin/mise exec nodejs -- npm install --silent --no-progress || true
~/.local/bin/mise exec nodejs -- npm run --silent build || true
cd - > /dev/null

stow --target=$HOME --restow nvim/
