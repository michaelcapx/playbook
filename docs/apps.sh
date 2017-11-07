#!/bin/bash

###########################################################################
#
# LAMP Bootstrap
# https://github.com/michaelcapx/playbook/docs/lamp.sh
#
# https://www.linode.com/docs/web-servers/lamp/install-lamp-stack-on-ubuntu-16-04
# https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04
# https://gist.github.com/Otienoh/6431b247d1bddfddb12f3dda436615d0
# https://gist.github.com/edouard-lopez/10008944
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
}

###########################################################################
# Install OBS
# http://sourcedigit.com/20379-install-open-broadcaster-software-obs-studio-in-ubuntu-16-04/
###########################################################################

install_obs() {
  e_header "Installing OBS......."

  # Add OBS PPA
  if ! grep -q "obsproject/obs-studio" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding OBS Studio PPA......."
    sudo add-apt-repository -y ppa:obsproject/obs-studio
    sudo apt -y update
  fi

  # Add FFMpeg PPA
  if ! grep -q "kirillshkrogalev/ffmpeg-next" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding FFMpeg PPA......."
    sudo add-apt-repository -y ppa:kirillshkrogalev/ffmpeg-next
    sudo apt -y update
  fi

  sudo apt install -y obs-studio
  sudo apt install -y ffmpeg

}

###########################################################################
# Install Audacity
# http://ubuntuhandbook.org/index.php/2017/03/audacity-2-1-3-released/
###########################################################################

install_audacity() {
  e_header "Installing Audacity......."

  # Add Audacity PPA
  if ! grep -q "ubuntuhandbook1/audacity" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding Audacity PPA......."
    sudo add-apt-repository -y ppa:ubuntuhandbook1/audacity
    sudo apt -y update
  fi

  sudo apt install -y audacity

}

###########################################################################
# Install Blender
# http://ubuntuhandbook.org/index.php/2017/09/blender-2-79-released-install-it-in-ubuntu/
###########################################################################

install_blender() {
  e_header "Installing Blender......."

  # Add Blender PPA
  if ! grep -q "thomas-schiex/blender" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding Blender PPA......."
    sudo add-apt-repository -y ppa:thomas-schiex/blender
    sudo apt -y update
  fi

  sudo apt install -y blender

}

###########################################################################
# Install LibreOffice
# http://www.omgubuntu.co.uk/2017/07/how-to-install-libreoffice-5-4-on-ubuntu
###########################################################################

install_libreoffice() {
  e_header "Installing LibreOffice......."

  # Add LibreOffice PPA
  if ! grep -q "libreoffice/libreoffice-5-4" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding LibreOffice PPA......."
    sudo add-apt-repository -y ppa:libreoffice/libreoffice-5-4
    sudo apt -y update
  fi

  sudo apt install -y libreoffice

}

###########################################################################
# Program Start
###########################################################################

install_apps() {
  update_system
  install_obs
  install_audacity
  install_blender
  install_libreoffice
}

install_apps
