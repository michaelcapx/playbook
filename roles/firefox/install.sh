#! /usr/bin/env bash
set -e
###########################################################################
#
# Firefox Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/firefox
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/firefox/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/firefox"

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
# Install Firefox
# https://www.mozilla.org/en-US/firefox/
#
# https://github.com/pyllyukko/user.js
# https://github.com/ghacksuserjs/ghacks-user.js
# https://gist.github.com/eddiejaoude/0076739fe610189581d0
# https://askubuntu.com/questions/73474/how-to-install-firefox-addon-from-command-line-in-scripts
# https://github.com/NicolasBernaerts/ubuntu-scripts/tree/master/mozilla
# https://developer.mozilla.org/en-US/docs/Mozilla/Command_Line_Options#User_Profile
# https://leotindall.com/tutorial/locking-down-firefox/
# https://www.bestvpn.com/make-firefox-secure-using-aboutconfig/
# https://gist.github.com/haasn/69e19fc2fe0e25f3cff5
# https://github.com/gunnersson/my_Mozilla_settings
###########################################################################

install_firefox() {
  e_title "Installing Firefox"

  local firefox_files=${GIT_RAW}/files

  # Install firefox dependencies
  sudo apt-get install -yq python-xmltodict python-requests

  # Install firefox
  sudo apt-get install -yq firefox firefox-locale-en

  # Configure global firefox preferences
  sudo wget -O /etc/firefox/firefox.js https://raw.githubusercontent.com/pyllyukko/user.js/5f3a460167fcfb8e4d4152b03c319fd002de8dc0/user.js
  sudo sed -i "s/user_pref(/pref(/" /etc/firefox/firefox.js

  # Configure firefox preferences
  # cp -rf "${firefox_files}/prefs.js" "${HOME}/.mozilla/firefox/8bn4t8tt.default"

  # Install firefox extensions script
  sudo wget --header='Accept-Encoding:none' -O /usr/local/bin/mozilla-extension-manager https://raw.githubusercontent.com/NicolasBernaerts/ubuntu-scripts/master/mozilla/mozilla-extension-manager
  sudo chmod +x /usr/local/bin/mozilla-extension-manager

  # uBlock Origin
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/794480/ublock_origin-1.14.20-an+fx.xpi

  # HTTPS Everywhere
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/784111/https_everywhere-2017.11.21-an+fx.xpi

  # Lastpass
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/800645/lastpass_password_manager-4.2.3.20-an+fx.xpi

  # Bitwarden
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/794852/bitwarden_free_password_manager-1.22.0-fx.xpi

  # User-Agent Switcher
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/759731/user_agent_switcher-0.2.0-an+fx.xpi

  # Privacy Badger
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/782402/privacy_badger-2017.11.20-an+fx.xpi

  # Decentraleyes
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/774252/decentraleyes-2.0.1-an+fx.xpi

  # Google search link fix
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/696544/google_search_link_fix-1.6.5-an+fx.xpi

  # Link Cleaner
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/671858/link_cleaner-1.5-an+fx.xpi

  # HTTPS by default
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/797370/https_by_default-0.4.3-an+fx.xpi

  # NoScript Security Suite
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/805796/noscript_security_suite-10.1.5.6-an+fx.xpi

  # CanvasBlocker
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/770443/canvasblocker-0.4.2-an+fx.xpi

  # Firefox Lightbeam
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/740362/firefox_lightbeam-2.0.4-an+fx-linux.xpi

  # uMatrix
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/802894/umatrix-1.1.18-an+fx.xpi

  # Smart Referer
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/738809/smart_referer-0.2.3-an+fx.xpi

  # Violentmonkey
  mozilla-extension-manager --user --install https://addons.mozilla.org/firefox/downloads/file/797312/violentmonkey-2.8.22-an+fx.xpi

  e_info "Firefox version: $(firefox -v) installed."
  e_success "Firefox installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_firefox
}

program_start