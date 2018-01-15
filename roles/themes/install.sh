#! /usr/bin/env bash
set -e
###########################################################################
#
# Themes Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/themes
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/themes/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/themes"

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
# Install Themes
###########################################################################

install_themes() {
  e_title "Installing Themes"

  local themes_files=${GIT_RAW}/files

  # Install theme dependencies
  sudo apt-get install -yq autoconf automake gtk2-engines-murrine gtk2-engines-pixbuf libgtk-3-dev optipng

  # Install arc theme
  git clone https://github.com/alexwaibel/arc-grey-flatabulous-theme ${HOME}/.cache/arc-theme
  cd ${HOME}/.cache/arc-theme
  ./autogen.sh --prefix=/usr --disable-transparency --disable-dark --disable-cinnamon --disable-gnome-shell --with-gnome=3.18
  sudo make install
  # cd ${PWD}
  rm -rf ${HOME}/.cache/arc-theme

  # Set theme settings
  xfconf-query -c xfwm4 -p /general/theme -n -t string -s "Arc-Grey-Flatabulous-Darker"
  xfconf-query -c xsettings -p /Net/ThemeName -n -t string -s "Arc-Grey-Flatabulous-Darker"
  xfconf-query -c xsettings -p /Net/IconThemeName -n -t string -s "Numix-Circle-GalliumOS"
  xfconf-query -c xsettings -p /Gtk/CursorThemeName -n -t string -s "DMZ-Black"
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -n -t string -s "/usr/share/xfce4/backdrops/Untitled_0026_by_Mike_Sinko.jpg"

  # Set notify settings
  xfconf-query -c xfce4-notifyd -p /notify-location -n -t uint -s 2
  xfconf-query -c xfce4-notifyd -p /theme -n -t string -s "Numix"
  xfconf-query -c xfce4-notifyd -p /expire-timeout -n -t int -s 3

  e_success "Themes installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_themes
}

program_start
