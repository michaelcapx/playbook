#!/bin/bash

set -e

###########################################################################
#
# Bootstrap Installer
# https://github.com/michaelcapx/playbook
#
# # Usage:
#
# wget -qO - https://raw.github.com/michaelcapx/playbook/master/install.sh | bash
#
###########################################################################

###########################################################################
# Constants and Global Variables
###########################################################################

readonly MACHINE_MTYPE="$(uname -m)"                   # x86_64
readonly MACHINE_ID="$(lsb_release -i -s)"             # Ubuntu
readonly MACHINE_CODENAME="$(lsb_release -c -s)"       # xenial
readonly MACHINE_RELEASE="$(lsb_release -r -s)"        # 16.04
readonly MACHINE_DESKTOP="$(printenv DESKTOP_SESSION)" # xfce

readonly GIT_REPO="https://github.com/michaelcapx/playbook.git"
readonly GIT_DEST="$HOME/Downloads/playbook"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_header() { echo -e "\033[1;32m✔  $@\033[0m"; }
function e_error()  { echo -e "\033[1;31m✖  $@\033[0m"; }
function e_info()   { echo -e "\033[1;34m$@\033[0m"; }
function e_prompt() { echo -e "\033[1;33m$@\033[0m"; }

###########################################################################
# Install Core Packages
###########################################################################

install_core() {
  e_header "Installing core packages......."
  sudo apt install -y software-properties-common aptitude git nano curl wget
}

###########################################################################
# Install Python
###########################################################################

install_python() {
  if ! which python >/dev/null 2>&1; then
    e_header "Installing Python......."
    sudo apt update
    sudo apt install -y python-minimal python-simplejson
  else
    e_error "Python already installed......."
  fi
}

###########################################################################
# Install Ansible
###########################################################################

install_ansible() {
  if ! grep -q "ansible/ansible" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding Ansible PPA......."
    sudo apt-add-repository -y ppa:ansible/ansible
    sudo apt update
  fi

  if ! hash ansible >/dev/null 2>&1; then
    e_header "Installing Ansible......."
    sudo apt install -y python-apt ansible
    e_info "Ansible version: $(ansible --version) installed."
  else
    e_error "Ansible already installed......."
  fi
}

###########################################################################
# Clone Playbook
###########################################################################

clone_playbook() {
  e_header "Cloning playbook repo......."

  if [[ ! -d "$GIT_DEST" ]]; then
    mkdir -p $GIT_DEST
    git clone --recursive $GIT_REPO $GIT_DEST
  fi
}

###########################################################################
# Run Playbook
###########################################################################

prep_playbook() {

  if [ -f $GIT_DEST/requirements.yml ]; then
    e_header "Installing playbook dependencies......."
    ansible-galaxy install --roles-path $GIT_DEST/roles -r $GIT_DEST/requirements.yml --force
  fi

  if [ -f $GIT_DEST/vars/vault.yml ]; then
    local PLAYBOOK_CMD="ansible-playbook -i "$GIT_DEST"/hosts "$GIT_DEST"/playbook.yml -v --ask-become-pass --ask-vault-pass"
  else
    local PLAYBOOK_CMD="ansible-playbook -i "$GIT_DEST"/hosts "$GIT_DEST"/playbook.yml -v --ask-become-pass"
  fi

  e_prompt "Would you like to run the playbook now? (y/n): "
  read RUN_PLAYBOOK

  if [ "$RUN_PLAYBOOK" = "y" ] || [ "$RUN_PLAYBOOK" = "Y" ]; then
    e_header "Running the playbook......."
    $PLAYBOOK_CMD
  else
    echo ""
    echo "You can customize the playbook.yml to suit your needs, then run ansible with:"
    e_info "$PLAYBOOK_CMD"
    echo ""
    exit
  fi
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_core
  install_python
  install_ansible
  clone_playbook
  prep_playbook
}

program_start
