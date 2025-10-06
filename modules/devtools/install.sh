APT_PACKAGES="ripgrep fd-find luarocks ninja-build gettext build-essential lua5.3 lua-language-server"
PACMAN_PACKAGES="ripgrep fd luarocks ninja gettext lua lua-language-server shfmt"
YAY_PACKAGES=""
BREW_PACKAGES="ripgrep fd luacheck gnu-sed gsed bash silicon ninja gettext mdformat lua lua-language-server shfmt"
BREW_CASK_PACKAGES=""
UBI_PACKAGES="atanunq/viu JohnnyMorganz/stylua sst/opencode sgaunet/pplx"
SNAP_PACKAGES=""

VIU_VERSION="v1.5.0"
NVIM_VERSION=""

install_packages

luarocks install --local luacheck

## Installing Neovim
echo " - Cloning Neovim repository"

rm -rf /tmp/neovim-source
git clone --quiet https://github.com/neovim/neovim.git /tmp/neovim-source >/dev/null

pushd /tmp/neovim-source >/dev/null || return 0
if [[ -n "$NVIM_VERSION" ]]; then
  [[ ${VERBOSE:-0} -eq 1 ]] && echo "  Checking out version $NVIM_VERSION"
  git switch "$NVIM_VERSION" --detach
fi

rm -rf build

echo " - Building Neovim..."
make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local/neovim -Wno-dev" >/dev/null 2>&1

echo " - Installing Neovim..."
make install >/dev/null 2>&1
popd >/dev/null

if [[ -x "$HOME/.local/neovim/bin/nvim" ]]; then
  INSTALLED_NVIM_VERSION=$($HOME/.local/neovim/bin/nvim --version | head -n1 | cut -d' ' -f2 | cut -d'+' -f1)
  echo "Installed Neovim ${INSTALLED_NVIM_VERSION}"
fi

echo " - Installing tree-sitter-cli..."
cargo install -q tree-sitter-cli

echo " - Installing LSPs..."
npm i -g vscode-langservers-extracted intelephense @github/copilot-language-server

echo " - Installing PHP DAP adapter..."
rm -rf ~/src/vscode-php-debug/
install_with_git ~/src/vscode-php-debug https://github.com/xdebug/vscode-php-debug.git
pushd ~/src/vscode-php-debug >/dev/null || return 0
"$HOME/.local/bin/mise" exec nodejs -- npm install --silent --no-progress
"$HOME/.local/bin/mise" exec nodejs -- npm run --silent build
popd >/dev/null

stow_package "devtools"
