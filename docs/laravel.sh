#!/bin/bash

###########################################################################
#
# Laravel Project Installer
# https://github.com/michaelcapx/playbook/docs/laravel.sh
#
# Command:
# sudo ./laravel.sh
#
###########################################################################

export DEBIAN_FRONTEND=noninteractive

###########################################################################
# Constants and Global Variables
###########################################################################

readonly PROJECTNAME="machina"
readonly PROJECTPATH="home/$USER/Public"
readonly DBUSER="homestead"
readonly DBPASS="secret"
readonly DBNAME="machina"

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
# Install Laravel
###########################################################################

install_laravel() {
  e_header "Installing Laravel......."
  cd $PROJECTPATH
  # composer create-project --prefer-dist laravel/laravel $PROJECTNAME
  laravel new $PROJECTNAME
}

###########################################################################
# Apache Config
###########################################################################

apache_config() {
  e_header "Configure Apache......."

  if [ -f /etc/apache2/sites-available/laravel.conf ]; then
    sudo cp /etc/apache2/sites-available/laravel.conf /etc/apache2/sites-available/$PROJECTNAME.conf
    sudo sed -i "s/{{ PROJECTNAME }}/$PROJECTNAME/" /etc/apache2/sites-available/$PROJECTNAME.conf
    sudo sed -i "s/{{ PROJECTPATH }}/$PROJECTPATH/" /etc/apache2/sites-available/$PROJECTNAME.conf
    sudo a2ensite $PROJECTNAME.conf
    sudo systemctl restart apache2
  fi

  echo "127.0.0.1 $PROJECTNAME.dev" | sudo tee --append /etc/hosts > /dev/null
}

###########################################################################
# Setup Permissions
###########################################################################

setup_permissions() {
  e_header "Setting Permissions......."

  sudo chown -R www-data:www-data /$PROJECTPATH/$PROJECTNAME
  sudo chmod -R 775 /$PROJECTPATH/$PROJECTNAME/.
}

###########################################################################
# Create MySQL Database
###########################################################################

create_db() {
  e_header "Create DB......."

  # Create the Database
  # mysql --user="root" --password="secret" -e "CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS';"
  mysql --user="root" --password="secret" -e "CREATE DATABASE $DBNAME character set UTF8mb4 collate utf8mb4_bin;"
  mysql --user="root" --password="secret" -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost';"
  mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"

  # Setup database credentials
  sed -i "s/DB_DATABASE=homestead/DB_DATABASE=$DBNAME/" /$PROJECTPATH/$PROJECTNAME/.env
  sed -i "s/DB_USERNAME=homestead/DB_USERNAME=$DBUSER/" /$PROJECTPATH/$PROJECTNAME/.env
  sed -i "s/DB_PASSWORD=secret/DB_PASSWORD=$DBPASS/" /$PROJECTPATH/$PROJECTNAME/.env

}


###########################################################################
# Program Start
###########################################################################

setup_laravel() {
  install_laravel
  apache_config
  setup_permissions
  create_db
}

setup_laravel
