#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh

if isMac; then
  echo "Installing Ruby deps..."
  sudo apt install -yq git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev
else
  echo "Installing on Linux..."
fi

echo "Installing Ruby..."
mise install -qy ruby

echo "Updating Gems..."
gem update --system

echo "Installing yarn..."
npm install -g yarn

echo "Installing rails..."
gem install rails

echo "Installing sqlite3..."
mise install -qy sqlite

