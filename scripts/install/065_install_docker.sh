#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Docker"

if isMac; then
  brew install orbstack
else
  sudo apt install -y docker.io docker-buildx
  sudo usermod -aG docker ${USER}

  # Limit log size to avoid running out of disk
  echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json

  echo "Installing docker-compose..."
  mkdir -p ~/.docker/cli-plugins
  ubi -v -i ~/.local/bin -p docker/compose
  mv ~/.local/bin/compose ~/.docker/cli-plugins/docker-compose
fi

echo "Installing lazydocker..."
ubi -v -i ~/.local/bin -p jesseduffield/lazydocker

