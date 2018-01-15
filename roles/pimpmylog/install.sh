#! /usr/bin/env bash
set -e
###########################################################################
#
# PimpMyLog Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/pimpmylog
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/pimpmylog/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/pimpmylog"

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
# Install PimpMyLog
# http://pimpmylog.com/
#
# http://pimpmylog.com/getting-started/quick-start.html
###########################################################################

install_pimpmylog() {
  e_title "Installing PimpMyLog"

  sudo git clone https://github.com/potsky/PimpMyLog.git /var/www/html/pimpmylog
  sudo chmod -R 0777 /var/www/html/pimpmylog/
  sudo systemctl restart apache2

  e_success "PimpMyLog installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_pimpmylog
}

program_start
