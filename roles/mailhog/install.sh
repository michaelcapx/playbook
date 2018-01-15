#! /usr/bin/env bash
set -e
###########################################################################
#
# Mailhog Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/mailhog
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/mailhog/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/mailhog"

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
# Install Mailhog
# https://github.com/mailhog/MailHog
#
# https://agiletesting.blogspot.com/2016/02/setting-up-mailinator-like-test-mail.html
# https://pascalbaljetmedia.com/en/blog/setup-mailhog-with-laravel-valet
###########################################################################

install_mailhog() {
  e_title "Installing Mailhog"

  sudo wget --quiet -O /usr/local/bin/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64
  sudo chmod +x /usr/local/bin/mailhog

  sudo tee /etc/systemd/system/mailhog.service <<EOL
[Unit]
Description=Mailhog
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/bin/env /usr/local/bin/mailhog > /dev/null 2>&1 &
StandardOutput=journal
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

  # Install mhsendmail
  # go get github.com/mailhog/mhsendmail
  # sudo ln -s ~/Templates/bin/mhsendmail /usr/local/bin/mhsendmail
  # sudo ln -s ~/Templates/bin/mhsendmail /usr/local/bin/sendmail
  # sudo ln -s ~/Templates/bin/mhsendmail /usr/local/bin/mail

  sudo wget --quiet -O /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64
  sudo chmod +x /usr/local/bin/mhsendmail

  sudo sed -i "s/;sendmail_path.*/sendmail_path = \/usr\/local\/bin\/mhsendmail/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/;sendmail_path.*/sendmail_path = \/usr\/local\/bin\/mhsendmail/" /etc/php/7.1/cli/php.ini

  # Reload daemon
  sudo systemctl daemon-reload

  # Start on reboot
  sudo systemctl enable mailhog

  # Start background service now
  sudo systemctl start mailhog

  e_success "Mailhog installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_mailhog
}

program_start
