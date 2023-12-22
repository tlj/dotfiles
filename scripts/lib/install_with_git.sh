
install_with_git() {
  DIR=$1
  REPO=$2
  if [[ ! -d "$DIR" ]]; then
    git clone --quiet --depth=1 "$REPO" "$DIR"
  else
    git -C "$DIR" pull --quiet
  fi
}
