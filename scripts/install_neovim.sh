#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

NEOVIDE_VERSION=0.11.2
VIU_VERION=v1.5.0
STYLUA_VERSION=v0.19.1
NEOVIM_VERSION=nightly

echo "Installing Neovim..."
if isMac; then
  echo "Installing Neovim dependencies..."
  brew install -q ripgrep fd fzf luacheck stylua gnu-sed gsed bash viu silicon

  # Install neovim from binary to make sure we have the correct version always
  if ~/nvim-macos/bin/nvim --version | grep -q --only-matching "${NEOVIM_VERSION}"; then
    echo "Already have Neovim ${NEOVIM_VERSION}."
  else
    echo "Installing Neovim ${NEOVIM_VERSION}..."
    curl -sLo /tmp/neovim-macos.tar.gz https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/nvim-macos.tar.gz
    xattr -c /tmp/neovim-macos.tar.gz
    tar xf /tmp/neovim-macos.tar.gz -C ~/
  fi

  # Install neovide from binary
  if /Applications/neovide.app/Contents/MacOS/neovide --version | grep -q --only-matching "${NEOVIDE_VERSION}"; then
    echo "Already have Neovide v${NEOVIDE_VERSION}."
  else
    echo "Installing Neovide v${NEOVIDE_VERSION}..."
    curl -sLo /tmp/neovide.dmg.zip https://github.com/neovide/neovide/releases/download/${NEOVIDE_VERSION}/neovide.dmg.zip
    xattr -c /tmp/neovide.dmg.zip
    unzip -qo /tmp/neovide.dmg.zip -d /tmp
    hdiutil attach /tmp/neovide.dmg -nobrowse -quiet
    rm ~/nvim-macos/bin &> /dev/null
    rm -rf /Applications/neovide.app/ &> /dev/null
    cp -R /Volumes/neovide/neovide.app /Applications/
    hdiutil detach "$(/bin/df | /usr/bin/grep "neovide" | awk '{print $1}')" -quiet
  fi
else
  sudo apt-get install ripgrep fd-find fzf luarocks
  sudo luarocks install luacheck

  sudo npm install -g tree-sitter-cli
  mkdir -p ~/.local/bin
  echo "Installing stylua..."
  install_github_release JohnnyMorganz/StyLua stylua-linux-x86_64.zip
  echo "Installing viu..."
  install_github_release atanunq/viu viu-x86_64-unknown-linux-musl
  echo "Installing neovim $NEOVIM_VERSION..."
  install_github_release neovim/neovim nvim.appimage $NEOVIM_VERSION
  mv ~/.local/bin/neovim ~/.local/bin/nvim

  #curl -sLo /tmp/neovim.deb https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/nvim-linux64.deb
  #sudo dpkg -i /tmp/neovim.deb
fi

echo "Installing PHP DAP adapter..."
install_with_git ~/src/vscode-php-debug https://github.com/xdebug/vscode-php-debug.git 
cd ~/src/vscode-php-debug
npm install --silent --no-progress || true
npm run --silent build || true
cd - > /dev/null

stow --target=$HOME --restow nvim/
