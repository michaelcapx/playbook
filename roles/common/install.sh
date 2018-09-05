#! /usr/bin/env bash
set -e
###########################################################################
#
# Common Installer
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/michaelcapx/playbook/master/roles/common/install.sh | bash
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
# Install Common
###########################################################################

start_install() {
  e_title "Installing Common"

  # Update & upgrade linux
  sudo apt -y update && time sudo apt -y upgrade

  # Remove apt packages
  pkg_remove=(
    xterm
    xscreensaver
    simple-scan
  )

  sudo apt purge -y "${pkg_remove[@]}"

  # Cleanup packages
  sudo apt clean -y

  # Install dependencies
  pkg_deps=(
    software-properties-common
    git
    ssh
    curl
    nano
    sudo
    wget
  )

  sudo apt install -y "${pkg_deps[@]}"

  # Install base packages
  pkg_base=(
    apt-transport-https
    build-essential
    unattended-upgrades
    dos2unix
    gcc
    htop
    libglib2.0-dev
    libmcrypt4
    libpcre3-dev
    make
    mcrypt
    ntp
    pwgen
    pv
    re2c
    supervisor
    whois
    vim
  )

  sudo apt install -y "${pkg_base[@]}"

  # Install archive packages
  pkg_archive=(
    arj
    bzip2
    cabextract
    gzip
    mpack
    p7zip-full
    p7zip-rar
    rar
    sharutils
    tar
    unace
    unrar
    unzip
    uudeview
    zip
  )

  sudo apt install -y "${pkg_archive[@]}"

  # Install disk packages
  pkg_disk=(
    cifs-utils
    exfat-utils
    exfat-fuse
    ntfs-3g
  )

  sudo apt install -y "${pkg_disk[@]}"

  e_success "Common installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  start_install
}

program_start
