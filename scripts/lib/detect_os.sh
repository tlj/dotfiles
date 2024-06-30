#!/usr/bin/env bash

isMac() {
  systemName=$(uname -s)
  if [[ $systemName == "Darwin" ]]; then
    return 0
  else
    return 1
  fi
}

ARCH=$(uname -m)
PLATFORM=Linux

if isMac; then
  PLATFORM=Darwin
fi

