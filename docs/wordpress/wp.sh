#!/bin/bash

###########################################################################
#
# WordPress Project Installer
# https://github.com/michaelcapx/playbook/docs/wordpress/wordpress.sh
#
# https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lamp-on-ubuntu-16-04
# https://www.linode.com/docs/websites/cms/install-wordpress-on-ubuntu-16-04
#
# Command:
# sudo bash wordpress.sh
#
###########################################################################

export DEBIAN_FRONTEND=noninteractive

###########################################################################
# Constants and Global Variables
###########################################################################

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

readonly PROJECTNAME="wptest"
readonly PROJECTPATH="/home/$USER/Public"
readonly DBUSER="homestead"
readonly DBPASS="secret"
readonly DBNAME="wptest"

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
# Install Prompts
###########################################################################

install_prompts() {

  if ! [[ -v PROJECTNAME ]]; then
    e_prompt "What is the name of your project?: "
    read PROJECTNAME
    PROJECTNAME=${PROJECTNAME:-machina}
  else
    e_error "The project name is set to: $PROJECTNAME"
  fi

  if ! [[ -v PROJECTPATH ]]; then
    e_prompt "Where would you like to install the project?: "
    read PROJECTPATH
    PROJECTPATH=${PROJECTPATH:-/home/$USER/Public}
  else
    e_error "The project path is set to: $PROJECTPATH"
  fi

  if ! [[ -v DBNAME ]]; then
    e_prompt "What is the MySQL database?: "
    read DBNAME
    DBNAME=${DBNAME:-machina}
  else
    e_error "The database is set to: $DBNAME"
  fi

  if ! [[ -v DBUSER ]]; then
    e_prompt "Who is the MySQL user?: "
    read DBUSER
    DBUSER=${DBUSER:-homestead}
  else
    e_error "The db user is set to: $DBUSER"
  fi

  if ! [[ -v DBPASS ]]; then
    e_prompt "What is the MySQL password?: "
    read DBPASS
    DBPASS=${DBPASS:-secret}
  else
    e_error "The db password is set to: $DBPASS"
  fi
}



###########################################################################
# Apache Config
###########################################################################

apache_config() {
  e_header "Configure Apache......."

  if ! [ -f /etc/apache2/sites-available/wordpress.conf ]; then
    if [ -f $SCRIPT_DIR/wordpress.conf ]; then
      sudo cp $SCRIPT_DIR/wordpress.conf /etc/apache2/sites-available/wordpress.conf
    else
      e_error "Apache config template does not exist!"
      exit 1
    fi
  fi

  if [ -f /etc/apache2/sites-available/wordpress.conf ]; then
    sudo cp /etc/apache2/sites-available/wordpress.conf /etc/apache2/sites-available/$PROJECTNAME.conf
    sudo sed -i "s#{{ PROJECTNAME }}#$PROJECTNAME#" /etc/apache2/sites-available/$PROJECTNAME.conf
    sudo sed -i "s#{{ PROJECTPATH }}#$PROJECTPATH#" /etc/apache2/sites-available/$PROJECTNAME.conf
    sudo a2ensite $PROJECTNAME.conf
    sudo systemctl restart apache2
  else
    e_error "Apache config file does not exist!"
    exit 1
  fi

  # echo "127.0.0.1      $PROJECTNAME.dev" | sudo tee --append /etc/hosts > /dev/null
  echo -e "127.0.0.1\t$PROJECTNAME.dev" | sudo tee --append /etc/hosts > /dev/null
}

###########################################################################
# Create MySQL Database
###########################################################################

create_database() {
  e_header "Creating MySQL Database......."

  local MYSQL_WARN="mysql: [Warning] Using a password on the command line interface can be insecure."

  MYSQL_USER_EXISTS="$(mysql --user="root" --password="secret" -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$DBUSER')" 2>/dev/null | grep -v "$MYSQL_WARN")"
  MYSQL_DB_EXISTS="$(mysql --user="root" --password="secret" --skip-column-names -e "SHOW DATABASES LIKE '$DBNAME'" 2>/dev/null | grep -v "$MYSQL_WARN")"

  # Create the database user
  if ! [ $MYSQL_USER_EXISTS = 1 ]; then
    e_header "Creating database user $DBUSER"
    mysql --user="root" --password="secret" -e "CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS';" 2>/dev/null | grep -v "$MYSQL_WARN"
  else
    e_error "Database user $DBUSER already exists!"
  fi

  # Create the database
  if [ "$MYSQL_DB_EXISTS" == "$DBNAME" ]; then
    e_error "Database $DBNAME already exists!"
  else
    e_header "Creating database $DBNAME"
    mysql --user="root" --password="secret" -e "CREATE DATABASE $DBNAME DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" 2>/dev/null | grep -v "$MYSQL_WARN"
    mysql --user="root" --password="secret" -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost';" 2>/dev/null | grep -v "$MYSQL_WARN"
    mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;" 2>/dev/null | grep -v "$MYSQL_WARN"
  fi

}

###########################################################################
# Install WordPress
###########################################################################

install_wordpress() {

  local WP_INSTALL=$PROJECTPATH/$PROJECTNAME

  # Download WordPress
  wget -P /tmp https://wordpress.org/latest.tar.gz
  tar xzvf /tmp/latest.tar.gz -C $PROJECTPATH && mv $PROJECTPATH/wordpress  $WP_INSTALL

  # Create .htaccess
  touch $WP_INSTALL/.htaccess
  chmod 660 $WP_INSTALL/.htaccess

  # Edit WordPress config file
  cp $WP_INSTALL/wp-config-sample.php $WP_INSTALL/wp-config.php
  sed -i "s/database_name_here/$DBNAME/" $WP_INSTALL/wp-config.php
  sed -i "s/username_here/$DBUSER/" $WP_INSTALL/wp-config.php
  sed -i "s/password_here/$DBPASS/" $WP_INSTALL/wp-config.php

  # Create Directories
  mkdir $WP_INSTALL/wp-content/upgrade
  mkdir $WP_INSTALL/wp-content/uploads

  # Adjust Permissions
  sudo chown -R $USER:www-data $WP_INSTALL
  # sudo chown -R www-data:www-data $WP_INSTALL
  sudo find $WP_INSTALL -type d -exec chmod g+s {} \;
  sudo chmod g+w $WP_INSTALL/wp-content
  sudo chmod -R g+w $WP_INSTALL/wp-content/themes
  sudo chmod -R g+w $WP_INSTALL/wp-content/plugins

}

###########################################################################
# Program Start
###########################################################################

setup_wordpress() {
  install_prompts
  apache_config
  create_database
  install_wordpress
}

setup_wordpress
