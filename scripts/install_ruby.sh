#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  echo "Installing Ruby..."
  brew install -q ruby
fi
