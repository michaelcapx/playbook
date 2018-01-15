#! /usr/bin/env bash
set -e
###########################################################################
#
# Composer Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/composer
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/composer/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/composer"

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
# Install Composer
# https://getcomposer.org/
#
# https://getcomposer.org/doc/00-intro.md#installation-linux-unix-osx
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-composer-on-ubuntu-16-04
###########################################################################

install_composer() {
  e_title "Installing Composer"

  # Install Composer
  curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
  sudo chown -Rv $USER ${HOME}/.composer

  # Add Composer Global Bin To Path
  echo "export PATH=$HOME/.composer/vendor/bin:\$PATH" >> ${HOME}/.bashrc
  source ${HOME}/.bashrc

  # Require Global Composer Packages
  composer global require "laravel/installer=~1.1"
  composer global require "laravel/envoy=~1.0"
  composer global require "phpunit/phpunit=@stable"
  composer global require "phpunit/dbunit=@stable"
  # composer global require "phpdocumentor/phpdocumentor=@stable"
  composer global require "sebastian/phpcpd=@stable"
  composer global require "phploc/phploc=@stable"
  composer global require "phpmd/phpmd=@stable"
  composer global require "squizlabs/php_codesniffer=@stable"
  composer global require "hirak/prestissimo=^0.3"
  composer global require "friendsofphp/php-cs-fixer=@stable"
  composer global require "codeception/codeception=@stable"
  composer global require "tightenco/jigsaw=@stable"

  # sudo git clone https://github.com/laravel/spark-installer.git /usr/local/share/spark-installer
  # sudo composer install -d /usr/local/share/spark-installer
  # sudo ln -s /usr/local/share/spark-installer/spark /usr/local/bin/spark

  # git clone https://github.com/laravel/spark-installer.git ${HOME}/Documents/spark
  # composer install -d ${HOME}/Documents/spark/spark
  # sudo ln -s ${HOME}/Documents/spark/spark /usr/local/bin/spark

  e_success "Composer installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_composer
}

program_start
