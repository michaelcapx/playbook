#! /usr/bin/env bash
set -e
###########################################################################
#
# MongoDB Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/mongodb
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/mongodb/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/mongodb"

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
# Install MongoDB
# https://www.mongodb.com/
#
# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
# https://www.howtoforge.com/tutorial/install-mongodb-on-ubuntu-16.04/
# https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-16-04
###########################################################################

install_mongodb() {
  e_title "Installing MongoDB"

  # Importing the Public Key
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5

  # Create source list file MongoDB
  echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
  sudo apt-get update

  # Install MongoDB
  sudo apt-get install -yq mongodb-org

  # Start mongodb
  sudo systemctl start mongod
  sudo systemctl status mongodb
  sudo systemctl enable mongodb

  e_success "MongoDB installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_mongodb
}

program_start
