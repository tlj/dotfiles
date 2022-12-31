
install_with_git() {
  REPO=$2
  DIR=$1
  if [[ ! -d "$DIR" ]]; then
    git clone --quiet --depth=1 $REPO "$DIR"
  else
    git -C "$DIR" pull --quiet
  fi
}

