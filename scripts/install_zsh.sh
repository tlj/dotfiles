#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

if isMac; then
  echo "Installing kitty..."
  brew install -q --cask kitty
  curl -sL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin &> /dev/null

  echo "Installing autojump, btop and lsd..."
  brew install -q autojump lsd btop jq starship zsh-vi-mode

  echo "Installing jqp..."
  brew install noahgorstein/tap/jqp

  echo "Installing Nerd Fonts"
  brew tap homebrew/cask-fonts
  brew install -q --cask font-hack-nerd-font font-fira-code-nerd-font font-symbols-only-nerd-font font-jetbrains-mono

  echo "Installing commitizen-go"
  brew tap lintingzhen/tap
  brew install -q commitizen-go
  commitizen-go install

  echo "Installing presenterm..."
  brew install -q presenterm
else
  echo "Install zsh.."
  sudo apt install zsh

  echo "Install LSD..."
  curl -sLo /tmp/lsd.deb https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
  sudo dpkg -i /tmp/lsd.deb

  echo "Install autojump..."
  sudo apt install autojump 
  mkdir -p ~/.local/bin

  if [[ ! -f ~/.local/bin/bat ]]; then
    ln -s /usr/bin/batcat ~/.local/bin/bat
  fi

  echo "Installing btop..."
  install_github_release aristocratos/btop btop-x86_64-linux-musl.tbz
fi

echo "Installing asdf..."
install_with_git ~/.asdf https://github.com/excid3/asdf.git

. "$HOME/.asdf/asdf.sh"

echo "Installing bat..."
asdf plugin add bat
asdf install bat

echo "Installing zoxide..."
asdf plugin add zoxide https://github.com/nyrst/asdf-zoxide.git
asdf install zoxide

echo "Installing jq and jqp..."
asdf plugin add jq
asdf install jq

asdf plugin add jqp
asdf install jqp

echo "Building bat cache..."
bat cache --build > /dev/null

echo "Installing zsh-vi-mode..."
install_with_git ~/.zsh/zsh-vi-mode jeffreytse/zsh-vi-mode

echo "Installing zsh-autosuggestions..."
install_with_git ~/.zsh/zsh-autosuggestions zsh-users/zsh-autosuggestions

echo "Installing fzf from git..."
install_with_git ~/.fzf https://github.com/junegunn/fzf.git

stow --target=$HOME --restow kitty/ btop/ zsh/ bat/ lsd/ atuin/ starship/
