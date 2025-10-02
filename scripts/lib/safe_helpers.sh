# Safe helper functions for installers
# These are DRY_RUN-aware and exported so subshells/source-scripts inherit them.

# Safe file/directory helpers
safe_mkdir() {
  local dir="$1"
  if [[ ${DRY_RUN:-0} -eq 1 ]]; then
    printf "[DRY-RUN] mkdir -p %s\n" "$dir"
    return 0
  fi
  mkdir -p "$dir"
}

safe_backup() {
  local file="$1"
  if [[ -e "$file" && ! -L "$file" ]]; then
    local dest="$file.orig"
    if [[ ${DRY_RUN:-0} -eq 1 ]]; then
      printf "[DRY-RUN] mv %s %s\n" "$file" "$dest"
      return 0
    fi
    mv "$file" "$dest"
  fi
}

safe_rm() {
  local target="$1"
  if [[ ${DRY_RUN:-0} -eq 1 ]]; then
    printf "[DRY-RUN] rm -f %s\n" "$target"
    return 0
  fi
  rm -f "$target"
}

safe_mv() {
  local src="$1" dest="$2"
  if [[ ${DRY_RUN:-0} -eq 1 ]]; then
    printf "[DRY-RUN] mv %s %s\n" "$src" "$dest"
    return 0
  fi
  mv "$src" "$dest"
}

safe_symlink() {
  local src="$1" dest="$2"
  if [[ ${DRY_RUN:-0} -eq 1 ]]; then
    printf "[DRY-RUN] ln -s %s %s\n" "$src" "$dest"
    return 0
  fi
  ln -s "$src" "$dest"
}

# Safe write helper: atomic write with tempfile, supports heredoc via stdin
safe_write() {
  local dest="$1"
  if [[ -z "$dest" ]]; then
    printf "safe_write: destination required\n" >&2
    return 1
  fi
  if [[ ${DRY_RUN:-0} -eq 1 ]]; then
    if [ -t 0 ]; then
      printf "[DRY-RUN] write to %s (no stdin content)\n" "$dest"
    else
      local preview
      preview=$(cat - | sed -n '1,200p')
      printf "[DRY-RUN] write to %s; content preview:\n%s\n" "$dest" "$preview"
    fi
    return 0
  fi
  # Ensure destination dir exists
  safe_mkdir "$(dirname "$dest")"
  local tmp
  tmp=$(mktemp)
  if [ -t 0 ]; then
    printf "safe_write: expecting data on stdin\n" >&2
    rm -f "$tmp" || true
    return 1
  else
    cat - > "$tmp"
  fi
  mv "$tmp" "$dest"
  chmod 0644 "$dest" || true
}

# Safe write that writes to destination requiring root: write to temp and sudo-move into place
safe_write_root() {
  local dest="$1"
  if [[ -z "$dest" ]]; then
    printf "safe_write_root: destination required\n" >&2
    return 1
  fi
  if [[ ${DRY_RUN:-0} -eq 1 ]]; then
    if [ -t 0 ]; then
      printf "[DRY-RUN] write to %s (no stdin content)\n" "$dest"
    else
      local preview
      preview=$(cat - | sed -n '1,200p')
      printf "[DRY-RUN] write to %s; content preview:\n%s\n" "$dest" "$preview"
    fi
    return 0
  fi
  local tmp
  tmp=$(mktemp)
  cat - > "$tmp"
  sudo mv "$tmp" "$dest"
  sudo chmod 0644 "$dest" || true
}

# Export functions
export -f safe_mkdir safe_backup safe_rm safe_mv safe_symlink safe_write safe_write_root
