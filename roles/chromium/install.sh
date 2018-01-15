#! /usr/bin/env bash
set -e
###########################################################################
#
# Chromium Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/chromium
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/chromium/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/chromium"

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
# Install Chromium
# https://www.chromium.org/Home
#
# http://www.chromium.org/administrators/linux-quick-start
# http://www.chromium.org/administrators/policy-list-3
# https://www.chromium.org/administrators/configuring-other-preferences
# http://www.chromium.org/developers/how-tos/run-chromium-with-flags
# https://askubuntu.com/questions/743894/how-do-i-automatically-apply-the-same-theme-to-chromium-for-all-new-users
# https://decentraleyes.org/configure-https-everywhere/
# https://www.linuxbabe.com/ubuntu/install-google-chrome-ubuntu-16-04-lts
# http://www.pontikis.net/blog/setup-google-chrome-on-ubuntu-16.04
# https://developer.chrome.com/extensions/external_extensions
# https://www.eff.org/deeplinks/2015/11/guide-chromebook-privacy-settings-students
# https://decentraleyes.org/configure-https-everywhere/
###########################################################################

install_chromium() {
  e_title "Installing Chromium"

  local chromium_files=${GIT_RAW}/files

  local chromium_extensions=(
    cjpalhdlnbpafiamejdnhcphjbkeiagm # uBlock
    pgdnlhfefecpicbbihgmbmffkjpaplco # uBlock extra
    hdokiejnpimakedhajhdlcegeplioahd # Lastpass
    # nngceckbapebfimnlniiiahkandclblb # Bitwarden
    bcjindcccaagfpapjjmafapmmgkkhgoa # JSON Formatter
    fhbjgbiflinjbdggehcddcbncdddomop # Postman
    bhlhnicpbhignbdhedgjhgdocnmhomnp # ColorZilla
    gcbommkclmclpchllfjekcdonpmejbdp # HTTPs Everywhere
    pkehgijcmpdhfbdbbnkijodmdjhbjlgp # Privacy Badger
    ldpochfccmkkmhdbclfhpagapcfdljkj # DecentralEyes
  )

  # Install Chromium
  sudo apt-get install -yq \
  chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg-extra

  # Configure chromium preferences
  if [[ -d "${HOME}/.config/chromium/Default"  ]]; then
    rm -r "${HOME}/.config/chromium/Default"
  fi
  mkdir -p "${HOME}/.config/chromium/Default"
  cp "${chromium_files}/Preferences" "${HOME}/.config/chromium/Default"

  # Configure chromium policies
  if [[ ! -d "/etc/chromium-browser/policies/recommended" ]]; then
    sudo mkdir -p "/etc/chromium-browser/policies/recommended"
  fi
  sudo cp "${chromium_files}/user-policy.json" "/etc/chromium-browser/policies/recommended"

  # Configure chromium extensions
  if [[ ! -d "/usr/share/chromium-browser/extensions" ]]; then
    sudo mkdir -p "/usr/share/chromium-browser/extensions"
  fi

  for i in ${chromium_extensions}; do
    sudo cp "${chromium_files}/extension.json" "/usr/share/chromium-browser/extensions/$i.json"
  done

  e_success "Chromium installed"
}

###########################################################################
# Install Chrome
# https://www.google.com/chrome/
#
# https://www.linuxbabe.com/ubuntu/install-google-chrome-ubuntu-16-04-lts
# http://www.pontikis.net/blog/setup-google-chrome-on-ubuntu-16.04
# https://developer.chrome.com/extensions/external_extensions
# https://www.eff.org/deeplinks/2015/11/guide-chromebook-privacy-settings-students
# https://decentraleyes.org/configure-https-everywhere/
###########################################################################

install_chrome() {
  e_title "Installing Chrome"

  local chrome_files="${SCRIPT_PATH}/files/chrome"

  local chrome_extensions=(
    cjpalhdlnbpafiamejdnhcphjbkeiagm # uBlock
    hdokiejnpimakedhajhdlcegeplioahd # Lastpass
    # nngceckbapebfimnlniiiahkandclblb # Bitwarden
    gcbommkclmclpchllfjekcdonpmejbdp # HTTPs Everywhere
    pkehgijcmpdhfbdbbnkijodmdjhbjlgp # Privacy Badger
    ldpochfccmkkmhdbclfhpagapcfdljkj # DecentralEyes
  )

  # Install google-chrome
  wget -qO - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
  sudo apt-get update
  sudo apt-get install -yq google-chrome-stable

  # Configure chrome preferences
  if [[ -d "${HOME}/.config/google-chrome/Default"  ]]; then
    rm -r "${HOME}/.config/google-chrome/Default"
  fi
  mkdir -p "${HOME}/.config/google-chrome/Default"
  cp "${chrome_files}/Preferences" "${HOME}/.config/google-chrome/Default"

  # Configure chrome extensions
  if [[ ! -d "/usr/share/google-chrome/extensions/ " ]]; then
    sudo mkdir -p "/usr/share/google-chrome/extensions/ "
  fi

  for i in ${chrome_extensions}; do
    sudo cp "${chrome_files}/extension.json" "/usr/share/google-chrome/extensions/ /$i.json"
  done

  e_success "Chrome installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_chromium
}

program_start
