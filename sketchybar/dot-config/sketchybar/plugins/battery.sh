#!/usr/bin/env bash

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [[ $PERCENTAGE = "" ]]; then
  exit 0
fi

LABEL_COLOR=ebdbb2

case ${PERCENTAGE} in
  9[0-9]|100) ICON=""
  ;;
  [6-8][0-9]) ICON=""
  ;;
  [3-5][0-9]) 
    ICON=""
    LABEL_COLOR=fabd2f
  ;;
  [1-2][0-9]) 
    ICON=""
    LABEL_COLOR=fb4934
  ;;
  *) 
    ICON=""
    LABEL_COLOR=cc241d
esac

if [[ $CHARGING != "" ]]; then
  ICON=""
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set $NAME icon="$ICON" icon.color="0xff${LABEL_COLOR}" label="${PERCENTAGE}%"
