#! /usr/bin/env bash
set -e
###########################################################################
#
# Redis Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/redis
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/redis/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/redis"

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
# Install Redis
# https://redis.io/
#
# https://www.rosehosting.com/blog/how-to-install-configure-and-use-redis-on-ubuntu-16-04/
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04
###########################################################################

install_redis() {
  e_title "Installing Redis"

  if ! grep -q "chris-lea/redis-server" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding Redis PPA......."
    sudo apt-add-repository -y ppa:chris-lea/redis-server
    sudo apt-get update
  fi

  sudo apt-get install -yq redis-server

  e_success "Redis installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_redis
}

program_start
