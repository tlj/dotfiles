#!/usr/bin/env bash

PHASE=$(osascript -e 'tell application "Flow" to getPhase')
if [[ $PHASE == "" ]]; then
  exit 0
fi

POMODORO=$(osascript -e 'tell application "Flow" to getTime')

if [[ $POMODORO == "" ]]; then
  exit 0
fi

sketchybar --set $NAME icon="$ICON" label="${PHASE} ${POMODORO}"
