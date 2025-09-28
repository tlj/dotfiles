#!/bin/bash
set -euo pipefail

# Wait for Hyprland to fully initialize
sleep 3

# Load utilities
. /etc/acpi/hypr-utils.sh || exit 0

log "Running startup lid state check"

# Set up Hyprland communication
if ! export_hypr_env; then
  log "Hyprland not ready at startup, skipping"
  exit 0
fi

# Detect current lid state from kernel
LID_STATE="unknown"
for lid_state_file in /proc/acpi/button/lid/*/state; do
  if [ -r "$lid_state_file" ]; then
    if grep -q closed "$lid_state_file"; then
      LID_STATE="closed"
    else
      LID_STATE="open"
    fi
    break
  fi
done

log "Detected lid state at startup: $LID_STATE"

# Configure displays based on lid state
if [ "$LID_STATE" = "closed" ] && external_connected; then
  log "Starting with lid closed and external monitor - using external only"
  set_external_only
  # move_ws_to_monitor "$EXTERNAL_MONITOR" 1 2 3 4 5 6 7 8 9 10
  notify "Display Configuration" "Started with lid closed - using external monitor"
  
elif [ "$LID_STATE" = "open" ] && external_connected; then
  log "Starting with lid open and external monitor - using dual layout"
  set_dual_layout
  # move_ws_to_monitor "$EXTERNAL_MONITOR" $EXTERNAL_WS
  # move_ws_to_monitor "$LAPTOP_MONITOR" $LAPTOP_WS
  notify "Display Configuration" "Started with dual displays"
  
else
  log "Starting without external monitor - using laptop only"
  set_laptop_only
  notify "Display Configuration" "Started with laptop display only"
fi

# Ensure displays are awake
hypr dispatch dpms on

log "Startup configuration complete"
