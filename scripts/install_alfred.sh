#!/usr/bin/env bash


. scripts/lib/detect_os.sh

ALFRED_VERSION="5.1.3"
ALFRED_BUILD=2175

if isMac; then
  echo "Installing Alfred ${ALFRED_VERSION}..."
  if cat "/Applications/Alfred 5.app/Contents/Info.plist" | grep -q ${ALFRED_VERSION}; then
    echo "Already installed."
  else
    if ! curl --fail -sLo /tmp/Alfred.dmg https://cachefly.alfredapp.com/Alfred_${ALFRED_VERSION}_${ALFRED_BUILD}.dmg; then
      echo "Unable to download Alfred ${ALFRED_VERSION}..."
    else 
      xattr -c /tmp/Alfred.dmg
      hdiutil attach /tmp/Alfred.dmg -nobrowse -quiet
      rm ~/nvim-macos/bin &> /dev/null
      rm -rf "/Applications/Alfred 5.app/" &> /dev/null
      cp -R "/Volumes/Alfred/Alfred 5.app" /Applications/
      sleep 3
      hdiutil detach "$(/bin/df | /usr/bin/grep "Alfred" | awk '{print $1}')" -quiet
    fi
  fi
fi
