#! /usr/bin/env bash
set -e
###########################################################################
#
# Apache Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/apache
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/apache/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/apache"

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
# Install Apache
# http://www.apache.org/
#
# https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04
# https://www.linode.com/docs/web-servers/lamp/install-lamp-stack-on-ubuntu-16-04
###########################################################################

install_apache() {
  e_title "Installing Apache"

  local apache_files=${GIT_RAW}/files

  # Install apache packages
  sudo apt-get install -yq \
  apache2 apache2-utils apachetop

  # Set global ServerName
  echo 'ServerName localhost' | sudo tee --append /etc/apache2/apache2.conf > /dev/null
  sudo apache2ctl configtest

  # Configure MPM Prefork
  sudo sed -i "s/StartServers\s\{2,\}[0-9]*/StartServers       4/" /etc/apache2/mods-available/mpm_prefork.conf
  sudo sed -i "s/MinSpareServers\s\{2,\}[0-9]*/MinSpareServers     3/" /etc/apache2/mods-available/mpm_prefork.conf
  sudo sed -i "s/MaxSpareServers\s\{2,\}[0-9]*/MaxSpareServers    40/" /etc/apache2/mods-available/mpm_prefork.conf
  sudo sed -i "s/MaxRequestWorkers\s\{2,\}[0-9]*/MaxRequestWorkers   200/" /etc/apache2/mods-available/mpm_prefork.conf
  sudo sed -i "s/MaxConnectionsPerChild\s\{2,\}[0-9]*/MaxConnectionsPerChild   10000/" /etc/apache2/mods-available/mpm_prefork.conf

  # Set nicer permissions on Apache log directory
  sudo chmod -R 0755 /var/log/apache2/

  # Disable the event module and enable prefork
  sudo a2dismod mpm_event
  sudo a2enmod mpm_prefork

  # Enable Apache mod_rewrite
  sudo a2enmod rewrite

  # Restart Apache
  sudo systemctl restart apache2

  e_success "Apache installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_apache
}

program_start
