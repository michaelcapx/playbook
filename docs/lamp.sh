#!/bin/bash

###########################################################################
#
# LAMP Bootstrap
# https://github.com/michaelcapx/playbook/docs/lamp.sh
#
# Command:
# sudo ./lamp.sh
#
###########################################################################

export DEBIAN_FRONTEND=noninteractive

###########################################################################
# Constants and Global Variables
###########################################################################

readonly MACHINE_USER="$(who am i | awk '{print $1}')"

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
# Update System Packages
###########################################################################

update_system() {
  e_header "Updating System......."
  sudo apt-get -y update
  sudo apt-get -y upgrade
  sudo apt-get install -y software-properties-common curl
}

###########################################################################
# Install Apache
###########################################################################

install_apache() {
  e_header "Installing Apache......."
  sudo apt-get install -y apache2
}

###########################################################################
# Install MySQL
###########################################################################

install_mysql() {
  e_header "Installing MySQL......."
}

###########################################################################
# Install PHP
###########################################################################

install_php() {
  e_header "Installing PHP......."

  if ! grep -q "ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding PHP PPA......."
    sudo apt-add-repository -y ppa:ondrej/php
    sudo apt-get update
  fi
}

###########################################################################
# Install Composer
###########################################################################

install_composer() {
  e_header "Installing Composer......."
}

###########################################################################
# Install Node
###########################################################################

install_node() {
  e_header "Installing Node......."
}

###########################################################################
# Install Redis
###########################################################################

install_redis() {
  e_header "Installing Redis......."

  if ! grep -q "chris-lea/redis-server" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding Redis PPA......."
    sudo apt-add-repository -y ppa:chris-lea/redis-server
    sudo apt-get update
  fi
}

###########################################################################
# Program Start
###########################################################################

setup_lamp() {
  update_system
  install_apache
  install_mysql
  install_php
  install_composer
  install_node
  install_redis
}

setup_lamp
