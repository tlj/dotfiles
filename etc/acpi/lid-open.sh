#!/bin/bash
set -euo pipefail

# Wait for hardware to settle
sleep 0.3

# Load utilities
. /etc/acpi/hypr-utils.sh || exit 0

log "Lid open event received"

# Set up Hyprland communication
if ! export_hypr_env; then
  log "Hyprland not running, nothing to do"
  exit 0
fi

# Check monitor configuration
if external_connected; then
  log "External monitor connected - setting up dual display mode"
  
  # Enable both monitors
  set_dual_layout
  
  # Distribute workspaces between monitors
  # External gets 1-5, laptop gets 6-10 (configurable in hypr-utils.sh)
  # Disabled due to using split-monitor-workspaces plugin for hypr
  # move_ws_to_monitor "$EXTERNAL_MONITOR" $EXTERNAL_WS
  # move_ws_to_monitor "$LAPTOP_MONITOR" $LAPTOP_WS
  
  # Notify user
  notify "Display Configuration" "Lid opened: Dual display mode active"
  
  # Wake up both monitors
  hypr dispatch dpms on
  
  log "Successfully configured dual display mode"
else
  log "No external monitor - using laptop display only"
  set_laptop_only
  
notify "Display Configuration" "Using laptop display"
fi
