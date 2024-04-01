#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  echo "No fuse available."
else
  sudo apt install -yq fuse libfuse2
fi
