#! /usr/bin/env bash
set -e
###########################################################################
#
# Test Suite
# https://github.com/polymimetic/playbook
#
###########################################################################

if [[ $EUID -eq 0 ]]; then
  echo "This script must NOT be run as root" 1>&2
  exit 1
fi

###########################################################################
# Constants and Global Variables
###########################################################################

readonly LINUX_MTYPE="$(uname -m)"                   # x86_64
readonly LINUX_ID="$(lsb_release -i -s)"             # Ubuntu
readonly LINUX_CODENAME="$(lsb_release -c -s)"       # xenial
readonly LINUX_RELEASE="$(lsb_release -r -s)"        # 16.04
readonly LINUX_DESCRIPTION="$(lsb_release -d -s)"    # GalliumOS 2.1
readonly LINUX_DESKTOP="$(printenv DESKTOP_SESSION)" # xfce
readonly LINUX_USER="$(who am i | awk '{print $1}')" # user

readonly GIT_USER="polymimetic"
readonly GIT_REPO="playbook"
readonly GIT_URL="https://github.com/${GIT_USER}/${GIT_REPO}.git"
readonly GIT_RAW="https://raw.github.com/${GIT_USER}/${GIT_REPO}/master/"
readonly GIT_DEST="$HOME/Downloads/${GIT_REPO}"

readonly SCRIPT_SOURCE="${BASH_SOURCE[0]}"
readonly SCRIPT_PATH="$( cd -P "$( dirname "${SCRIPT_SOURCE}" )" && pwd )"
readonly SCRIPT_NAME="$(basename "$SCRIPT_SOURCE")"

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
function e_output()  { printf "$@\n"; }

###########################################################################
# Test Suite
###########################################################################

test_suite() {
  e_title "Starting TestSuite"
  e_success "TestSuite Complete!"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  test_suite
}

program_start
