#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  echo "Installing golang..."
  brew install -q go
fi
