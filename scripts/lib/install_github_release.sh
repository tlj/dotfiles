update_github_release() {
  GITHUB_RELEASE_CONTENT=$(curl -sL https://api.github.com/repos/$GITHUB_RELEASE_REPO/releases/latest)
  if [[ -z $GITHUB_RELEASE_CONTENT ]]; then
    echo "Error while fetching release info for $GITHUB_RELEASE_REPO"
    exit
  fi
}

get_latest_github_release() {
  GITHUB_RELEASE_VERSION=v$(echo "$GITHUB_RELEASE_CONTENT" | grep '"tag_name":' | sed -E 's/.*"v*([^"]+)".*/\1/')
}

adjust_github_release_file() {
  echo "Adjusting $GITHUB_RELEASE_FILE"
  GITHUB_RELEASE_FILE="${GITHUB_RELEASE_FILE/:VERSION:/$GITHUB_RELEASE_VERSION}"
  GITHUB_RELEASE_FILE="${GITHUB_RELEASE_FILE/:VERSION_NUM:/${GITHUB_RELEASE_VERSION#v}}"

  if [[ "$GITHUB_RELEASE_CONTENT" != *"$ARCH"* ]]; then
    if isArm64; then
      if [[ "$GITHUB_RELEASE_CONTENT" == *"aarch64"* ]]; then
        echo "Adjusting $GITHUB_RELEASE_FILE for $ARCH"
        GITHUB_RELEASE_FILE="${GITHUB_RELEASE_FILE/arm64/aarch64}"
      fi
    fi
  fi
}

install_github_release() {
    GITHUB_RELEASE_REPO=$1
    GITHUB_RELEASE_FILE=$2
    GITHUB_RELEASE_VERSION=$3

    update_github_release
    if [[ -z $GITHUB_RELEASE_VERSION ]]; then
      get_latest_github_release
    fi
    adjust_github_release_file

    URL=https://github.com/${GITHUB_RELEASE_REPO}/releases/download/${GITHUB_RELEASE_VERSION}/${GITHUB_RELEASE_FILE}
    echo "Fetching from $URL"
    curl -sLo /tmp/$GITHUB_RELEASE_FILE $URL
    if [[ $? -ne 0 ]]; then
      echo "Error while downloading $URL"
      exit
    fi
    if [[ $GITHUB_RELEASE_FILE == *.zip ]]; then
      unzip -qo /tmp/$GITHUB_RELEASE_FILE -d ~/.local/bin/
    elif [[ $GITHUB_RELEASE_FILE == *.tbz ]]; then
      DIRCOUNT=$(tar tjvf /tmp/$GITHUB_RELEASE_FILE | grep ^d | wc -l)
      if [[ "$DIRCOUNT" == "0" ]]; then
        tar xjf /tmp/$GITHUB_RELEASE_FILE -C ~/.local/bin
      else
        tar xjf /tmp/$GITHUB_RELEASE_FILE -C ~/.local --strip-components=2
      fi
    elif [[ $GITHUB_RELEASE_FILE == *.tbz ]]; then
      DIRCOUNT=$(tar tvf /tmp/$GITHUB_RELEASE_FILE | grep ^d | wc -l)
      if [[ "$DIRCOUNT" == "0" ]]; then
        tar zxf /tmp/$GITHUB_RELEASE_FILE -C ~/.local/bin
      else
        tar zxf /tmp/$GITHUB_RELEASE_FILE -C ~/.local --strip-components=1
      fi
    elif [[ $GITHUB_RELEASE_FILE == *.tar.gz ]]; then
      DIRCOUNT=$(tar tvf /tmp/$GITHUB_RELEASE_FILE | grep ^d | wc -l | xargs)
      if [[ "$DIRCOUNT" == "0" ]]; then
        tar zxf /tmp/$GITHUB_RELEASE_FILE -C ~/.local/bin
      else
        tar zxf /tmp/$GITHUB_RELEASE_FILE -C ~/.local --strip-components=1
      fi
    else 
      BIN=(${GITHUB_RELEASE_REPO//\// })
      TARGET=~/.local/bin/${BIN[1]}
      mv /tmp/$GITHUB_RELEASE_FILE $TARGET
      chmod a+rx $TARGET
    fi
}
