#! /usr/bin/env bash
set -e
###########################################################################
#
# Desktop Bootstrap Installer
# https://github.com/polymimetic/playbook/roles/desktop
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/playbook/master/roles/desktop/install.sh | bash
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
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/playbook/master/roles/desktop"

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
# Install Desktop
#
# https://yktoo.com/en/software/indicator-sound-switcher
# http://www.omgubuntu.co.uk/2016/09/indicator-sound-switcher-makes-switching-audio-devices-ubuntu-snap
# https://launchpad.net/caffeine
# http://www.omgubuntu.co.uk/2016/07/caffeine-indicator-applet-ubuntu-lock-screen
# https://www.keepassx.org/
# http://ubuntuhandbook.org/index.php/2015/12/install-keepassx-2-0-in-ubuntu-16-04-15-10-14-04/
# https://transmissionbt.com/
# http://www.elinuxbook.com/install-transmission-bittorrent-client-in-ubuntu-16-04/
# https://vpsguide.net/tutorials/vps-tutorials/install-transmission-torrent-client-on-ubuntu-server-and-debian/
# https://www.giuspen.com/cherrytree/
# http://sourcedigit.com/19978-install-cherrytree-text-editor-in-ubuntu-16-04/
# https://github.com/dylanaraps/neofetch
# http://www.omgubuntu.co.uk/2016/11/neofetch-terminal-system-info-app
# http://tipsonubuntu.com/2016/08/02/install-gimp-2-9-5-ubuntu-16-04/
# http://ubuntuhandbook.org/index.php/2017/01/install-inkscape-0-92-ppa-ubuntu-16-04-16-10-14-04/
# http://ubuntuhandbook.org/index.php/2017/09/blender-2-79-released-install-it-in-ubuntu/
# http://www.omgubuntu.co.uk/2017/07/how-to-install-libreoffice-5-4-on-ubuntu
# https://www.linuxhelp.com/how-to-install-obs-on-ubuntu-16-04/
# http://sourcedigit.com/20379-install-open-broadcaster-software-obs-studio-in-ubuntu-16-04/
# http://ubuntuhandbook.org/index.php/2017/03/audacity-2-1-3-released/
###########################################################################

install_desktop() {
  e_title "Installing Desktop"

  local desktop_files=${GIT_RAW}/files

  # Install desktop dependencies
  sudo apt-get install -yq xvfb

  # Add desktop PPA
  if ! grep -q "nilarimogard/webupd8" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:nilarimogard/webupd8
    sudo apt-get update
  fi

  if ! grep -q "yktooo/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:yktooo/ppa
    sudo apt-get update
  fi

  if ! grep -q "caffeine-developers/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:caffeine-developers/ppa
    sudo apt-get update
  fi

  if ! grep -q "eugenesan/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:eugenesan/ppa
    sudo apt-get update
  fi

  if ! grep -q "transmissionbt/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:transmissionbt/ppa
    sudo apt-get update
  fi

  if ! grep -q "giuspen/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:giuspen/ppa
    sudo apt-get update
  fi

  if ! grep -q "dawidd0811/neofetch" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:dawidd0811/neofetch
    sudo apt-get update
  fi

  # Add Gimp PPA
  if ! grep -q "otto-kesselgulasch/gimp" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
    sudo apt-get update
  fi

  # Add inkscape PPA
  if ! grep -q "inkscape.dev/stable" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:inkscape.dev/stable
    sudo apt-get update
  fi

  # Add Audacity PPA
  if ! grep -q "ubuntuhandbook1/audacity" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:ubuntuhandbook1/audacity
    sudo apt-get update
  fi

  # Add Blender PPA
  if ! grep -q "thomas-schiex/blender" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:thomas-schiex/blender
    sudo apt-get update
  fi

  # Add LibreOffice PPA
  if ! grep -q "libreoffice/libreoffice-5-4" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:libreoffice/libreoffice-5-4
    sudo apt-get update
  fi

  # Add OBS PPA
  if ! grep -q "obsproject/obs-studio" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:obsproject/obs-studio
    sudo apt-get update
  fi

  # Add FFMpeg PPA
  if ! grep -q "kirillshkrogalev/ffmpeg-next" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:kirillshkrogalev/ffmpeg-next
    sudo apt-get update
  fi



  sudo apt-get install -yq obs-studio
  sudo apt-get install -yq ffmpeg

  sudo apt-get install -yq audacity

  sudo apt-get install -yq neofetch

  sudo apt-get install -yq indicator-sound-switcher

  sudo apt-get install -yq caffeine

  sudo apt-get install -yq keepassx

  sudo apt-get install -yq transmission

  sudo apt-get install -yq cherrytree

  sudo apt-get install -yq libreoffice

  # Install gimp
  sudo apt-get install -yq gimp gimp-plugin-registry gimp-data-extras

  # Install inkscape
  sudo apt-get install -yq inkscape

  sudo apt-get install -yq blender

  # Install desktop GUI applications
  sudo apt-get install -yq bleachbit meld mpv

  # Install desktop CLI applications
  sudo apt-get install -yq xclip lastpass-cli trash-cli

  # Make sure /usr/local/share/applications exists
  if [[ ! -d /usr/local/share/applications ]]; then
    sudo mkdir -p /usr/local/share/applications
  fi

  # Make sure startup application directory exists
  if [[ ! -d ${HOME}/.config/autostart ]]; then
    mkdir -p ${HOME}/.config/autostart
  fi

  # Ensure Gimp directory exists
  if [[ ! -d "${HOME}/.gimp-2.8" ]]; then
    mkdir -p "${HOME}/.gimp-2.8"
  fi

  # Gimp configuration
  # cp "${gimp_files}/sessionrc" "${HOME}/.gimp-2.8/sessionrc"

  # ls -l /etc/alternatives

  # Set default browser
  update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox 250
  update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/firefox 250

  # Kill gnome keyring
  sudo cp /usr/bin/gnome-keyring-daemon /usr/bin/gnome-keyring-daemon-old
  sudo rm /usr/bin/gnome-keyring-daemon
  ps aux | grep gnome-keyring-daemon | grep -v grep
  killall gnome-keyring-daemon

  e_success "Desktop installed"
}

###########################################################################
# Install Filezilla
# https://filezilla-project.org/
#
# http://www.getdeb.net/welcome/
# http://ubuntuhandbook.org/index.php/2016/08/install-filezilla-client-3-20-ubuntu-16-04/
# http://www.elinuxbook.com/install-filezilla-ftp-client-filezilla-client-in-ubuntu-16-04/
###########################################################################

install_filezilla() {
  e_title "Installing Filezilla"

  # Install Filezilla
  wget -qO - http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
  echo "deb deb http://archive.getdeb.net/ubuntu xenial-getdeb apps" | sudo tee /etc/apt/sources.list.d/getdeb.list

  sudo apt-get update
  sudo apt-get install -yq filezilla

  e_success "Filezilla installed"
}

###########################################################################
# Install Tor
# https://www.torproject.org/
#
# https://www.torproject.org/docs/debian.html.en
# https://www.torproject.org/projects/torbrowser.html.en
# https://tux-tips.com/install-tor-browser-ubuntu-1604/
# https://www.linuxbabe.com/browser/install-tor-browser-6-0-4-ubuntu-16-04
###########################################################################

install_tor() {
  e_title "Installing Tor"

  echo "deb http://deb.torproject.org/torproject.org xenial main" | sudo tee -a /etc/apt/sources.list.d/tor.list
  echo "deb-src http://deb.torproject.org/torproject.org xenial main" | sudo tee -a /etc/apt/sources.list.d/tor.list

  gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
  gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

  sudo apt-get update
  sudo apt-get install -yq tor deb.torproject.org-keyring

  # Install tor browser
  sudo add-apt-repository ppa:webupd8team/tor-browser
  sudo apt-get update
  sudo apt-get install -yq tor-browser

  e_success "Tor installed"
}

###########################################################################
# Install Transmission
# https://transmissionbt.com/
#
# http://www.elinuxbook.com/install-transmission-bittorrent-client-in-ubuntu-16-04/
# https://vpsguide.net/tutorials/vps-tutorials/install-transmission-torrent-client-on-ubuntu-server-and-debian/
###########################################################################

install_transmission() {
  e_title "Installing Transmission"

  if ! grep -q "transmissionbt/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:transmissionbt/ppa
    sudo apt-get update
  fi

  sudo apt-get install -yq transmission

  e_success "Transmission installed"
}

###########################################################################
# Install Cherrytree
# https://www.giuspen.com/cherrytree/
#
# http://sourcedigit.com/19978-install-cherrytree-text-editor-in-ubuntu-16-04/
###########################################################################

install_cherrytree() {
  e_title "Installing Cherrytree"

  if ! grep -q "giuspen/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:giuspen/ppa
    sudo apt-get update
  fi

  sudo apt-get install -yq cherrytree

  e_success "Cherrytree installed"
}

###########################################################################
# Install Keepass
# https://www.keepassx.org/
#
# http://ubuntuhandbook.org/index.php/2015/12/install-keepassx-2-0-in-ubuntu-16-04-15-10-14-04/
###########################################################################

install_keepass() {
  e_title "Installing KeepassX"

  if ! grep -q "eugenesan/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:eugenesan/ppa
    sudo apt-get update
  fi

  sudo apt-get install -yq keepassx

  e_success "KeepassX installed"
}

###########################################################################
# Install Caffeine
# https://launchpad.net/caffeine
#
# http://www.omgubuntu.co.uk/2016/07/caffeine-indicator-applet-ubuntu-lock-screen
###########################################################################

install_caffeine() {
  e_title "Installing Caffeine"

  if ! grep -q "caffeine-developers/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:caffeine-developers/ppa
    sudo apt-get update
  fi

  sudo apt-get install -yq caffeine

  e_success "Caffeine installed"
}

###########################################################################
# Install Sound Switcher Indicator
# https://yktoo.com/en/software/indicator-sound-switcher
#
# http://www.omgubuntu.co.uk/2016/09/indicator-sound-switcher-makes-switching-audio-devices-ubuntu-snap
###########################################################################

install_sound_switcher() {
  e_title "Installing Sound Switcher Indicator"

  if ! grep -q "yktooo/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:yktooo/ppa
    sudo apt-get update
  fi

  sudo apt-get install -yq indicator-sound-switcher

  e_success "Sound Switcher Indicator installed"
}

###########################################################################
# Install NeoFetch
# https://github.com/dylanaraps/neofetch
#
# http://www.omgubuntu.co.uk/2016/11/neofetch-terminal-system-info-app
###########################################################################

install_neofetch() {
  e_title "Installing NeoFetch"

  if ! grep -q "dawidd0811/neofetch" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:dawidd0811/neofetch
    sudo apt-get update
  fi

  sudo apt-get install -yq neofetch

  e_success "NeoFetch installed"
}

###########################################################################
# Install OBS Studio
# https://obsproject.com/
#
# https://www.linuxhelp.com/how-to-install-obs-on-ubuntu-16-04/
# http://sourcedigit.com/20379-install-open-broadcaster-software-obs-studio-in-ubuntu-16-04/
###########################################################################

install_obs() {
  e_title "Installing OBS Studio"

  # Add OBS PPA
  if ! grep -q "obsproject/obs-studio" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:obsproject/obs-studio
    sudo apt-get update
  fi

  # Add FFMpeg PPA
  if ! grep -q "kirillshkrogalev/ffmpeg-next" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:kirillshkrogalev/ffmpeg-next
    sudo apt-get update
  fi

  sudo apt-get install -yq obs-studio
  sudo apt-get install -yq ffmpeg

  e_success "OBS Studio installed"
}

###########################################################################
# Install Audacity
# http://www.audacityteam.org/
#
# http://ubuntuhandbook.org/index.php/2017/03/audacity-2-1-3-released/
###########################################################################

install_audacity() {
  e_title "Installing Audacity"

  # Add Audacity PPA
  if ! grep -q "ubuntuhandbook1/audacity" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:ubuntuhandbook1/audacity
    sudo apt-get update
  fi

  sudo apt-get install -yq audacity

  e_success "Audacity installed"
}

###########################################################################
# Install Blender
# https://www.blender.org/
#
# http://ubuntuhandbook.org/index.php/2017/09/blender-2-79-released-install-it-in-ubuntu/
###########################################################################

install_blender() {
  e_title "Installing Blender"

  # Add Blender PPA
  if ! grep -q "thomas-schiex/blender" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:thomas-schiex/blender
    sudo apt-get update
  fi

  sudo apt-get install -yq blender

  e_success "Blender installed"
}

###########################################################################
# Install LibreOffice
# https://www.libreoffice.org/
#
# http://www.omgubuntu.co.uk/2017/07/how-to-install-libreoffice-5-4-on-ubuntu
###########################################################################

install_libreoffice() {
  e_title "Installing LibreOffice"

  # Add LibreOffice PPA
  if ! grep -q "libreoffice/libreoffice-5-4" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:libreoffice/libreoffice-5-4
    sudo apt-get update
  fi

  sudo apt-get install -yq libreoffice

  e_success "LibreOffice installed"
}

###########################################################################
# Install Albert
# https://albertlauncher.github.io/
#
# https://albertlauncher.github.io/docs/installing/
###########################################################################

install_albert() {
  e_title "Installing Albert"

  local albert_files=${GIT_RAW}/files

  # Add Albert PPA
  if ! grep -q "nilarimogard/webupd8" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:nilarimogard/webupd8
    sudo apt-get update
  fi

  # Install albert
  sudo apt-get install -yq albert

  # Create startup application directory
  if [[ ! -d "${HOME}/.config/autostart" ]]; then
    mkdir -p "${HOME}/.config/autostart"
  fi

  # Add new albert startup entry
  cp "${albert_files}/albert.desktop" "${HOME}/.config/autostart"

  # Create albert icons directory
  if [[ ! -d "${HOME}/.config/albert/icons" ]]; then
    mkdir -p "${HOME}/.config/albert/icons"
  fi
  cp -a "${albert_files}/icons/." "${HOME}/.config/albert/icons"

  # Albert Websearch JSON
  cp "${albert_files}/org.albert.extension.websearch.json" "${HOME}/.config/albert"
  sed -i "s/{{ USER }}/${USER}/" ${HOME}/.config/albert/org.albert.extension.websearch.json

  # Albert configuration
  cp "${albert_files}/albert.conf" "${HOME}/.config"

  e_success "Albert installed"
}

###########################################################################
# Install Gimp
# https://www.gimp.org/
#
# http://tipsonubuntu.com/2016/08/02/install-gimp-2-9-5-ubuntu-16-04/
###########################################################################

install_gimp() {
  e_title "Installing Gimp"

  local gimp_files=${GIT_RAW}/files

  # Add Gimp PPA
  if ! grep -q "otto-kesselgulasch/gimp" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
    sudo apt-get update
  fi

  # Install gimp
  sudo apt-get install -yq gimp gimp-plugin-registry gimp-data-extras

  # Ensure Gimp directory exists
  if [[ ! -d "${HOME}/.gimp-2.8" ]]; then
    mkdir -p "${HOME}/.gimp-2.8"
  fi

  # Gimp configuration
  cp "${gimp_files}/sessionrc" "${HOME}/.gimp-2.8/sessionrc"

  e_success "Gimp installed"
}

###########################################################################
# Install Inkscape
# https://inkscape.org/en/
#
# http://ubuntuhandbook.org/index.php/2017/01/install-inkscape-0-92-ppa-ubuntu-16-04-16-10-14-04/
###########################################################################

install_inkscape() {
  e_title "Installing Inkscape"

  # Add inkscape PPA
  if ! grep -q "inkscape.dev/stable" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:inkscape.dev/stable
    sudo apt-get update
  fi

  # Install inkscape
  sudo apt-get install -yq inkscape

  e_success "Inkscape installed"
}

###########################################################################
# Install Atom
# https://atom.io/
#
# http://tipsonubuntu.com/2016/08/05/install-atom-text-editor-ubuntu-16-04/
# http://tipsonubuntu.com/2017/05/16/easily-install-atom-text-editor-ubuntu-16-04-higher/
###########################################################################

install_atom() {
  e_title "Installing Atom"

  # Add atom PPA
  if ! grep -q "webupd8team/atom" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:webupd8team/atom
    sudo apt-get update
  fi

  # Install atom
  sudo apt-get install -yq atom

  # sudo apt-get install -yq snapd
  # sudo snap install atom --classic

  e_success "Atom installed"
}

###########################################################################
# Install Visual Studio Code
# https://code.visualstudio.com/
#
# https://code.visualstudio.com/docs/setup/linux#_installation
###########################################################################

install_vscode() {
  e_title "Installing Visual Studio Code"

  # Install vs code dependencies
  sudo apt-get install -yq apt-transport-https

  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

  sudo apt-get update
  sudo apt-get install -yq code

  e_success "Visual Studio Code installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_desktop
  install_filezilla
}

program_start
