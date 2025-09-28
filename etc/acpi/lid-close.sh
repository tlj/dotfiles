#!/bin/bash
set -euo pipefail

# Wait a moment for the hardware to settle
sleep 0.3

# Load our utilities library
. /etc/acpi/hypr-utils.sh || exit 0

log "Lid close event received"

# Set up Hyprland communication
if ! export_hypr_env; then
  log "Hyprland not running, nothing to do"
  exit 0
fi

# Check if external monitor is connected
if external_connected; then
  log "External monitor connected - switching to external-only mode"
  
  # Disable laptop screen, enable external
  set_external_only
  
  # Move ALL workspaces to the external monitor
  # This ensures you don't lose any windows
  # Disables due to using hypr plugin split-monitor-workspaces
  # move_ws_to_monitor "$EXTERNAL_MONITOR" 1 2 3 4 5 6 7 8 9 10
  
  # Show desktop notification
  notify "Display Configuration" "Lid closed: Using external monitor only"
  
  # Wake up the monitor in case it went to sleep
  hypr dispatch dpms on
  
  log "Successfully switched to external-only mode"
else
  log "No external monitor connected - keeping laptop display active for safety"
  set_laptop_only
fi
