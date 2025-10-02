#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Neovim install — host is not client" || return 0

  local VIU_VERSION="v1.5.0"
  local NVIM_VERSION=""

  print_header "Neovim"

  if isMac; then
    [[ ${VERBOSE:-0} -eq 1 ]] && echo "  Installing Neovim dependencies..."
    brew install -q ripgrep fd luacheck gnu-sed gsed bash silicon ninja cmake gettext curl mdformat || true
  elif isArch; then
    [[ ${VERBOSE:-0} -eq 1 ]] && echo "  Installing Neovim dependencies for arch..."
    sudo pacman -S --noconfirm --quiet ripgrep fd luarocks ninja gettext cmake unzip curl || true
  else
    [[ ${VERBOSE:-0} -eq 1 ]] && echo "  Installing Neovim dependencies..."
    sudo apt-get -qq install -y ripgrep fd-find luarocks ninja-build gettext cmake unzip curl build-essential || true
    sudo luarocks install luacheck || true
  fi

  ubi -v -i "$HOME/.local/bin" -p atanunq/viu || true

  [[ ${VERBOSE:-0} -eq 1 ]] && echo "  Cloning Neovim repository"
  rm -rf /tmp/neovim-source
  git clone --quiet https://github.com/neovim/neovim.git /tmp/neovim-source >/dev/null || true
  pushd /tmp/neovim-source >/dev/null || return 0
  if [[ -n "$NVIM_VERSION" ]]; then
    [[ ${VERBOSE:-0} -eq 1 ]] && echo "  Checking out version $NVIM_VERSION"
    git switch "$NVIM_VERSION" --detach || true
  fi
  rm -rf build
  [[ ${VERBOSE:-0} -eq 1 ]] && echo "  Building Neovim..."
  make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local/neovim -Wno-dev" >/dev/null 2>&1 || true
  [[ ${VERBOSE:-0} -eq 1 ]] && echo "  Installing Neovim..."
  make install >/dev/null 2>&1 || true
  popd >/dev/null || true

  local INSTALLED_NVIM_VERSION
  if [[ -x "$HOME/.local/neovim/bin/nvim" ]]; then
    INSTALLED_NVIM_VERSION=$($HOME/.local/neovim/bin/nvim --version | head -n1 | cut -d' ' -f2 | cut -d'+' -f1)
    echo "Installed Neovim ${INSTALLED_NVIM_VERSION}"
  fi

  echo "Installing stylua..."
  ubi -v -i "$HOME/.local/bin" -p JohnnyMorganz/stylua || true

  echo "Installing tree-sitter-cli..."
  cargo install -q tree-sitter-cli || true

  echo "Installing LSPs..."
  npm i -g vscode-langservers-extracted intelephense @github/copilot-language-server || true

  echo "Installing PHP DAP adapter..."
  install_with_git ~/src/vscode-php-debug https://github.com/xdebug/vscode-php-debug.git || true
  pushd ~/src/vscode-php-debug >/dev/null || return 0
  "$HOME/.local/bin/mise" exec nodejs -- npm install --silent --no-progress || true
  "$HOME/.local/bin/mise" exec nodejs -- npm run --silent build || true
  popd >/dev/null || true
}

# No actions on source — setup.sh calls install()
