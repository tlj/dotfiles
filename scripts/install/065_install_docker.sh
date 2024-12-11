#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh
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
  install_github_release docker/compose docker-compose-${PLATFORM}-${ARCH_ALT}
  mv ~/.local/bin/compose ~/.docker/cli-plugins/docker-compose
fi

echo "Installing lazydocker..."
install_github_release jesseduffield/lazydocker lazydocker_:VERSION_NUM:_${PLATFORM}_${ARCH_ALT}.tar.gz 


