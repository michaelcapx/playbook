#! /usr/bin/env bash
set -e
###########################################################################
#
# PHP Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/php
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/php/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/php"

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
# Install PHP
# https://secure.php.net/
#
# https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04
###########################################################################

install_php() {
  e_title "Installing PHP"

  local php_files=${GIT_RAW}/files

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
    php7.1-common
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
    php7.1-mongodb
    php7.1-mysql
    php7.1-opcache
    php7.1-pgsql
    php7.1-readline
    php7.1-redis
    php7.1-soap
    php7.1-sqlite3
    php7.1-xdebug
    php7.1-xml
    php7.1-xmlrpc
    php7.1-yaml
    php7.1-zip
    php-xdebug
    php-pear
  )

  # Install PHP Packages
  sudo apt-get install -yq --allow-downgrades --allow-remove-essential --allow-change-held-packages "${php_pkgs[@]}"

  # Set Apache DirectoryIndex
  sudo sed -i "s/ index.php / /" /etc/apache2/mods-enabled/dir.conf
  sudo sed -i "s/index.html /index.php index.html /" /etc/apache2/mods-enabled/dir.conf
  sudo systemctl restart apache2
  # sudo systemctl status apache2

  # Set Some PHP CLI Settings
  sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/cli/php.ini
  sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/cli/php.ini
  sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/cli/php.ini
  sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/cli/php.ini

  # Set Some PHP Apache Settings
  sudo sed -i "s/error_reporting = .*/error_reporting = E_COMPILE_ERROR | E_RECOVERABLE_ERROR | E_ERROR | E_CORE_ERROR/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/max_input_time = .*/max_input_time = 30/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/;error_log = syslog/error_log = \/var\/log\/php\/error.log/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/apache2/php.ini

  # Configure PHP Xdebug options
  echo 'xdebug.remote_enable = 1' | sudo tee --append /etc/php/7.1/mods-available/xdebug.ini > /dev/null
  echo 'xdebug.remote_connect_back = 1' | sudo tee --append /etc/php/7.1/mods-available/xdebug.ini > /dev/null
  echo 'xdebug.remote_port = 9000' | sudo tee --append /etc/php/7.1/mods-available/xdebug.ini > /dev/null
  echo 'xdebug.max_nesting_level = 512' | sudo tee --append /etc/php/7.1/mods-available/xdebug.ini > /dev/null

  # Configure PHP Opcache options
  echo 'opcache.revalidate_freq = 0' | sudo tee --append /etc/php/7.1/mods-available/opcache.ini > /dev/null

  # Create the log directory for PHP and give ownership to the Apache system user
  sudo mkdir /var/log/php
  sudo chown www-data /var/log/php
  sudo touch /var/log/php/error.log
  sudo chmod -R 0755 /var/log/php/

  # Disable XDebug On The CLI
  sudo phpdismod -s cli xdebug

  # Setup Permissions
  sudo chown -R www-data:www-data /var/www

  # Setup Info page
  sudo touch /var/www/html/info.php
  echo '<?php phpinfo(); ?>' | sudo tee --append /var/www/html/info.php > /dev/null

  # Restart Apache
  sudo systemctl restart apache2

  e_success "PHP installed"
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
  chmod +x wp-cli.phar
  sudo mv wp-cli.phar /usr/local/bin/wp

  e_success "WP-cli installed"
}


###########################################################################
# Program Start
###########################################################################

program_start() {
  install_php
}

program_start
