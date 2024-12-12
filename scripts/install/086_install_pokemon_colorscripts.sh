#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/print_utils.sh

print_header "Pokemon Colorscripts"

install_with_git /tmp/pokemon-colorscripts https://gitlab.com/phoneybadger/pokemon-colorscripts.git

cd /tmp/pokemon-colorscripts

mkdir -p ~/.local/pokemon-colorscripts
cp -rf colorscripts ~/.local/pokemon-colorscripts
cp pokemon-colorscripts.py ~/.local/pokemon-colorscripts
cp pokemon.json ~/.local/pokemon-colorscripts

rm -rf ~/.local/bin/pokemon-colorscripts
ln -s ~/.local/pokemon-colorscripts/pokemon-colorscripts.py ~/.local/bin/pokemon-colorscripts

cd - >/dev/null
