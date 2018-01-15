#! /usr/bin/env bash
set -e
###########################################################################
#
# XFCE Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/xfce
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/xfce/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/xfce"

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
# Install XFCE
###########################################################################

install_xfce() {
  e_title "Installing XFCE"

  local xfce_files=${GIT_RAW}/files

  # Create GTK bookmarks
  if [[ -f "${HOME}/.config/gtk-3.0/bookmarks" ]]; then
    rm "${HOME}/.config/gtk-3.0/bookmarks"
  fi

  touch "${HOME}/.config/gtk-3.0/bookmarks"
  echo "file://${HOME}/Documents" | tee -a ${HOME}/.config/gtk-3.0/bookmarks
  echo "file://${HOME}/Downloads" | tee -a ${HOME}/.config/gtk-3.0/bookmarks
  echo "file://${HOME}/Public" | tee -a ${HOME}/.config/gtk-3.0/bookmarks

  # Create GTK file chooser
  if [[ -f "${HOME}/.config/gtk-2.0/gtkfilechooser.ini" ]]; then
    rm "${HOME}/.config/gtk-2.0/gtkfilechooser.ini"
  fi

  # Configure GTK file chooser
  cp "${xfce_files}/gtkfilechooser.ini" "${HOME}/.config/gtk-2.0"

  # Copy profile face
  cp "${xfce_files}/.face" "${HOME}"

  # Delete panel config directory
  if [[ -d "${HOME}/.config/xfce4/panel" ]]; then
    rm -rf "${HOME}/.config/xfce4/panel"
  fi

  mkdir -p "${HOME}/.config/xfce4/panel"

  # Clone weather icons
  git clone https://github.com/kevlar1818/xfce4-weather-mono-icons ${HOME}/.cache/xfce4-weather-mono-icons
  cp ${HOME}/.cache/xfce4-weather-mono-icons/WSky-Light /usr/share/xfce4/weather/icons
  cp ${HOME}/.cache/xfce4-weather-mono-icons/WSky /usr/share/xfce4/weather/icons
  cp "${xfce_files}/weather.rc" "${HOME}/.config/xfce4/panel/weather-13.rc"

  # Setup whiskermenu
  sudo cp "${xfce_files}/ubuntu-logo-menu.png" "/usr/share/pixmaps/ubuntu-logo-menu.png"
  cp "${xfce_files}/whiskermenu.rc" "${HOME}/.config/xfce4/panel/whiskermenu-7.rc"

  # Create panel launchers
  mkdir -p "${HOME}/.config/xfce4/panel/launcher-1"
  mkdir -p "${HOME}/.config/xfce4/panel/launcher-2"
  mkdir -p "${HOME}/.config/xfce4/panel/launcher-9"
  mkdir -p "${HOME}/.config/xfce4/panel/launcher-12"
  cp "${xfce_files}/chromium.desktop" "${HOME}/.config/xfce4/panel/launcher-1"
  cp "${xfce_files}/thunar.desktop" "${HOME}/.config/xfce4/panel/launcher-2"
  cp "${xfce_files}/sublime.desktop" "${HOME}/.config/xfce4/panel/launcher-9"
  cp "${xfce_files}/terminal.desktop" "${HOME}/.config/xfce4/panel/launcher-12"

  # Setup thunar
  xfconf-query -c thunar -p /last-view -n -t string -s ThunarIconView
  xfconf-query -c thunar -p /last-icon-view-zoom-level -n -t string -s THUNAR_ZOOM_LEVEL_NORMAL
  xfconf-query -c thunar -p /last-separator-position -n -t int -s 170
  xfconf-query -c thunar -p /last-show-hidden -n -t bool -s true
  xfconf-query -c thunar -p /misc-single-click -n -t bool -s false
  xfconf-query -c thunar -p /hidden-bookmarks -n -a -t string -s "network:///"

  # Setup panel plugins
  xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -n -a -t int -s 7 -t int -s 2 -t int -s 12 -t int -s 1 -t int -s 9 -t int -s 3 -t int -s 15 -t int -s 4 -t int -s 11 -t int -s 6 -t int -s 13 -t int -s 8 -t int -s 5
  xfconf-query -c xfce4-panel -p /plugins/plugin-3 -n -t string -s tasklist
  xfconf-query -c xfce4-panel -p /plugins/plugin-3/flat-buttons -n -t bool -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-3/window-scrolling -n -t bool -s false
  xfconf-query -c xfce4-panel -p /plugins/plugin-3/show-handle -n -t bool -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-15 -n -t string -s separator
  xfconf-query -c xfce4-panel -p /plugins/plugin-15/expand -n -t bool -s true
  xfconf-query -c xfce4-panel -p /plugins/plugin-15/style -n -t uint -s 0
  xfconf-query -c xfce4-panel -p /plugins/plugin-4 -n -t string -s pager
  xfconf-query -c xfce4-panel -p /plugins/plugin-4/rows -n -t uint -s 1
  xfconf-query -c xfce4-panel -p /plugins/plugin-4/workspace-scrolling -n -t bool -s false
  xfconf-query -c xfce4-panel -p /plugins/plugin-5 -n -t string -s clock
  xfconf-query -c xfce4-panel -p /plugins/plugin-5/digital-format -n -t string -s "%I:%M %p"
  xfconf-query -c xfce4-panel -p /plugins/plugin-5/timezone -n -t string -s "America/New_York"
  xfconf-query -c xfce4-panel -p /plugins/plugin-6 -n -t string -s systray
  xfconf-query -c xfce4-panel -p /plugins/plugin-6/show-frame -n -t bool -s false
  xfconf-query -c xfce4-panel -p /plugins/plugin-6/size-max -n -t uint -s 26
  xfconf-query -c xfce4-panel -p /plugins/plugin-7 -n -t string -s whiskermenu
  xfconf-query -c xfce4-panel -p /plugins/plugin-8 -n -t string -s power-manager-plugin
  xfconf-query -c xfce4-panel -p /plugins/plugin-11 -n -t string -s separator
  xfconf-query -c xfce4-panel -p /plugins/plugin-11/style -n -t uint -s 0
  xfconf-query -c xfce4-panel -p /plugins/plugin-1 -n -t string -s launcher
  xfconf-query -c xfce4-panel -p /plugins/plugin-1/items -n -a -t string -s chromium.desktop
  xfconf-query -c xfce4-panel -p /plugins/plugin-2 -n -t string -s launcher
  xfconf-query -c xfce4-panel -p /plugins/plugin-2/items -n -a -t string -s thunar.desktop
  xfconf-query -c xfce4-panel -p /plugins/plugin-12 -n -t string -s launcher
  xfconf-query -c xfce4-panel -p /plugins/plugin-12/items -n -a -t string -s terminal.desktop
  xfconf-query -c xfce4-panel -p /plugins/plugin-9 -n -t string -s launcher
  xfconf-query -c xfce4-panel -p /plugins/plugin-9/items -n -a -t string -s sublime.desktop
  xfconf-query -c xfce4-panel -p /plugins/plugin-13 -n -t string -s weather

  # Misc xfconf settings
  xfconf-query -c xfce4-power-manager -p /show-tray-icon -n -t int -s 0
  xfconf-query -c xfce4-session -p /compat/LaunchGNOME -n -t bool -s true

  # Restart xfce panel
  xfce4-panel --restart

  e_success "XFCE installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_xfce
}

program_start
