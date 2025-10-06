update_github_release() {
  local response=$(curl -sL -w "%{http_code}" https://api.github.com/repos/$GITHUB_RELEASE_REPO/releases/latest -o /tmp/github_response.json)
  local status_code=$response

  if [ $status_code -eq 200 ]; then
    GITHUB_RELEASE_CONTENT=$(cat /tmp/github_response.json)
    if [[ $DEBUG -eq 1 ]]; then 
      echo "Successfully fetched release info for $GITHUB_RELEASE_REPO"
    fi
  elif [ $status_code -eq 403 ]; then
    local rate_limit_reset=$(curl -sI https://api.github.com/repos/$GITHUB_RELEASE_REPO/releases/latest | grep -i "x-ratelimit-reset" | awk '{print $2}' | tr -d '\r')
    if [ -n "$rate_limit_reset" ]; then
      if isMac; then
        local reset_time=$(date -r $rate_limit_reset "+%Y-%m-%d %H:%M:%S")
      else
        local reset_time=$(date -d @$rate_limit_reset "+%Y-%m-%d %H:%M:%S")
      fi
      echo "Error: GitHub API rate limit exceeded. Limit will reset at $reset_time"
    else
      echo "Error: GitHub API rate limit exceeded. Please try again later."
    fi
    exit 1
  else
    echo "Error while fetching release info for $GITHUB_RELEASE_REPO. Status code: $status_code"
    exit 1
  fi
}

get_latest_github_release() {
  GITHUB_RELEASE_VERSION=v$(echo "$GITHUB_RELEASE_CONTENT" | grep '"tag_name":' | sed -E 's/.*"v*([^"]+)".*/\1/')
}

adjust_github_release_file() {
  [[ $DEBUG -eq 1 ]] && echo "Adjusting $GITHUB_RELEASE_FILE"
  GITHUB_RELEASE_FILE="${GITHUB_RELEASE_FILE/:VERSION:/$GITHUB_RELEASE_VERSION}"
  GITHUB_RELEASE_FILE="${GITHUB_RELEASE_FILE/:VERSION_NUM:/${GITHUB_RELEASE_VERSION#v}}"

  if [[ "$GITHUB_RELEASE_CONTENT" != *"$ARCH"* ]]; then
    if isArm64; then
      if [[ "$GITHUB_RELEASE_CONTENT" == *"aarch64"* ]]; then
        [[ $DEBUG -eq 1 ]] && echo "Adjusting $GITHUB_RELEASE_FILE for $ARCH"
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
  [[ $VERBOSE -eq 1 ]] && echo "Fetching from $URL"
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
