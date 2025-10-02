#!/usr/bin/env bash

install() {
  print_header "Docker"

  if isMac; then
    brew install orbstack || true
  elif isArch; then
    sudo pacman -S --noconfirm --quiet docker docker-compose docker-buildx || true

    sudo systemctl enable docker.service || true
    sudo systemctl enable containerd.service || true
    sudo systemctl start docker containerd || true
    sudo usermod -aG docker "$USER" || true
  elif isLinux; then
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc || true
    sudo chmod a+r /etc/apt/keyrings/docker.asc || true

    echo "Adding apt source for docker engine..."
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get -qq update || true

    sudo apt-get -qq install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || true

    sudo systemctl enable docker.service || true
    sudo systemctl enable containerd.service || true
    sudo systemctl start docker containerd || true

    sudo usermod -aG docker "$USER" || true

    # Limit log size to avoid running out of disk
    echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json
  fi

  echo "Installing lazydocker..."
  ubi -v -i "$HOME/.local/bin" -p jesseduffield/lazydocker || true
}

# No actions on source — setup.sh calls install()
