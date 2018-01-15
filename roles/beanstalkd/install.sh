#! /usr/bin/env bash
set -e
###########################################################################
#
# Beanstalkd Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/beanstalkd
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/beanstalkd/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/beanstalkd"

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
# Install Beanstalkd
# https://github.com/kr/beanstalkd
#
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-beanstalkd-work-queue-on-a-vps
###########################################################################

install_beanstalkd() {
  e_title "Installing Beanstalkd"

  sudo apt-get install -yq beanstalkd

  # Configure Beanstalkd
  sudo sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
  sudo /etc/init.d/beanstalkd start

  e_success "Beanstalkd installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_beanstalkd
}

program_start
