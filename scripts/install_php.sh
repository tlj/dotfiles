#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  echo "Installing PHP composer..."
  brew install -q composer
fi
