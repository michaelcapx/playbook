#! /usr/bin/env bash
set -e
###########################################################################
#
# Admin Installer
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/michaelcapx/playbook/master/roles/admin/install.sh | bash
#
###########################################################################

if [ `id -u` = 0 ]; then
  printf "\033[1;31mThis script must NOT be run as root\033[0m\n" 1>&2
  exit 1
fi

###########################################################################
# Constants and Global Variables
###########################################################################

readonly GIT_REPO="https://github.com/michaelcapx/playbook.git"
readonly GIT_RAW="https://raw.githubusercontent.com/michaelcapx/playbook/master"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_error()   { echo -e "\033[1;31m✖  $@\033[0m";     }      # red
function e_success() { echo -e "\033[1;32m✔  $@\033[0m";     }      # green
function e_info()    { echo -e "\033[1;34m$@\033[0m";        }      # blue
function e_title()   { echo -e "\033[1;35m$@.......\033[0m"; }      # magenta

###########################################################################
# Setup User Accounts
# http://manpages.ubuntu.com/manpages/trusty/man1/chfn.1.html
# http://manpages.ubuntu.com/manpages/trusty/man8/usermod.8.html
# http://manpages.ubuntu.com/manpages/zesty/man1/xdg-user-dirs-update.1.html
# https://www.computerhope.com/unix/chfn.htm
###########################################################################

start_install() {
  e_title "Setting up user account"

  local user_fullname=""

  # Change user fingerprint
  sudo chfn -f ${user_fullname} ${USER}

  # Add user groups
  usermod -a -G adm,sudo,cdrom,dip,plugdev,lpadmin,www-data ${USER}

  # Print user ID
  id $USER

  # Print user groups
  groups $USER

  # Configure XDG directories
  xdg-user-dirs-update --set DESKTOP ${HOME}/Desktop
  xdg-user-dirs-update --set DOWNLOAD ${HOME}/Downloads
  xdg-user-dirs-update --set TEMPLATES ${HOME}/
  xdg-user-dirs-update --set PUBLICSHARE ${HOME}/Public
  xdg-user-dirs-update --set DOCUMENTS ${HOME}/Documents
  xdg-user-dirs-update --set MUSIC ${HOME}/
  xdg-user-dirs-update --set PICTURES ${HOME}/
  xdg-user-dirs-update --set VIDEOS ${HOME}/
  xdg-user-dirs-update

  rm -rf ${HOME}/Templates
  rm -rf ${HOME}/Music
  rm -rf ${HOME}/Pictures
  rm -rf ${HOME}/Videos

  e_success "User accounts setup"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  start_install
}

program_start
