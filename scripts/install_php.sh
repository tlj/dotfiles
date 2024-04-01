#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  brew install autoconf automake bison freetype gd gettext icu4c krb5 libedit libiconv libjpeg libpng libxml2 libzip openssl@1.1 pkg-config re2c zlib
  brew install openssl@3
else
  sudo apt-get install -y autoconf bison build-essential curl gettext git libgd-dev libcurl4-openssl-dev libedit-dev libicu-dev libjpeg-dev libmysqlclient-dev libonig-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libzip-dev openssl pkg-config re2c zlib1g-dev
fi

asdf plugin-add php https://github.com/asdf-community/asdf-php.git
asdf install php


