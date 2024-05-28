#!/bin/bash

# Install docker

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Install lazydocker

curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

cat << EOF >> ~/.bash_profile
function lazydocker-ssh() {
    ssh -L /tmp/docker-remote.sock:/var/run/docker.sock $1 -fN
    DOCKER_HOST=unix:///tmp/docker-remote.sock lazydocker
}
EOF

# Install pyenv

## First we install some common development tools like gcc and make, Fedora provides a group of packages for that call Development Tools
sudo dnf groupinstall "Development Tools" -y

## To build Python we need some additional packages
sudo dnf install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel findutils -y

curl https://pyenv.run | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile

# Install Tmux

sudo dnf -y install tmux

# Install Make

sudo dnf -y install make

# Setup bash aliases

cat << EOF >> ~/.bash_profile
alias ..="cd .."
alias ll="ls -la"
alias va="source .venv/bin/activate"
alias ve="python -m venv .venv"
alias vp="pip install pylint mypy black isort autoflake piptools"
# Set vi for bash editing mode
set -o vi
# Set vi as the default editor for all apps that check this
EDITOR=vi
EOF
