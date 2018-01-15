#! /usr/bin/env bash
set -e
###########################################################################
#
# Ruby Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/ruby
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/ruby/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/ruby"

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
# Install Ruby
# https://www.ruby-lang.org/en/
#
# https://gorails.com/setup/ubuntu/16.04
# https://www.ruby-lang.org/en/documentation/installation/
###########################################################################

install_ruby() {
  e_title "Installing Ruby"

  local ruby_files=${GIT_RAW}/files

  local ruby_install_type="rbenv"

  local ruby_deps=(
    git-core
    curl
    zlib1g-dev
    build-essential
    libssl-dev
    libreadline-dev
    libyaml-dev
    libsqlite3-dev
    sqlite3
    libxml2-dev
    libxslt1-dev
    libcurl4-openssl-dev
    python-software-properties
    libffi-dev
  )

  # Install ruby dependencies
  sudo apt-get install -yq "${ruby_deps[@]}"

  # Run ruby installer
  if [[ "${ruby_install_type}" = "rbenv" ]]; then
    install_rbenv
  elif [[ "${ruby_install_type}" = "rvm" ]]; then
    install_rvm
  elif [[ "${ruby_install_type}" = "ppa" ]]; then
    install_rubyppa
  elif [[ "${ruby_install_type}" = "source" ]]; then
    install_rubysource
  else
    install_rubyapt
  fi

  # Install ruby gems
  gem install bundler
  gem install rails:5.1.4
  gem install sass
  gem install boom

  # Rehash rbenv
  if [[ "${ruby_install_type}" = "rbenv" ]]; then
    rbenv rehash
  fi

  e_success "Ruby installed"
}

###########################################################################
# Install Rbenv
# https://github.com/rbenv/rbenv
###########################################################################

install_rbenv() {
  e_title "Installing Ruby via Rbenv"

  # Clone rbenv
  git clone https://github.com/rbenv/rbenv.git ${HOME}/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ${HOME}/.bashrc
  echo 'eval "$(rbenv init -)"' >> ${HOME}/.bashrc
  exec $SHELL

  # Clone rbenv build
  git clone https://github.com/rbenv/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ${HOME}/.bashrc
  exec $SHELL

  # Install rbenv version
  rbenv install 2.4.2
  rbenv global 2.4.2

  e_info "Rbenv version: $(ruby -v) installed."
}

###########################################################################
# Install Ruby Version Manager (RVM)
# https://rvm.io/
###########################################################################

install_rvm() {
  e_title "Installing Ruby via RVM"

  # Install rvm dependencies
  sudo apt-get install -yq libgdbm-dev libncurses5-dev automake libtool bison libffi-dev

  # Install rvm script
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io | bash -s stable
  source ${HOME}/.rvm/scripts/rvm

  # Install rvm version
  rvm install 2.4.2
  rvm use 2.4.2 --default

  e_info "RVM version: $(ruby -v) installed."
}

###########################################################################
# Install Ruby via PPA
# https://www.brightbox.com/docs/ruby/ubuntu/
###########################################################################

install_rubyppa() {
  e_title "Installing Ruby via PPA"

  # Adding the repository
  sudo apt-add-repository ppa:brightbox/ruby-ng
  sudo apt-get update

  # Install ruby packages
  sudo apt-get install -yq ruby2.4 ruby2.4-dev ruby-switch
  sudo ruby-switch --set ruby2.4

  e_info "Ruby version: $(ruby -v) installed."
}

###########################################################################
# Install Ruby via Source
# https://www.ruby-lang.org/
###########################################################################

install_rubysource() {
  e_title "Installing Ruby via source"

  # Create tmp directory
  local TMPDIR=$(mktemp -d)
  cd $TMPDIR

  # Download ruby tarball
  wget -q http://ftp.ruby-lang.org/pub/ruby/2.4/ruby-2.4.2.tar.gz
  tar -zxf ruby-2.4.2.tar.gz
  cd ruby-2.4.2

  # Make ruby install
  ./configure
  make
  sudo make install

  # Remove tmp directory
  rm -rf $TMPDIR

  e_info "Ruby version: $(ruby -v) installed."
}

###########################################################################
# Install Ruby via APT
# https://www.ruby-lang.org/
###########################################################################

install_rubyapt() {
  e_title "Installing Ruby via APT"

  sudo apt-get install -yq ruby-full rubygems

  e_info "Ruby version: $(ruby -v) installed."
}


###########################################################################
# Program Start
###########################################################################

program_start() {
  install_ruby
}

program_start
