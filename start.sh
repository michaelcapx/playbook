#! /usr/bin/env bash
set -e
###########################################################################
#
# Playbook Installer
# https://github.com/polymimetic/playbook
#
# # Usage:
#
# wget -qO - https://raw.github.com/polymimetic/playbook/master/start.sh | bash
#
###########################################################################

if [[ $EUID -eq 0 ]]; then
  echo "This script must NOT be run as root" 1>&2
  exit 1
fi

###########################################################################
# Constants and Global Variables
###########################################################################

readonly GIT_REPO="https://github.com/polymimetic/playbook.git"
readonly GIT_DEST="$HOME/Downloads/playbook"

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
# Install Core Packages
###########################################################################

install_core() {
  e_title "Installing core packages"
  sudo apt install -yq software-properties-common git nano curl wget
  e_success "Core packages installed"
}

###########################################################################
# Install Python
###########################################################################

install_python() {
  e_title "Installing Python"

  sudo apt install -yq python-minimal python-apt python-pip python-simplejson

  e_info "Python version: $(python -V 2>&1) installed."
  e_success "Python installed"
}

###########################################################################
# Install Ansible
###########################################################################

install_ansible() {
  e_title "Installing Ansible"

  local ansible_version="latest"

  if [[ "${ansible_version}" = "latest" ]]; then
    e_info "Installing Ansible via PPA"

    if ! grep -q "ansible/ansible" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
      sudo apt-add-repository -y ppa:ansible/ansible
      sudo apt update
      sudo apt install -yq  ansible
    fi

  else
    e_info "Installing Ansible via Pip"
    sudo pip install "ansible==${ansible_version}"
  fi

  e_info "Ansible version: $(ansible --version) installed."
  e_success "Ansible installed"
}

###########################################################################
# Run Playbook
###########################################################################

run_playbook() {
  e_title "Cloning playbook repo"

  # Cloning the ansible playbook
  if [[ ! -d "$GIT_DEST" ]]; then
    mkdir -p $GIT_DEST
    git clone --recursive $GIT_REPO $GIT_DEST
  fi

  # Install dependencies if they exist
  if [[ -f $GIT_DEST/requirements.yml ]]; then
    e_title "Installing playbook dependencies"
    ansible-galaxy install --roles-path $GIT_DEST/roles -r $GIT_DEST/requirements.yml --force
  fi

  # Check for ansible vault
  if [[ -f $GIT_DEST/vault.yml ]] || [[ -f $GIT_DEST/vars/vault.yml ]]; then
    local VAULT_CMD="--vault-id @prompt"
  else
    local VAULT_CMD=""
  fi

  # Build the playbook command
  local PLAYBOOK_CMD="ansible-playbook -i "$GIT_DEST"/hosts "$GIT_DEST"/playbook.yml -K $VAULT_CMD"

  # Run playbook prompt
  e_prompt "Would you like to run the playbook now? (y/n):"
  read RUN_PLAYBOOK

  if [ "$RUN_PLAYBOOK" = "y" ] || [ "$RUN_PLAYBOOK" = "Y" ]; then
    e_title "Running the playbook"
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
# Setup Chrx
# https://chrx.org/
# https://github.com/reynhout/chrx
###########################################################################

chrx_start() {

  local CHRX_USERNAME="chrx"
  local CHRX_HOSTNAME="chrx"
  local CHRX_LOCALE="en_US.UTF-8"
  local CHRX_TZ="America/New_York"

  e_prompt "What is your username? ($CHRX_USERNAME):"
  read PROMPT_USER

  e_prompt "What is your hostname? ($CHRX_HOSTNAME):"
  read PROMPT_HOST

  e_prompt "What is your locale? ($CHRX_LOCALE):"
  read PROMPT_LOCALE

  e_prompt "What is your timezone? ($CHRX_TZ):"
  read PROMPT_TZ

  if [[ !  -z  $PROMPT_USER  ]]; then CHRX_USERNAME=${PROMPT_USER}; fi
  if [[ !  -z  $PROMPT_HOST  ]]; then CHRX_HOSTNAME=${PROMPT_HOST}; fi
  if [[ !  -z  $PROMPT_LOCALE  ]]; then CHRX_LOCALE=${PROMPT_LOCALE}; fi
  if [[ !  -z  $PROMPT_TZ  ]]; then CHRX_TZ=${PROMPT_TZ}; fi

  cd ; curl -Os https://chrx.org/go && sh go -U ${CHRX_USERNAME} -H ${CHRX_HOSTNAME} -L ${CHRX_LOCALE} -Z ${CHRX_TZ}

}

###########################################################################
# Program Start
###########################################################################

if [[ -f /etc/lsb-release ]]; then
  if [[ $(cat /etc/lsb-release | grep "CHROMEOS_RELEASE_NAME=Chrome OS" -c) = 1 ]]; then
    e_success "Running chrx installer....."
    chrx_start
  elif [[ $(cat /etc/lsb-release | grep "DISTRIB_ID=Ubuntu" -c) = 1 ]]; then
    e_success "Running GalliumOS bootstrap script....."
    install_core
    install_python
    install_ansible
    run_playbook
  else
    e_error "Cannot identify operating system. Aborting..."
    exit 1
else
  e_error "LSB Release file does not exist. Aborting..."
  exit 1
fi
