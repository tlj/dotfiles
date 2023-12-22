
install_github_release() {
    REPO=$1
    FILE=$2
    VERSION=$3
    if [[ -z $VERSION ]]; then
      VERSION=v$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
    fi
    URL=https://github.com/${REPO}/releases/download/${VERSION}/${FILE}
    echo $URL
    curl -sLo /tmp/$FILE $URL
    if [[ $? -ne 0 ]]; then
      echo "Error while downloading $URL"
      exit
    fi
    if [[ $FILE == *.zip ]]; then
      unzip -qo /tmp/$FILE -d ~/.local/bin/
    elif [[ $FILE == *.tbz ]]; then
      DIRCOUNT=$(tar tjvf /tmp/$FILE | grep ^d | wc -l)
      if [[ "$DIRCOUNT" == "0" ]]; then
        tar xjf /tmp/$FILE -C ~/.local/bin
      else
        tar xjf /tmp/$FILE -C ~/.local --strip-components=2
      fi
    elif [[ $FILE == *.tbz ]]; then
      DIRCOUNT=$(tar tvf /tmp/$FILE | grep ^d | wc -l)
      if [[ "$DIRCOUNT" == "0" ]]; then
        tar zxf /tmp/$FILE -C ~/.local/bin
      else
        tar zxf /tmp/$FILE -C ~/.local --strip-components=1
      fi
    else 
      BIN=(${REPO//\// })
      TARGET=~/.local/bin/${BIN[1]}
      mv /tmp/$FILE $TARGET
      chmod a+rx $TARGET
    fi
}
