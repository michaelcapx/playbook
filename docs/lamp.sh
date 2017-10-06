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

  # Set global ServerName
  echo 'ServerName localhost' | sudo tee --append /etc/apache2/apache2.conf > /dev/null
  sudo apache2ctl configtest

  # Configure MPM Prefork
  sudo sed -i "s/StartServers\s\{2,\}[0-9]*/StartServers       4/" /etc/apache2/mods-available/mpm_prefork.conf
  sudo sed -i "s/MinSpareServers\s\{2,\}[0-9]*/MinSpareServers     3/" /etc/apache2/mods-available/mpm_prefork.conf
  sudo sed -i "s/MaxSpareServers\s\{2,\}[0-9]*/MaxSpareServers    40/" /etc/apache2/mods-available/mpm_prefork.conf
  sudo sed -i "s/MaxRequestWorkers\s\{2,\}[0-9]*/MaxRequestWorkers   200/" /etc/apache2/mods-available/mpm_prefork.conf
  sudo sed -i "s/MaxConnectionsPerChild\s\{2,\}[0-9]*/MaxConnectionsPerChild   10000/" /etc/apache2/mods-available/mpm_prefork.conf

  # Disable the event module and enable prefork
  sudo a2dismod mpm_event
  sudo a2enmod mpm_prefork

  # Enable Apache mod_rewrite
  sudo a2enmod rewrite

  # Restart Apache
  sudo systemctl restart apache2
}

###########################################################################
# Install MySQL
###########################################################################

install_mysql() {
  e_header "Installing MySQL......."

  # Install MySQL
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password secret'
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password secret'
  sudo apt-get install -y mysql-server

  # Configure MySQL Password Lifetime
  echo 'default_password_lifetime = 0' | sudo tee --append /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null

  # Setup root MySQL user
  mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO root@localhost IDENTIFIED BY 'secret' WITH GRANT OPTION;"
  sudo service mysql restart

  # Create main MySQL user
  mysql --user="root" --password="secret" -e "CREATE USER 'homestead'@'localhost' IDENTIFIED BY 'secret';"
  mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'homestead'@'localhost' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
  mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
  mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"
  mysql --user="root" --password="secret" -e "CREATE DATABASE homestead character set UTF8mb4 collate utf8mb4_bin;"
  sudo service mysql restart

  # Add Timezone Support To MySQL
  # mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=secret mysql
}

###########################################################################
# Install PHP
###########################################################################

install_php() {
  e_header "Installing PHP......."

  # Add PHP PPA
  if ! grep -q "ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding PHP PPA......."
    sudo apt-add-repository -y ppa:ondrej/php
    sudo apt-get update
  fi

  php_pkgs=(
    php7.1
    libapache2-mod-php7.1
    # php7.1-apcu
    php7.1-bcmath
    php7.1-bz2
    php7.1-cgi
    php7.1-cli
    # php7.1-common
    php7.1-curl
    php7.1-dev
    # php7.1-fpm
    php7.1-gd
    php7.1-intl
    php7.1-imagick
    php7.1-imap
    php7.1-json
    php7.1-ldap
    php7.1-mbstring
    php7.1-mcrypt
    php7.1-memcached
    # php7.1-mongodb
    php7.1-mysql
    # php7.1-opcache
    php7.1-pgsql
    php7.1-readline
    # php7.1-redis
    php7.1-soap
    php7.1-sqlite3
    # php7.1-xdebug
    php7.1-xml
    php7.1-xmlrpc
    php7.1-yaml
    php7.1-zip
    php-xdebug
    php-pear
  )

  # Install PHP Packages
  sudo apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages "${php_pkgs[@]}"
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
