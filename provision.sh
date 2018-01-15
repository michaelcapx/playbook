#! /usr/bin/env bash

# A better class of script...
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

###########################################################################
#
# Bootstrap Installer
# https://github.com/polymimetic/playbook
#
# # Usage:
#
# wget -qO - https://raw.github.com/polymimetic/playbook/master/provision.sh | bash
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
readonly GIT_USER="polymimetic"
readonly GIT_REPO="playbook"
readonly GIT_URL="https://github.com/${GIT_USER}/${GIT_REPO}.git"
readonly GIT_RAW="https://raw.github.com/${GIT_USER}/${GIT_REPO}/master"
readonly GIT_DEST="$HOME/Downloads/playbook"

# Script variables
readonly SCRIPT_CWD="${PWD}"
readonly SCRIPT_SOURCE="${BASH_SOURCE[0]}"
readonly SCRIPT_PATH="$( cd -P "$( dirname "${SCRIPT_SOURCE}" )" && pwd )"
readonly SCRIPT_NAME="$(basename "${SCRIPT_SOURCE}")"
readonly TMPDIR="/tmp/${SCRIPT_NAME}-${RANDOM}"

# Color variables
readonly txtreset="$(tput sgr0 || true)"      # Reset
readonly txtbold="$(tput bold || true)"       # Bold
readonly txtuline="$(tput smul || true)"      # Underline
readonly txtrev="$(tput rev || true)"         # Reverse colors
readonly txtred="$(tput setaf 1 || true)"     # Red
readonly txtgreen="$(tput setaf 2 || true)"   # Green
readonly txtyellow="$(tput setaf 3 || true)"  # Yellow
readonly txtblue="$(tput setaf 4 || true)"    # Blue
readonly txtmagenta="$(tput setaf 5 || true)" # Magenta
readonly txtcyan="$(tput setaf 6 || true)"    # Cyan

# Bootstrap variables
BI_VERSION="0.1.0"

###########################################################################
# Basic Functions
###########################################################################

# Trap Functions
function err_status() { if [[ $# -eq 1 && $1 =~ ^[0-9]+$ ]]; then exit "$1"; else exit 1; fi; }
function del_tmpdir() { if [[ -d ${TMPDIR} ]]; then rm -r ${TMPDIR}; fi; }
function trap_exit()  { cd "${SCRIPT_CWD}"; printf '%b' "${txtreset}"; del_tmpdir; }
function trap_error() { trap - ERR; set +o errexit; set +o pipefail; del_tmpdir; err_status; }
function safe_exit()  { del_tmpdir; trap - INT TERM EXIT; exit; }
function die()        { echo "$@" >&2; exit 1; }

# File Checks
# Usage: if is_file "file.txt"; then some action fi
function is_exists()      { if [[ -e "$1" ]]; then return 0; fi; return 1; }
function is_not_exists()  { if [[ ! -e "$1" ]]; then return 0; fi; return 1; }
function is_file()        { if [[ -f "$1" ]]; then return 0; fi; return 1; }
function is_not_file()    { if [[ ! -f "$1" ]]; then return 0; fi; return 1; }
function is_dir()         { if [[ -d "$1" ]]; then return 0; fi; return 1; }
function is_not_dir()     { if [[ ! -d "$1" ]]; then return 0; fi; return 1; }
function is_symlink()     { if [[ -L "$1" ]]; then return 0; fi; return 1; }
function is_not_symlink() { if [[ ! -L "$1" ]]; then return 0; fi; return 1; }
function is_empty()       { if [[ -z "$1" ]]; then return 0; fi; return 1; }
function is_not_empty()   { if [[ -n "$1" ]]; then return 0; fi; return 1; }

# Type Checks
# Usage: if type_exists 'git'; then some action; else other action; fi
function type_exists()     { if [ "$(type -P "$1")" ]; then return 0; fi; return 1; }
function type_not_exists() { if [ ! "$(type -P "$1")" ]; then return 0; fi; return 1; }

# Output Echoes
# Usage: e_info "This is an info msg"
function e_error()   { echo -e "${txtbold}${txtred}✖  $@${txtreset}"; }
function e_warn()    { echo -e "${txtbold}${txtyellow}⚠  $@${txtreset}"; }
function e_success() { echo -e "${txtbold}${txtgreen}✔  $@${txtreset}"; }
function e_prompt()  { echo -e "${txtbold}${txtyellow}$@${txtreset}"; }
function e_info()    { echo -e "${txtbold}${txtblue}$@${txtreset}"; }
function e_title()   { echo -e "${txtbold}${txtmagenta}$@.......${txtreset}"; }
function e_header()  { echo -e "${txtbold}${txtcyan}===== $@ =====${txtreset}"; }
function e_output()  { printf "$@\n"; }

###########################################################################
# Usage
###########################################################################

USAGE="
bootstrap installer, version ${BI_VERSION}
Usage: $0 [ option ... ]
Options
   -b              run the full bootstrap installer
   -d              run the development setup
   -u              run the playbook utilities script
   -h              show this help
"

usage() { echo "${USAGE}"; exit; }

#
# BOOTSTRAP SCRIPTS ------------------------------------------------------------
#

###########################################################################
# Pre Installation
###########################################################################

pre_install() {
  e_title "Start your engines"

  # Update Package List
  sudo apt-get update

  # Upgrade System Packages
  sudo apt-get -y upgrade
}

###########################################################################
# Install Core Packages
###########################################################################

install_core() {
  e_title "Installing core packages"

  local core_pkgs=(
    software-properties-common
    git
    nano
    curl
    wget
  )

  # Install core packages
  sudo apt-get install -yq ${core_pkgs[@]}

  e_success "Core packages installed"
}

###########################################################################
# Post Installation
###########################################################################

post_install() {
  e_title "Finishing Up"

  sudo apt-get -y autoremove
  sudo apt-get -y clean
  sudo apt-get -y autoclean

  # sudo systemctl enable supervisor.service
  # sudo service supervisor start

  # sudo systemctl restart apache2
  # sudo systemctl restart mysql

  e_success "All Done!"
}


#
# DEV SCRIPTS ------------------------------------------------------------
#

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

#
# UTILITY SCRIPTS ------------------------------------------------------------
#

###########################################################################
# UTILITY: Compile Defaults
###########################################################################

compile_defaults() {
  cat \
    <(echo -e "---\n") \
    <(cat ../roles/*/defaults/main.yml | grep -v '^---$' | grep -v '^[[:space:]]*$') \
    > _compiled_defaults.yml
}

###########################################################################
# UTILITY: Gather Facts
###########################################################################

gather_facts() {
  ansible -m setup localhost > ansible-facts.json
}

###########################################################################
# Parse Options
###########################################################################

parse_opts() {

  local bootflag=''
  local devflag=''
  local utilflag=''

  while getopts 'bduh' flag; do
    case "${flag}" in
      b) bootflag='true' ;;
      d) devflag='true' ;;
      u) utilflag='true' ;;
      h) usage ;;
      *) e_error "Unexpected option ${flag}"; exit 1 ;;
    esac
  done

  if [ $OPTIND -eq 1 ]; then e_error "No options were passed"; fi

  # Development flag
  if [ "${devflag}" ]; then
    e_title "Running Development Setup"

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

  fi

  # Bootstrap flag
  if [ "${bootflag}" ]; then
    e_title "Running Bootstrap Installer"

    pre_install
    install_core

    for role in $(ls -d ${SCRIPT_PATH}/roles/*/); do
      # echo ${role%%/}
      bash ${role%%/}/install.sh
    done

    # bash ${SCRIPT_PATH}/roles/common/install.sh
    # bash ${SCRIPT_PATH}/roles/admin/install.sh
    # bash ${SCRIPT_PATH}/roles/ssh/install.sh
    # bash ${SCRIPT_PATH}/roles/git/install.sh
    # bash ${SCRIPT_PATH}/roles/shell/install.sh
    # bash ${SCRIPT_PATH}/roles/chromium/install.sh
    # bash ${SCRIPT_PATH}/roles/firefox/install.sh
    # bash ${SCRIPT_PATH}/roles/sublime/install.sh
    # bash ${SCRIPT_PATH}/roles/desktop/install.sh
    # bash ${SCRIPT_PATH}/roles/fonts/install.sh
    # bash ${SCRIPT_PATH}/roles/themes/install.sh
    # bash ${SCRIPT_PATH}/roles/xfce/install.sh
    # bash ${SCRIPT_PATH}/roles/docker/install.sh
    # bash ${SCRIPT_PATH}/roles/vagrant/install.sh
    # bash ${SCRIPT_PATH}/roles/apache/install.sh
    # bash ${SCRIPT_PATH}/roles/python/install.sh
    # bash ${SCRIPT_PATH}/roles/ruby/install.sh
    # bash ${SCRIPT_PATH}/roles/node/install.sh
    # bash ${SCRIPT_PATH}/roles/golang/install.sh
    # bash ${SCRIPT_PATH}/roles/php/install.sh
    # bash ${SCRIPT_PATH}/roles/mysql/install.sh
    # bash ${SCRIPT_PATH}/roles/postgresql/install.sh
    # bash ${SCRIPT_PATH}/roles/mongodb/install.sh
    # bash ${SCRIPT_PATH}/roles/couchdb/install.sh
    # bash ${SCRIPT_PATH}/roles/sqlite/install.sh
    # bash ${SCRIPT_PATH}/roles/postfix/install.sh
    # bash ${SCRIPT_PATH}/roles/mailhog/install.sh
    # bash ${SCRIPT_PATH}/roles/mailcatcher/install.sh
    # bash ${SCRIPT_PATH}/roles/composer/install.sh
    # bash ${SCRIPT_PATH}/roles/beanstalkd/install.sh
    # bash ${SCRIPT_PATH}/roles/memcached/install.sh
    # bash ${SCRIPT_PATH}/roles/redis/install.sh
    # bash ${SCRIPT_PATH}/roles/adminer/install.sh
    # bash ${SCRIPT_PATH}/roles/phpmyadmin/install.sh
    # bash ${SCRIPT_PATH}/roles/pimpmylog/install.sh
    # bash ${SCRIPT_PATH}/roles/ngrok/install.sh
    # bash ${SCRIPT_PATH}/roles/blackfire/install.sh
    # bash ${SCRIPT_PATH}/roles/dotfiles/install.sh
    # bash ${SCRIPT_PATH}/roles/projects/install.sh
    # bash ${SCRIPT_PATH}/roles/www/install.sh

    post_install

  fi

  # Utilities flag
  if [ "${utilflag}" ]; then
    e_title "Running Playbook Utilities"

    e_prompt "Would you like to compile the playbook defaults? (y/n):"
    read COMPILE_DEFAULTS

    e_prompt "Would you like to gather the playbook facts? (y/n):"
    read GATHER_FACTS

    if [ "$COMPILE_DEFAULTS" = "y" ] || [ "$COMPILE_DEFAULTS" = "Y" ]; then
      compile_defaults
    fi

    if [ "$GATHER_FACTS" = "y" ] || [ "$GATHER_FACTS" = "Y" ]; then
      gather_facts
    fi
  fi
}

###########################################################################
# Program Start
###########################################################################

main_bootstrap() {
  trap "trap_error" ERR
  trap "trap_exit" EXIT

  parse_opts "$@"
}

main_bootstrap "$@"
