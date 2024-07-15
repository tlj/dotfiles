#!/usr/bin/env bash

SYSTEM_NAME=$(uname -s)
ARCH=$(uname -m)
PLATFORM=

case $ARCH in
  x86)
    ARCH=amd64
    ;;
  x86_64)
    ARCH=amd64
    ;;
  armv8)
    ARCH=arm64
    ;;
  armv9)
    ARCH=arm64
    ;;
  aarch64)
    ARCH=arm64
    ;;
  default)
    echo "Unknown architecture: $ARCH"
    exit 1
    ;;
esac

isMac() {
  [[ $(uname -s) == "Darwin" ]]
}

isLinux() {
  [[ $(uname -s) =~ [Ll]inux ]]
}

isArm64() {
  [[ $(uname -m) == "arm64" ]]
}

isAmd64() {
  [[ $(uname -m) == "x86_64" ]]
}

if isMac; then
  PLATFORM=Darwin
elif isLinux; then
  PLATFORM=Linux
else
  echo "Unknown platform: $SYSTEM_NAME"
  exit 1
fi

PLATFORM_LC=$(echo $PLATFORM | tr '[:upper:]' '[:lower:]')

