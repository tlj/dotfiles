#!/usr/bin/env bash

# Idempotent include guard
if [[ -n "${TRAITS_SH_LOADED:-}" ]]; then
  [[ "${VERBOSE:-0}" -eq 1 ]] && echo "traits.sh already loaded"
  return 0
fi
TRAITS_SH_LOADED=1

# Determine the top-level script that started the process (last element of BASH_SOURCE)
# This mirrors the previous behaviour but is more explicit and robust.
TOP_SCRIPT="${BASH_SOURCE[$(( ${#BASH_SOURCE[@]} - 1 ))]}"
TOP_DIR="$(dirname "$(realpath "$TOP_SCRIPT")")"

# Allow overriding the hosts file location from the environment
HOSTS_FILE="${HOSTS_FILE:-$TOP_DIR/hosts.sh}"

if [[ ! -f "$HOSTS_FILE" ]]; then
  echo "hosts file not found at $HOSTS_FILE"
  return 1
fi

# shellcheck disable=SC1090
source "$HOSTS_FILE"

# Short hostname, normalized to lower-case for stable lookups
INSTALL_HOST="$(hostname -s 2>/dev/null || hostname)"
# Normalize to lower case in a portable way
INSTALL_HOST="$(printf "%s" "$INSTALL_HOST" | tr '[:upper:]' '[:lower:]')"

# Provide a helpful message when verbosity is enabled
if [[ -v HOSTS["$INSTALL_HOST"] ]]; then
  [[ "${VERBOSE:-0}" -eq 1 ]] && echo "Using traits from $HOSTS_FILE for ${INSTALL_HOST}: ${HOSTS[$INSTALL_HOST]}"
else
  echo "Host ${INSTALL_HOST} not found in $HOSTS_FILE."
  return 1
fi

# Check whether the current host has a trait (safe splitting, avoids globbing)
has_trait() {
  local trait="$1"
  local host_traits="${HOSTS[$INSTALL_HOST]:-}"
  local -a traits_arr=()

  if [[ -n "$host_traits" ]]; then
    IFS=' ' read -r -a traits_arr <<< "$host_traits"
  fi

  local t
  for t in "${traits_arr[@]}"; do
    [[ "$t" == "$trait" ]] && return 0
  done
  return 1
}

# Require a trait, printing a message and returning non-zero so callers control behavior
require_trait() {
  local trait="$1"
  local msg="${2:-}"
  if ! has_trait "$trait"; then
    if [[ -n "$msg" ]]; then
      echo "$msg"
    fi
    return 1
  fi
  return 0
}

# List traits for the current host (one per line)
list_traits() {
  local host_traits="${HOSTS[$INSTALL_HOST]:-}"
  if [[ -z "$host_traits" ]]; then
    return 0
  fi
  printf "%s\n" $host_traits
}

# Find hosts that have a given trait
hosts_with_trait() {
  local search="$1"
  local host
  for host in "${!HOSTS[@]}"; do
    local host_traits="${HOSTS[$host]}"
    for t in $host_traits; do
      [[ "$t" == "$search" ]] && printf "%s\n" "$host"
    done
  done
}

# End of traits.sh
