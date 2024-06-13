#!/bin/bash

# Install docker

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker $USER

# Install disk management tools

sudo dnf -y install duf
sudo dnf copr enable -y gourlaysama/dust
sudo dnf -y install dust

# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
echo 'eval "$(zoxide init --cmd cd bash)"' >> ~/.bashrc

# Install fzf
sudo dnf -y install ripgrep
cat <<EOF >> ~/.bashrc
if type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
fi
EOF

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Install Node.js

sudo dnf -y install nodejs

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Install lazydocker

curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

cat <<EOF >> ~/.bashrc
function lazydocker-ssh() {
    if [ -f /tmp/docker-remote.sock ]; then
        rm /tmp/docker-remote.sock
    fi
    ssh -L /tmp/docker-remote.sock:/var/run/docker.sock $1 -fN
    DOCKER_HOST=unix:///tmp/docker-remote.sock lazydocker
}
EOF

# Install Make

sudo dnf -y install make

# Install just - make alternative

sudo dnf -y install just

# Install pyenv

## First we install some common development tools like gcc and make, Fedora provides a group of packages for that call Development Tools
sudo dnf groupinstall "Development Tools" -y

## To build Python we need some additional packages
sudo dnf install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel findutils -y

curl https://pyenv.run | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Install Tmux

sudo dnf -y install tmux

git clone https://github.com/vtannguyen/tmux-conf.git
cd tmux-conf
./install.sh
cd ../
rm -rf tmux-conf

# Install Vim

sudo dnf -y install vim wl-clipboard

git clone https://github.com/vtannguyen/vim-dotfiles.git ~/.vim && cp ~/.vim/.vimrc ~/
cd ~/.vim
sudo ./install_caps2esc.sh
./install_formatters.sh
cd ../

# Install i3

git clone https://github.com/vtannguyen/i3.git
cd i3
./install.sh
cd ..
rm -rf i3

# Setup bash aliases

cat <<EOF >> ~/.bashrc
alias ..="cd .."
alias ll="ls -la"
alias va="source .venv/bin/activate"
alias ve="python -m venv .venv"
alias vp="pip install pylint mypy black isort autoflake pip-tools"
# Set vi for bash editing mode
set -o vi
# Set vi as the default editor for all apps that check this
EDITOR=vi
EOF
