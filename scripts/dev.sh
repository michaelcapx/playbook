#! /usr/bin/env bash
set -e
###########################################################################
#
# Dev Bootstrap Installer
# https://github.com/michaelcapx/playbook/scripts/dev.sh
#
# This script is used to quickly install some development tools without
# running the full ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/michaelcapx/playbook/master/scripts/dev.sh | bash
#
###########################################################################

if [[ $EUID -eq 0 ]]; then
  echo "$(tput bold)$(tput setaf 1)This script must NOT be run as root$(tput sgr0)" 1>&2
  exit 1
fi

###########################################################################
# Constants and Global Variables
###########################################################################

# Machine constants
readonly LINUX_MTYPE="$(uname -m)"                   # x86_64
readonly LINUX_ID="$(lsb_release -i -s)"             # Ubuntu
readonly LINUX_CODENAME="$(lsb_release -c -s)"       # xenial
readonly LINUX_RELEASE="$(lsb_release -r -s)"        # 16.04
readonly LINUX_DESCRIPTION="$(lsb_release -d -s)"    # GalliumOS 2.1
readonly LINUX_DESKTOP="$(printenv DESKTOP_SESSION)" # xfce
readonly LINUX_USER="$(who am i | awk '{print $1}')" # user

# Git variables
readonly GIT_USER="michaelcapx"
readonly GIT_REPO="playbook"
readonly GIT_URL="https://github.com/${GIT_USER}/${GIT_REPO}.git"
readonly GIT_RAW="https://raw.github.com/${GIT_USER}/${GIT_REPO}/master/"

# Script variables
readonly SCRIPT_SOURCE="${BASH_SOURCE[0]}"
readonly SCRIPT_PATH="$( cd -P "$( dirname "${SCRIPT_SOURCE}" )" && pwd )"
readonly SCRIPT_NAME="$(basename "$SCRIPT_SOURCE")"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_header()  { echo -e "\033[1;30m===== $@ =====\033[0m"; }      # grey
function e_error()   { echo -e "\033[1;31m✖  $@\033[0m";          }      # red
function e_success() { echo -e "\033[1;32m✔  $@\033[0m";          }      # green
function e_warn()    { echo -e "\033[1;33m⚠  $@\033[0m";          }      # yellow
function e_info()    { echo -e "\033[1;34m$@\033[0m";             }      # blue
function e_title()   { echo -e "\033[1;35m$@.......\033[0m";      }      # magenta
function e_prompt()  { echo -e "\033[1;36m$@ \033[0m";            }      # cyan

###########################################################################
# Generate SSH Keys
###########################################################################

generate_ssh() {
  e_title "Generating SSH Keys"

  if [[ ! -f "~/.ssh/id_rsa" ]]; then
    ssh-keygen -t rsa -b 4096 -C "${GIT_EMAIL}" -N "" -f "~/.ssh/id_rsa"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
  fi

  e_success "SSH Keys generated"
}

###########################################################################
# Setup GitHub Account
###########################################################################

setup_github() {
  e_title "Setup Github"

  # Install git packages
  sudo apt-get install -yq git

  # Configure Git
  git config --global user.name "${GIT_NAME}"
  git config --global user.email "${GIT_EMAIL}"
  git config --global github.user "${GIT_USER}"
  git config --global core.editor nano
  git config --global push.default simple

  # Set git SSH key registration script
  if [[ ! -f "/usr/local/bin/ssh-keyreg" ]]; then
    sudo sh -c "curl https://raw.githubusercontent.com/b4b4r07/ssh-keyreg/master/bin/ssh-keyreg -o /usr/local/bin/ssh-keyreg && chmod +x /usr/local/bin/ssh-keyreg"
  fi

  # Add SSH keys to GitHub & Bitbucket
  if [[ -f "~/.ssh/id_rsa.pub" ]] && [[ ${GIT_PASS} != "" ]]; then
    ssh-keyreg --path ~/.ssh/id_rsa.pub --user ${GIT_USER}:${GIT_PASS} github
  fi

  e_success "GitHub setup complete"
}

###########################################################################
# Install Sublime Text
###########################################################################

install_sublime() {
  e_title "Installing Sublime Text"

  if ! subl --version >/dev/null 2>&1; then
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo apt install apt-transport-https
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt update
    sudo apt install -yq sublime-text
  else
    e_error "Sublime Text already installed"
  fi

  e_info "Sublime Text version: $(subl --version 2>&1) installed."
  e_success "Sublime Text installed"
}

###########################################################################
# Development Start
###########################################################################

dev_start() {
  e_header "Running Development Setup"

  e_prompt "What is your name?:"
  read GIT_NAME

  e_prompt "What is your email?:"
  read GIT_EMAIL

  e_prompt "What is your GitHub username?:"
  read GIT_USER

  e_prompt "What is your GitHub password?:"
  read GIT_PASS

  generate_ssh
  setup_github
  install_sublime
}

dev_start
