#! /usr/bin/env bash
set -e
###########################################################################
#
# Docker Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/docker
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/docker/install.sh | bash
#
###########################################################################

if [ `id -u` = 0 ]; then
  printf "\033[1;31mThis script must NOT be run as root\033[0m\n" 1>&2
  exit 1
fi

###########################################################################
# Constants and Global Variables
###########################################################################

readonly GIT_REPO="https://github.com/polymimetic/playbook.git"
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/docker"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_error()   { echo -e "\033[1;31m✖  $@\033[0m";     }      # red
function e_success() { echo -e "\033[1;32m✔  $@\033[0m";     }      # green
function e_prompt()  { echo -e "\033[1;33m$@ \033[0m";       }      # yellow
function e_info()    { echo -e "\033[1;34m$@\033[0m";        }      # blue
function e_title()   { echo -e "\033[1;35m$@.......\033[0m"; }      # magenta

###########################################################################
# Install Docker
# https://www.docker.com/
#
# https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
# https://docs.docker.com/engine/installation/linux/linux-postinstall/
# https://joshtronic.com/2017/10/25/oci-runtime-error-after-upgrading-docker-on-arch-linux/
###########################################################################

install_docker() {
  e_title "Installing Docker"

  # Install docker dependencies
  sudo apt-get update
  sudo apt-get install -yq apt-transport-https ca-certificates curl software-properties-common

  # Add docker’s official GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  # Setup the stable repository
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  # Install the latest version of docker ce
  sudo apt-get update
  sudo apt-get install -yq docker-ce

  # Create the docker group
  sudo groupadd docker
  sudo usermod -aG docker ${USER}

  # Change docker folder permissions
  sudo chown "${USER}":"${USER}" "${HOME}"/.docker -R
  sudo chmod g+rwx "${HOME}/.docker" -R

  # Configure Docker to start on boot
  sudo systemctl enable docker

  # Reload the Docker daemon
  sudo systemctl daemon-reload
  sudo systemctl restart docker

  e_success "Docker installed"
}

###########################################################################
# Install Docker Indicator
# https://yktoo.com/en/software/indicator-docker
#
# https://github.com/yktoo/indicator-docker/blob/master/INSTALL
###########################################################################

install_docker_indicator() {
  e_title "Installing Docker indicator"

  # Install docker pip module
  sudo pip3 install docker

  # Install docker indicator
  if ! grep -q "yktooo/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:yktooo/ppa
    sudo apt-get update
  fi

  sudo apt-get install -yq indicator-docker

  # Change default Docker indicator icon
  sudo wget -O /usr/share/icons/hicolor/22x22/status/indicator-docker.svg https://raw.githubusercontent.com/yktoo/indicator-docker/master/icons/ubuntu-mono-dark/indicator-docker.svg

  e_success "Docker indicator installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_docker
  install_docker_indicator
}

program_start
