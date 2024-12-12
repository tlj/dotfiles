#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Docker"

if isMac; then
  brew install orbstack
else
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo "Adding apt source for docker engine..."
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update

  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
  sudo systemctl start docker containerd

  sudo usermod -aG docker $USER

  # Limit log size to avoid running out of disk
  echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json

  echo "Installing lazydocker..."
  install_github_release jesseduffield/lazydocker lazydocker_:VERSION_NUM:_${PLATFORM}_${ARCH}.tar.gz 
fi

echo "Installing lazydocker..."
ubi -v -i ~/.local/bin -p jesseduffield/lazydocker

