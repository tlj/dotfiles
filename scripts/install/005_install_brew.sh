#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  brew=$(which brew)
  if [[ -z $brew ]]; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    PATH="/opt/homebrew/bin:$PATH"
  else 
    echo "Homebrew already installed."
  fi
fi
