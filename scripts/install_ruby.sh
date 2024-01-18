#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh

if isMac; then
  echo "Installing Ruby deps..."
  sudo apt install git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev
else
  echo "Installing on Linux..."
fi

echo "Installing asdf..."
install_with_git ~/.asdf https://github.com/excid3/asdf.git

echo "Installing Ruby..."
asdf plugin add ruby
asdf install ruby latest
asdf global ruby latest

echo "Updating Gems..."
gem update --system

echo "Installing nodejs..."
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest

echo "Installing yarn..."
npm install -g yarn

echo "Installing rails..."
gem install rails

echo "Installing sqlite3..."
asdf plugin add sqlite
asdf install sqlite latest
asdf global sqlite latest

stow --target=$HOME --restow asdf
