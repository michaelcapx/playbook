#! /usr/bin/env bash
set -e
###########################################################################
#
# MySQL Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/mysql
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/mysql/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/mysql"

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
# Install MySQL
# https://www.mysql.com/
#
# https://gorails.com/setup/ubuntu/16.04
###########################################################################

install_mysql() {
  e_title "Installing MySQL"

  local mysql_files=${GIT_RAW}/files

  # Install MySQL
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password secret'
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password secret'
  sudo apt-get install -yq mysql-server mysql-client libmysqlclient-dev

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

  e_success "MySQL installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_mysql
}

program_start
