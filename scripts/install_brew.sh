#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  brew=$(which brew)
  if [[ -z $brew ]]; then
    echo "Installing Homebrew..."
    echo "The script will stop after homebrew is installed. Restart it to continue installing tools."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    exit
  else 
    echo "Homebrew already installed."
  fi
fi
