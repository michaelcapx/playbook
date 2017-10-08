#!/bin/bash

###########################################################################
#
# Laravel Project Installer
# https://github.com/michaelcapx/playbook/docs/laravel/laravel.sh
#
# Command:
# sudo bash laravel.sh
#
###########################################################################

export DEBIAN_FRONTEND=noninteractive

###########################################################################
# Constants and Global Variables
###########################################################################

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# readonly PROJECTNAME="laraveltest"
# readonly PROJECTPATH="/home/$USER/Public"
# readonly DBUSER="homestead"
# readonly DBPASS="secret"
# readonly DBNAME="laraveltest"
readonly MIGRATE_DB="N"

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

  if ! [[ -v MIGRATE_DB ]]; then
    e_prompt "Would you like to migrate the database? (y/n): "
    read MIGRATE_DB
    MIGRATE_DB=${MIGRATE_DB:-N}
  else
    e_error "Database migration is set to: $MIGRATE_DB"
  fi
}

###########################################################################
# Install Laravel
###########################################################################

install_laravel() {
  e_header "Installing Laravel......."

  if [[ ! -d "$PROJECTPATH/$PROJECTNAME" ]]; then
    cd $PROJECTPATH
    # composer create-project --prefer-dist laravel/laravel $PROJECTNAME
    laravel new $PROJECTNAME
  else
    e_error "Project already exists!"
    exit 1
  fi
}

###########################################################################
# Apache Config
###########################################################################

apache_config() {
  e_header "Configure Apache......."

  if ! [ -f /etc/apache2/sites-available/laravel.conf ]; then
    if [ -f $SCRIPT_DIR/laravel.conf ]; then
      sudo cp $SCRIPT_DIR/laravel.conf /etc/apache2/sites-available/laravel.conf
    else
      e_error "Apache config template does not exist!"
      exit 1
    fi
  fi

  if [ -f /etc/apache2/sites-available/laravel.conf ]; then
    sudo cp /etc/apache2/sites-available/laravel.conf /etc/apache2/sites-available/$PROJECTNAME.conf
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
# Setup Permissions
###########################################################################

setup_permissions() {
  e_header "Setting Permissions......."

  sudo chown -R www-data:www-data $PROJECTPATH/$PROJECTNAME
  sudo chmod -R 775 $PROJECTPATH/$PROJECTNAME/.
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
    mysql --user="root" --password="secret" -e "CREATE DATABASE $DBNAME character set UTF8mb4 collate utf8mb4_bin;" 2>/dev/null | grep -v "$MYSQL_WARN"
    mysql --user="root" --password="secret" -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost';" 2>/dev/null | grep -v "$MYSQL_WARN"
    mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;" 2>/dev/null | grep -v "$MYSQL_WARN"
  fi

  # Setup database credentials
  if [ -f $PROJECTPATH/$PROJECTNAME/.env ]; then
    sed -i "s/DB_DATABASE=homestead/DB_DATABASE=$DBNAME/" $PROJECTPATH/$PROJECTNAME/.env
    sed -i "s/DB_USERNAME=homestead/DB_USERNAME=$DBUSER/" $PROJECTPATH/$PROJECTNAME/.env
    sed -i "s/DB_PASSWORD=secret/DB_PASSWORD=$DBPASS/" $PROJECTPATH/$PROJECTNAME/.env
  else
    e_error "Environment file does not exists!"
    exit 1
  fi
}

###########################################################################
# Migrate Database
###########################################################################

migrate_database() {

  local MIGRATE_CMD="php artisan migrate"

  cd $PROJECTPATH/$PROJECTNAME

  if [ "$MIGRATE_DB" = "y" ] || [ "$MIGRATE_DB" = "Y" ]; then
    e_header "Migrating Database......."
    $MIGRATE_CMD
  else
    echo ""
    echo "You can migrate the database at any time with:"
    e_info "$MIGRATE_CMD"
    echo ""
    exit
  fi
}


###########################################################################
# Program Start
###########################################################################

setup_laravel() {
  install_prompts
  install_laravel
  apache_config
  setup_permissions
  create_database
  migrate_database
}

setup_laravel
