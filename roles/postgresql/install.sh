#! /usr/bin/env bash
set -e
###########################################################################
#
# PostgreSQL Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/postgresql
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/postgresql/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/postgresql"

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
# Install PostgreSQL
# https://www.postgresql.org/
#
# https://gorails.com/setup/ubuntu/16.04
###########################################################################

install_postgresql() {
  e_title "Installing PostgreSQL"

  sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
  wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

  sudo apt-get update
  sudo apt-get install -yq postgresql-common
  sudo apt-get install -yq postgresql-9.5 libpq-dev

  sudo -u postgres createuser $USER -s

  # If you would like to set a password for the user, you can do the following
  # sudo -u postgres psql
  # postgres=# \password $USER

  e_success "PostgreSQL installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_postgresql
}

program_start
