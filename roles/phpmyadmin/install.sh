#! /usr/bin/env bash
set -e
###########################################################################
#
# PHPMyAdmin Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/phpmyadmin
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/phpmyadmin/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/phpmyadmin"

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
# Install PHPMyAdmin
# https://www.phpmyadmin.net/
#
# https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-16-04
###########################################################################

install_phpmyadmin() {
  e_title "Installing PHPMyAdmin"

  if ! grep -q "nijel/phpmyadmin" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:nijel/phpmyadmin
    sudo apt-get update
  fi

  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password secret'
  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/password-confirm password secret'
  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password secret'
  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/setup-password password secret'
  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password secret'
  sudo apt-get install -yq phpmyadmin

  sudo phpenmod mcrypt
  sudo phpenmod mbstring

  sudo systemctl restart apache2

  e_success "PHPMyAdmin installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_phpmyadmin
}

program_start
