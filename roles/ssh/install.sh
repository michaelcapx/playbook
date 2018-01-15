#! /usr/bin/env bash
set -e
###########################################################################
#
# Ssh Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/ssh
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/ssh/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/ssh"

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
# Install SSH
# https://help.github.com/articles/checking-for-existing-ssh-keys/
# https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
###########################################################################

install_ssh() {
  e_title "Generating SSH Keys"

  local ssh_email=""
  local ssh_keyfile="${HOME}/.ssh/id_rsa"

  if [[ ${ssh_email} != "" ]]; then
    e_prompt "What is your email?:"
    read ssh_email
  fi

  # Ensure SSH home directory exists
  if [[ ! -d "${HOME}/.ssh" ]]; then
    mkdir -p "${HOME}/.ssh"
    chmod 700 "${HOME}/.ssh"
  fi

  # Setup SSH config
  if [[ ! -f "${HOME}/.ssh/config" ]]; then
    touch "${HOME}/.ssh/config"
    chmod 600 "${HOME}/.ssh/config"
    echo "#Host ..." >> "${HOME}/.ssh/config"
    echo "#HostName ..." >> "${HOME}/.ssh/config"
    echo "#Port ..." >> "${HOME}/.ssh/config"
    echo "#User ..." >> "${HOME}/.ssh/config"
    echo "#IdentityFile ..." >> "${HOME}/.ssh/config"
  fi

  # Generate SSH keypair
  if [[ ! -f "${ssh_keyfile}" ]]; then
    ssh-keygen -t rsa -b 4096 -C "${ssh_email}" -N "" -f "${ssh_keyfile}"
    cat ${ssh_keyfile}.pub
    eval "$(ssh-agent -s)"
    ssh-add ${ssh_keyfile}
  fi

  # Start SSH agent and add keys
  ls ~/.ssh/*.pub >/dev/null 2>&1
  rc=$?
  if [ -z "$SSH_AGENT_PID" -a $rc -eq 0 ]; then
    eval $(ssh-agent -s)
    for f in ~/.ssh/*.pub; do
      ssh-add "${f%.pub}"
    done
  fi

  e_success "SSH Keys generated"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_ssh
}

program_start