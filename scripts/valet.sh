#! /usr/bin/env bash
set -e
###########################################################################
#
# Valet Setup Script
# https://github.com/michaelcapx/playbook/scripts/valet.sh
#
# This script is used to install Laravel Valet
# https://github.com/cpriego/valet-linux
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/michaelcapx/playbook/master/scripts/valet.sh | bash
#
###########################################################################

if [[ $EUID -eq 0 ]]; then
  echo "$(tput bold)$(tput setaf 1)This script must NOT be run as root$(tput sgr0)" 1>&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

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
readonly GIT_USER="michaelcapx"
readonly GIT_REPO="playbook"
readonly GIT_URL="https://github.com/${GIT_USER}/${GIT_REPO}.git"
readonly GIT_RAW="https://raw.github.com/${GIT_USER}/${GIT_REPO}/master/"

# Script variables
readonly SCRIPT_SOURCE="${BASH_SOURCE[0]}"
readonly SCRIPT_PATH="$( cd -P "$( dirname "${SCRIPT_SOURCE}" )" && pwd )"
readonly SCRIPT_NAME="$(basename "$SCRIPT_SOURCE")"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_header()  { echo -e "\033[1;30m===== $@ =====\033[0m"; }      # grey
function e_error()   { echo -e "\033[1;31m✖  $@\033[0m";          }      # red
function e_success() { echo -e "\033[1;32m✔  $@\033[0m";          }      # green
function e_warn()    { echo -e "\033[1;33m⚠  $@\033[0m";          }      # yellow
function e_info()    { echo -e "\033[1;34m$@\033[0m";             }      # blue
function e_title()   { echo -e "\033[1;35m$@.......\033[0m";      }      # magenta
function e_prompt()  { echo -e "\033[1;36m$@ \033[0m";            }      # cyan

###########################################################################
# Pre Install
###########################################################################

pre_install() {
  e_header "Start Your Engines"

  sudo apt-get -y update
  sudo apt-get -y upgrade
  sudo apt-get install -y software-properties-common curl

  sudo usermod -a -G www-data $USER
  id $USER
  groups $USER
}

###########################################################################
# Install MySQL
# https://www.mysql.com/
#
# https://gorails.com/setup/ubuntu/16.04
###########################################################################

install_mysql() {
  e_title "Installing MySQL"

  # Install MySQL
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
  sudo apt-get install -yq mysql-common mysql-server mysql-client libmysqlclient-dev python-mysqldb mytop

  # Configure MySQL Password Lifetime
  echo 'default_password_lifetime = 0' | sudo tee --append /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null

  sudo sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

  # Setup root MySQL user
  mysql --user="root" --password="root" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'root' WITH GRANT OPTION;"
  sudo service mysql restart

  # Create main MySQL user
  mysql --user="root" --password="root" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
  mysql --user="root" --password="root" -e "GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
  mysql --user="root" --password="root" -e "GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
  mysql --user="root" --password="root" -e "FLUSH PRIVILEGES;"
  sudo service mysql restart

  e_success "MySQL installed"
}

###########################################################################
# Install PHP
# https://secure.php.net/
#
# https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04
###########################################################################

install_php() {
  e_title "Installing PHP"

  # Add PHP PPA
  if ! grep -q "ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_title "Adding PHP PPA"
    sudo apt-add-repository -y ppa:ondrej/php
    sudo apt-get update
  fi

  php_pkgs=(
    php7.1
    php7.1-bcmath
    php7.1-bz2
    php7.1-cgi
    php7.1-cli
    php7.1-common
    php7.1-curl
    php7.1-dev
    php7.1-gd
    php7.1-intl
    php7.1-imagick
    php7.1-imap
    php7.1-json
    php7.1-ldap
    php7.1-mbstring
    php7.1-mcrypt
    php7.1-mysql
    php7.1-opcache
    php7.1-readline
    php7.1-soap
    php7.1-sqlite3
    php7.1-xdebug
    php7.1-xml
    php7.1-xmlrpc
    php7.1-yaml
    php7.1-zip
    php-pear
  )

  # Install PHP Packages
  sudo apt-get install -yq --allow-downgrades --allow-remove-essential --allow-change-held-packages "${php_pkgs[@]}"

  # Set Some PHP CLI Settings
  sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/cli/php.ini
  sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/cli/php.ini
  sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/cli/php.ini
  sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/cli/php.ini

  # Disable XDebug On The CLI
  sudo phpdismod -s cli xdebug

  e_success "PHP installed"
}

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

  echo "export PATH=$HOME/.composer/vendor/bin:\$PATH" >> ${HOME}/.bashrc
  source ${HOME}/.bashrc

  # Require Global Composer Packages
  composer global require "laravel/installer"
  composer global require "laravel/envoy"
  composer global require "cpriego/valet-linux"

  e_success "Composer installed"
}

###########################################################################
# Install WP-cli
# http://wp-cli.org/
#
# https://make.wordpress.org/cli/handbook/installing/
###########################################################################

install_wpcli() {
  e_title "Installing WP-cli"

  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  sudo chmod +x wp-cli.phar
  sudo mv wp-cli.phar /usr/local/bin/wp

  e_success "WP-cli installed"
}

###########################################################################
# Install SQLite
# https://www.sqlite.org/
#
# https://linuxhint.com/install-sqlite-ubuntu-linux-mint/
###########################################################################

install_sqlite() {
  e_title "Installing SQLite"

  # Install SQLite
  sudo apt-get install -yq sqlite3 libsqlite3-dev

  e_success "SQLite installed"
}

###########################################################################
# Install Adminer
# https://www.adminer.org/
#
# http://www.ubuntuboss.com/how-to-install-adminer-on-ubuntu/
###########################################################################

install_adminer() {
  e_title "Installing Adminer"

  sudo mkdir /usr/share/adminer
  sudo wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php
  sudo ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php

  e_success "Adminer installed"
}

###########################################################################
# Post Install
###########################################################################

post_install() {
  e_header "Cleaning Up"
  sudo apt-get -y upgrade
  sudo apt-get -y autoremove
  sudo apt-get -y clean
}

###########################################################################
# Program Start
###########################################################################

lamp_start() {
  e_header "Running LAMP Setup"

  pre_install
  install_mysql
  install_php
  install_composer
  install_wpcli
  install_sqlite
  install_adminer
  post_install
}

lamp_start
