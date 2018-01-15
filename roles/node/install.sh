#! /usr/bin/env bash
set -e
###########################################################################
#
# Node Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/node
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/node/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/node"

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
# Install Node
# https://nodejs.org
###########################################################################

install_node() {
  e_title "Installing Node"

  local node_files=${GIT_RAW}/files
  local node_install_type="ppa"

  # Run node installer
  if [[ "${node_install_type}" = "nvm" ]]; then
    install_nvm
    install_npm
  elif [[ "${node_install_type}" = "ppa" ]]; then
    install_nodeppa
    configure_npm
    install_npm
  else
    install_nodeapt
    configure_npm
    install_npm
  fi

  e_success "Node installed"
}

###########################################################################
# Install Node via PPA
# https://nodejs.org/en/download/package-manager/
# https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04
# http://nodesource.com/blog/installing-node-js-tutorial-ubuntu/
###########################################################################

install_nodeppa() {
  e_title "Installing Node via PPA"

  # Install dependencies
  sudo apt update
  sudo apt install -yq build-essential libssl-dev apt-transport-https

  # Install nodesource PPA
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  sudo apt install -yq nodejs

  e_info "Node.js version: $(node -v) installed."
}

###########################################################################
# Install Node via Node Version Manager (NVM)
# https://github.com/creationix/nvm
# https://gist.github.com/d2s/372b5943bce17b964a79
# https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04
###########################################################################

install_nvm() {
  e_title "Installing Node via NVM"

  # Install dependencies
  sudo apt update
  sudo apt install -yq build-essential libssl-dev

  # Run installation script
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
  source ~/.profile

  # Install latest node LTS
  nvm install v8.9.1
  nvm install --lts=boron

  # Set default node version
  nvm alias default v8.9.1
  nvm use default

  e_info "NVM version: $(command -v nvm) installed."
  e_info "Node.js version: $(node -v) installed."

}

###########################################################################
# Install Node via APT Packages
###########################################################################

install_nodeapt() {
  e_title "Installing Node via APT"

  # Install node packages
  sudo apt install -yq nodejs npm

  e_info "Node.js version: $(node -v) installed."
}

###########################################################################
# Configure NPM
# https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md
###########################################################################

configure_npm() {
  e_title "Configuring NPM"

  # Set NPM permissions
  if [[ "$(npm config get prefix)" = "/usr/local" ]]; then
    e_info "NPM config prefix: $(npm config get prefix)"

    sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}

  elif [[ "$(npm config get prefix)" = "/usr" ]]; then
    e_info "NPM config prefix: $(npm config get prefix)"

    # Create a directory for global packages
    if [ ! -d "${HOME}/.npm-packages" ]; then
      mkdir "${HOME}/.npm-packages"
      npm config set prefix "${HOME}/.npm-packages"
    fi

    # Indicate to npm where to store globally installed packages
    if [ ! -f "${HOME}/.npmrc" ]; then
      echo 'prefix=${HOME}/.npm-packages' | tee ${HOME}/.npmrc
    fi

    # Ensure npm will find installed binaries and man pages
    echo 'NPM_PACKAGES="${HOME}/.npm-packages"' | tee -a ${HOME}/.profile
    echo 'PATH="$NPM_PACKAGES/bin:$PATH"' | tee -a ${HOME}/.profile
    echo 'unset MANPATH' | tee -a ${HOME}/.profile
    echo 'export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"' | tee -a ${HOME}/.profile
    source ${HOME}/.profile
  fi

  e_info "NPM config prefix: $(npm config get prefix)"
}

###########################################################################
# Install Global Node Packages
###########################################################################

install_npm() {
  e_title "Installing Global Node Packages"

  # Update NPM
  npm install npm --global

  # Install global NPM packages
  npm install -g gulp-cli
  npm install -g bower
  # npm install -g yarn
  npm install -g grunt-cli
  npm install -g browser-sync
  npm install -g webpack
  npm install -g webpack-dev-server
  npm install -g yo
  npm install -g less
  npm install -g node-sass
  npm install -g jslint
  # npm install -g npm-check-updates
  # npm install -g phantomjs-prebuilt
  # npm install -g casperjs
  # npm install -g simplehttpserver
  # npm install -g xlsx
  # npm install -g webfont-dl
  # npm install -g diff-so-fancy

  # List global NPM packages
  npm -g list -depth=0
}

###########################################################################
# Install Yarn
# https://yarnpkg.com/en/
#
# https://yarnpkg.com/en/docs/install
###########################################################################

install_yarn() {
  e_title "Installing Yarn"

  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  sudo apt-get update
  sudo apt-get install -yq yarn

  e_info "Yarn version: $(yarn --version) installed."

}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_node
}

program_start
