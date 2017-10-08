#!/bin/bash

###########################################################################
#
# Project Uninstaller
# https://github.com/michaelcapx/playbook/docs/uninstall.sh
#
# Command:
# sudo bash uninstall.sh /path/to/project/name dbname
#
###########################################################################

export DEBIAN_FRONTEND=noninteractive

###########################################################################
# Constants and Global Variables
###########################################################################

# PROJECTPATH="/home/$USER/Public/testproject"
# DBNAME="dbtest"

PROJECTPATH=$1
DBNAME=$2
PROJECTNAME="$(echo $PROJECTPATH | awk -F/ '{print $NF}')"

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
# Build Variables
###########################################################################

build_vars() {

  if [[ -z "$PROJECTPATH" ]]; then
    e_prompt "What is the path to your project?: "
    read PROJECTPATH
    PROJECTPATH=${PROJECTPATH:-/home/$USER/Public/testproject}
    PROJECTNAME="$(echo $PROJECTPATH | awk -F/ '{print $NF}')"
  fi

  if [[ -z "$DBNAME" ]]; then
    e_prompt "What is the name to your database?: "
    read DBNAME
    DBNAME=${DBNAME:-$PROJECTNAME}
  fi

  e_info "Project Name: $PROJECTNAME"
  e_info "Project Path: $PROJECTPATH"
  e_info "Database Name: $DBNAME"

  e_prompt "Would you like to delete the project now? (y/n): "
  read DEL_PROJECT

  if [ "$DEL_PROJECT" = "n" ] || [ "$DEL_PROJECT" = "N" ]; then
    exit
  fi
}

###########################################################################
# Drop Database
###########################################################################

drop_database() {
  e_header "Dropping Database......."
  local MYSQL_WARN="mysql: [Warning] Using a password on the command line interface can be insecure."
  mysql --user="root" --password="secret" -e "DROP DATABASE IF EXISTS $DBNAME;" 2>/dev/null | grep -v "$MYSQL_WARN"
}

###########################################################################
# Drop Apache Config
###########################################################################

drop_apache() {
  e_header "Dropping Apache Config......."
  sudo a2dissite $PROJECTNAME.conf
  sudo systemctl restart apache2

  if [ -f /etc/apache2/sites-available/$PROJECTNAME.conf ]; then
    sudo rm /etc/apache2/sites-available/$PROJECTNAME.conf
  fi

  sudo sed -i "/127.0.0.1[[:space:]]*$PROJECTNAME.dev/d" /etc/hosts
}

###########################################################################
# Install WordPress
###########################################################################

drop_files() {
  e_header "Removing Files......."

  if [[ -d "$PROJECTPATH" ]]; then
    sudo rm -r $PROJECTPATH
  else
    e_error "Project already deleted!"
    exit 1
  fi
}

###########################################################################
# Program Start
###########################################################################

uninstall_project() {
  build_vars
  drop_database
  drop_apache
  drop_files
}

uninstall_project

