#! /usr/bin/env bash
set -e
###########################################################################
#
# LAMP Bootstrap Installer
# https://github.com/michaelcapx/playbook/scripts/lamp.sh
#
# This script is used to provision a quick LAMP (Linux, Apache, MySQL, PHP)
# server for local development.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/michaelcapx/playbook/master/scripts/lamp.sh | bash
#
###########################################################################

if [[ $EUID -eq 0 ]]; then
  echo "$(tput bold)$(tput setaf 1)This script must NOT be run as root$(tput sgr0)" 1>&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

###########################################################################
# Constants and Global Variables
###########################################################################

# Machine constants
readonly LINUX_MTYPE="$(uname -m)"                   # x86_64
readonly LINUX_ID="$(lsb_release -i -s)"             # Ubuntu
readonly LINUX_CODENAME="$(lsb_release -c -s)"       # xenial
readonly LINUX_RELEASE="$(lsb_release -r -s)"        # 16.04
readonly LINUX_DESCRIPTION="$(lsb_release -d -s)"    # GalliumOS 2.1
readonly LINUX_DESKTOP="$(printenv DESKTOP_SESSION)" # xfce
readonly LINUX_USER="$(who am i | awk '{print $1}')" # user

# Git variables
readonly GIT_USER="michaelcapx"
readonly GIT_REPO="playbook"
readonly GIT_URL="https://github.com/${GIT_USER}/${GIT_REPO}.git"
readonly GIT_RAW="https://raw.github.com/${GIT_USER}/${GIT_REPO}/master/"

# Script variables
readonly SCRIPT_SOURCE="${BASH_SOURCE[0]}"
readonly SCRIPT_PATH="$( cd -P "$( dirname "${SCRIPT_SOURCE}" )" && pwd )"
readonly SCRIPT_NAME="$(basename "$SCRIPT_SOURCE")"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_header()  { echo -e "\033[1;30m===== $@ =====\033[0m"; }      # grey
function e_error()   { echo -e "\033[1;31m✖  $@\033[0m";          }      # red
function e_success() { echo -e "\033[1;32m✔  $@\033[0m";          }      # green
function e_warn()    { echo -e "\033[1;33m⚠  $@\033[0m";          }      # yellow
function e_info()    { echo -e "\033[1;34m$@\033[0m";             }      # blue
function e_title()   { echo -e "\033[1;35m$@.......\033[0m";      }      # magenta
function e_prompt()  { echo -e "\033[1;36m$@ \033[0m";            }      # cyan

###########################################################################
# Pre Install
###########################################################################

pre_install() {
  e_header "Start Your Engines"

  sudo apt-get -y update
  sudo apt-get -y upgrade
  sudo apt-get install -y software-properties-common curl

  sudo usermod -a -G www-data $USER
  id $USER
  groups $USER
}

###########################################################################
# Install Apache
# http://www.apache.org/
#
# https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04
# https://www.linode.com/docs/web-servers/lamp/install-lamp-stack-on-ubuntu-16-04
###########################################################################

install_apache() {
  e_title "Installing Apache"

  # Install apache packages
  sudo apt-get install -yq \
  apache2 apache2-utils apachetop

  # Set global ServerName
  echo 'ServerName localhost' | sudo tee --append /etc/apache2/apache2.conf > /dev/null
  sudo apache2ctl configtest

  # Set Apache DirectoryIndex
  sudo sed -i "s/ index.php / /" /etc/apache2/mods-enabled/dir.conf
  sudo sed -i "s/index.html /index.php index.html /" /etc/apache2/mods-enabled/dir.conf
  sudo systemctl restart apache2
  # sudo systemctl status apache2

  # Configure MPM Prefork
  sudo sed -i "s/StartServers\s\{2,\}[0-9]*/StartServers       4/" /etc/apache2/mods-available/mpm_prefork.conf
  sudo sed -i "s/MinSpareServers\s\{2,\}[0-9]*/MinSpareServers     3/" /etc/apache2/mods-available/mpm_prefork.conf
  sudo sed -i "s/MaxSpareServers\s\{2,\}[0-9]*/MaxSpareServers    40/" /etc/apache2/mods-available/mpm_prefork.conf
  sudo sed -i "s/MaxRequestWorkers\s\{2,\}[0-9]*/MaxRequestWorkers   200/" /etc/apache2/mods-available/mpm_prefork.conf
  sudo sed -i "s/MaxConnectionsPerChild\s\{2,\}[0-9]*/MaxConnectionsPerChild   10000/" /etc/apache2/mods-available/mpm_prefork.conf

  # Set nicer permissions on Apache log directory
  sudo chmod -R 0755 /var/log/apache2/

  # Disable the event module and enable prefork
  sudo a2dismod mpm_event
  sudo a2enmod mpm_prefork

  # Enable Apache mod_rewrite
  sudo a2enmod rewrite

  # Restart Apache
  sudo systemctl restart apache2

  e_success "Apache installed"
}

###########################################################################
# Install MySQL
# https://www.mysql.com/
#
# https://gorails.com/setup/ubuntu/16.04
###########################################################################

install_mysql() {
  e_title "Installing MySQL"

  # Install MySQL
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password secret'
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password secret'
  sudo apt-get install -yq mysql-common mysql-server mysql-client libmysqlclient-dev python-mysqldb mytop

  # Configure MySQL Password Lifetime
  echo 'default_password_lifetime = 0' | sudo tee --append /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null

  sudo sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

  # Setup root MySQL user
  mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
  sudo service mysql restart

  # Create main MySQL user
  mysql --user="root" --password="secret" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
  mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
  mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
  mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"
  mysql --user="root" --password="secret" -e "CREATE DATABASE homestead character set UTF8mb4 collate utf8mb4_bin;"
  sudo service mysql restart

  # Add Timezone Support To MySQL
  # mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=secret mysql

  e_success "MySQL installed"
}

###########################################################################
# Install PHP
# https://secure.php.net/
#
# https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04
###########################################################################

install_php() {
  e_title "Installing PHP"

  # Add PHP PPA
  if ! grep -q "ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_title "Adding PHP PPA"
    sudo apt-add-repository -y ppa:ondrej/php
    sudo apt-get update
  fi

  php_pkgs=(
    php7.1
    libapache2-mod-php7.1
    # php7.1-apcu
    php7.1-bcmath
    php7.1-bz2
    php7.1-cgi
    php7.1-cli
    php7.1-common
    php7.1-curl
    php7.1-dev
    # php7.1-fpm
    php7.1-gd
    php7.1-intl
    php7.1-imagick
    php7.1-imap
    php7.1-json
    php7.1-ldap
    php7.1-mbstring
    php7.1-mcrypt
    php7.1-memcached
    php7.1-mongodb
    php7.1-mysql
    php7.1-opcache
    php7.1-pgsql
    php7.1-readline
    php7.1-redis
    php7.1-soap
    php7.1-sqlite3
    php7.1-xdebug
    php7.1-xml
    php7.1-xmlrpc
    php7.1-yaml
    php7.1-zip
    # php-xdebug
    php-pear
  )

  # Install PHP Packages
  sudo apt-get install -yq --allow-downgrades --allow-remove-essential --allow-change-held-packages "${php_pkgs[@]}"

  # sudo update-alternatives --set php /usr/bin/php7.1

  # Set Some PHP CLI Settings
  sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/cli/php.ini
  sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/cli/php.ini
  sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/cli/php.ini
  sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/cli/php.ini

  # Set Some PHP Apache Settings
  sudo sed -i "s/error_reporting = .*/error_reporting = E_COMPILE_ERROR | E_RECOVERABLE_ERROR | E_ERROR | E_CORE_ERROR/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/max_input_time = .*/max_input_time = 30/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/;error_log = syslog/error_log = \/var\/log\/php\/error.log/" /etc/php/7.1/apache2/php.ini
  sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/apache2/php.ini

  # Configure PHP Xdebug options
  echo 'xdebug.remote_enable = 1' | sudo tee --append /etc/php/7.1/mods-available/xdebug.ini > /dev/null
  echo 'xdebug.remote_connect_back = 1' | sudo tee --append /etc/php/7.1/mods-available/xdebug.ini > /dev/null
  echo 'xdebug.remote_port = 9000' | sudo tee --append /etc/php/7.1/mods-available/xdebug.ini > /dev/null
  echo 'xdebug.max_nesting_level = 512' | sudo tee --append /etc/php/7.1/mods-available/xdebug.ini > /dev/null

  # Configure PHP Opcache options
  echo 'opcache.revalidate_freq = 0' | sudo tee --append /etc/php/7.1/mods-available/opcache.ini > /dev/null

  # Create the log directory for PHP and give ownership to the Apache system user
  sudo mkdir /var/log/php
  sudo chown www-data /var/log/php
  sudo touch /var/log/php/error.log
  sudo chmod -R 0755 /var/log/php/

  # Disable XDebug On The CLI
  sudo phpdismod -s cli xdebug

  # Setup Permissions
  sudo chown -R www-data:www-data /var/www

  # Setup Info page
  sudo touch /var/www/html/info.php
  echo '<?php phpinfo(); ?>' | sudo tee --append /var/www/html/info.php > /dev/null

  # Restart Apache
  sudo systemctl restart apache2

  e_success "PHP installed"
}

###########################################################################
# Install Composer
# https://getcomposer.org/
#
# https://getcomposer.org/doc/00-intro.md#installation-linux-unix-osx
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-composer-on-ubuntu-16-04
###########################################################################

install_composer() {
  e_title "Installing Composer"

  # Install Composer
  curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
  sudo chown -Rv $USER ${HOME}/.composer

  # Add Composer Global Bin To Path
  # printf "\nPATH=\"$(sudo su - $USER -c 'composer config -g home 2>/dev/null')/vendor/bin:\$PATH\"\n" | tee -a /home/$USER/.profile
  # source ${HOME}/.profile

  echo "export PATH=$HOME/.composer/vendor/bin:\$PATH" >> ${HOME}/.profile
  source ${HOME}/.profile

  # echo "export PATH=$HOME/.composer/vendor/bin:\$PATH" >> ${HOME}/.bashrc
  # source ${HOME}/.bashrc

  # Require Global Composer Packages
  composer global require "laravel/installer"
  composer global require "laravel/envoy"
  # composer global require "phpunit/phpunit=@stable"
  # composer global require "phpunit/dbunit=@stable"
  # composer global require "phpdocumentor/phpdocumentor=@stable"
  # composer global require "sebastian/phpcpd=@stable"
  # composer global require "phploc/phploc=@stable"
  # composer global require "phpmd/phpmd=@stable"
  # composer global require "squizlabs/php_codesniffer=@stable"
  # composer global require "hirak/prestissimo=^0.3"
  # composer global require "friendsofphp/php-cs-fixer=@stable"
  # composer global require "codeception/codeception=@stable"
  # composer global require "tightenco/jigsaw=@stable"

  # sudo git clone https://github.com/laravel/spark-installer.git /usr/local/share/spark-installer
  # sudo composer install -d /usr/local/share/spark-installer
  # sudo ln -s /usr/local/share/spark-installer/spark /usr/local/bin/spark

  # git clone https://github.com/laravel/spark-installer.git ${HOME}/Documents/spark
  # composer install -d ${HOME}/Documents/spark/spark
  # sudo ln -s ${HOME}/Documents/spark/spark /usr/local/bin/spark

  e_success "Composer installed"
}

###########################################################################
# Install WP-cli
# http://wp-cli.org/
#
# https://make.wordpress.org/cli/handbook/installing/
###########################################################################

install_wpcli() {
  e_title "Installing WP-cli"

  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  sudo chmod +x wp-cli.phar
  sudo mv wp-cli.phar /usr/local/bin/wp

  e_success "WP-cli installed"
}

###########################################################################
# Install SQLite
# https://www.sqlite.org/
#
# https://linuxhint.com/install-sqlite-ubuntu-linux-mint/
###########################################################################

install_sqlite() {
  e_title "Installing SQLite"

  # Install SQLite
  sudo apt-get install -yq sqlite3 libsqlite3-dev

  e_success "SQLite installed"
}

###########################################################################
# Install PostgreSQL
# https://www.postgresql.org/
#
# https://gorails.com/setup/ubuntu/16.04
###########################################################################

install_postgresql() {
  e_title "Installing PostgreSQL"

  sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
  wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

  sudo apt-get update
  sudo apt-get install -yq postgresql-common
  sudo apt-get install -yq postgresql-9.5 postgresql-contrib-9.5 libpq-dev

  sudo -u postgres createuser $USER -s

  # Configure Postgres Remote Access

  sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.5/main/postgresql.conf
  sudo echo "host    all             all             10.0.2.2/32               md5" | tee -a /etc/postgresql/9.5/main/pg_hba.conf
  sudo -u postgres psql -c "CREATE ROLE homestead LOGIN UNENCRYPTED PASSWORD 'secret' SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"
  sudo -u postgres /usr/bin/createdb --echo --owner=homestead homestead
  sudo service postgresql restart

  # If you would like to set a password for the user, you can do the following
  # sudo -u postgres psql
  # postgres=# \password $USER

  e_success "PostgreSQL installed"
}

###########################################################################
# Install MongoDB
# https://www.mongodb.com/
#
# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
# https://www.howtoforge.com/tutorial/install-mongodb-on-ubuntu-16.04/
# https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-16-04
###########################################################################

install_mongodb() {
  e_title "Installing MongoDB"

  # Install python dependencies
  sudo apt-get install python-pip
  sudo pip install pymongo

  # Importing the Public Key
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5

  # Create source list file MongoDB
  echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
  sudo apt-get update

  # Install MongoDB
  sudo apt-get install -yq mongodb-org

  sudo tee /etc/systemd/system/mongodb.service <<EOL
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOL

  # Start mongodb
  # sudo systemctl start mongod
  # sudo systemctl unmask mongodb
  sudo systemctl start mongodb
  # sudo systemctl status mongodb
  # sudo systemctl enable mongodb

  e_success "MongoDB installed"
}

###########################################################################
# Install CouchDB
# http://couchdb.apache.org/
#
# http://docs.couchdb.org/en/2.1.1/install/unix.html
# https://pouchdb.com/guides/setup-couchdb.html
# https://gist.github.com/SinanGabel/eac83a2f9d0ac64e2c9d4bd936be9313
# https://linoxide.com/linux-how-to/install-couchdb-futon-ubuntu-1604/
###########################################################################

install_couchdb() {
  e_title "Installing CouchDB"

  # Enabling the Apache CouchDB package repository
  echo "deb https://apache.bintray.com/couchdb-deb xenial main" | sudo tee -a /etc/apt/sources.list
  curl -L https://couchdb.apache.org/repo/bintray-pubkey.asc | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install -yq couchdb

  e_success "CouchDB installed"
}

###########################################################################
# Install Golang
# https://golang.org/
#
# https://www.digitalocean.com/community/tutorials/how-to-install-go-1-6-on-ubuntu-16-04
###########################################################################

install_golang() {
  e_title "Installing Golang"

  # Installing Go
  curl -O https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz
  tar xvf go1.9.1.linux-amd64.tar.gz
  sudo chown -R root:root ./go
  sudo mv go /usr/local
  rm go1.9.1.linux-amd64.tar.gz

  # Setting Go Paths
  echo "export GOPATH=\$HOME/Templates" >> ${HOME}/.profile
  echo "export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin" >> ${HOME}/.profile
  source ${HOME}/.profile

  e_success "Golang installed"
}

###########################################################################
# Install Beanstalkd
# https://github.com/kr/beanstalkd
#
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-beanstalkd-work-queue-on-a-vps
###########################################################################

install_beanstalkd() {
  e_title "Installing Beanstalkd"

  sudo apt-get install -yq beanstalkd

  # Configure Beanstalkd
  sudo sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
  sudo /etc/init.d/beanstalkd start

  e_success "Beanstalkd installed"
}

###########################################################################
# Install Memcached
# https://memcached.org/
#
# http://www.servermom.org/install-use-memcached-nginx-php-7-ubuntu-16-04/3670/
###########################################################################

install_memcached() {
  e_title "Installing Memcached"

  sudo apt-get install -yq memcached
  sudo systemctl restart memcached

  e_success "Memcached installed"
}

###########################################################################
# Install Redis
# https://redis.io/
#
# https://www.rosehosting.com/blog/how-to-install-configure-and-use-redis-on-ubuntu-16-04/
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04
###########################################################################

install_redis() {
  e_title "Installing Redis"

  if ! grep -q "chris-lea/redis-server" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_title "Adding Redis PPA"
    sudo apt-add-repository -y ppa:chris-lea/redis-server
    sudo apt-get update
  fi

  sudo apt-get install -yq redis-server

  e_success "Redis installed"
}

###########################################################################
# Install Adminer
# https://www.adminer.org/
#
# http://www.ubuntuboss.com/how-to-install-adminer-on-ubuntu/
###########################################################################

install_adminer() {
  e_title "Installing Adminer"

  sudo mkdir /usr/share/adminer
  sudo wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php
  sudo ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php
  echo "Alias /adminer.php /usr/share/adminer/adminer.php" | sudo tee /etc/apache2/conf-available/adminer.conf
  sudo a2enconf adminer.conf
  sudo systemctl restart apache2

  e_success "Adminer installed"
}

###########################################################################
# Install PHPMyAdmin
# https://www.phpmyadmin.net/
#
# https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-16-04
###########################################################################

install_phpmyadmin() {
  e_title "Installing PHPMyAdmin"

  if ! grep -q "nijel/phpmyadmin" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:nijel/phpmyadmin
    sudo apt-get update
  fi

  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password secret'
  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/password-confirm password secret'
  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password secret'
  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/setup-password password secret'
  sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password secret'
  sudo apt-get install -yq phpmyadmin

  sudo phpenmod mcrypt
  sudo phpenmod mbstring

  sudo systemctl restart apache2

  e_success "PHPMyAdmin installed"
}

###########################################################################
# Install PimpMyLog
# http://pimpmylog.com/
#
# http://pimpmylog.com/getting-started/quick-start.html
###########################################################################

install_pimpmylog() {
  e_title "Installing PimpMyLog"

  sudo git clone https://github.com/potsky/PimpMyLog.git /var/www/html/pimpmylog
  sudo chmod -R 0777 /var/www/html/pimpmylog/
  sudo systemctl restart apache2

  e_success "PimpMyLog installed"
}

###########################################################################
# Install Ngrok
# https://ngrok.com/
###########################################################################

install_ngrok() {
  e_title "Installing Ngrok"

  wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
  sudo unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin
  sudo chmod -R 0755 /usr/local/bin/ngrok
  rm -rf ngrok-stable-linux-amd64.zip

  e_success "Ngrok installed"
}

###########################################################################
# Install Blackfire
# https://blackfire.io/
#
# https://blackfire.io/docs/up-and-running/installation
###########################################################################

install_blackfire() {
  e_title "Installing Blackfire"

  curl -s https://packagecloud.io/gpg.key | sudo apt-key add -
  echo "deb http://packages.blackfire.io/debian any main" | sudo tee /etc/apt/sources.list.d/blackfire.list
  sudo apt-get update

  sudo apt-get install -yq blackfire-agent blackfire-php

  # sudo blackfire-agent --register
  # sudo /etc/init.d/blackfire-agent start

  sudo systemctl restart apache2

  e_success "Blackfire installed"
}

###########################################################################
# Install Zend Z-Ray
###########################################################################

install_zray() {
  e_title "Installing Zend Z-Ray"

  sudo wget http://repos.zend.com/zend-server/early-access/ZRay-Homestead/zray-standalone-php72.tar.gz -O - | sudo tar -xzf - -C /opt
  sudo ln -sf /opt/zray/zray.ini /etc/php/7.1/cli/conf.d/zray.ini
  sudo ln -sf /opt/zray/zray.ini /etc/php/7.1/fpm/conf.d/zray.ini
  sudo ln -sf /opt/zray/lib/zray.so /usr/lib/php/20170718/zray.so
  sudo chown -R vagrant:vagrant /opt/zray

  e_success "Z-Ray installed"
}

###########################################################################
# Install PhantomJS
# https://www.vultr.com/docs/how-to-install-phantomjs-on-ubuntu-16-04
# https://gist.github.com/julionc/7476620
# https://gist.github.com/telbiyski/ec56a92d7114b8631c906c18064ce620
###########################################################################

install_phantomjs() {
  e_title "Installing PhantomJS"

  sudo apt-get install -y build-essential chrpath libssl-dev libxft-dev libfreetype6-dev libfreetype6 libfontconfig1-dev libfontconfig1

  sudo wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
  sudo tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
  sudo ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
  phantomjs --version
  rm -fr phantomjs-2.1.1-linux-x86_64.tar.bz2

  e_success "PhantomJS installed"
}

###########################################################################
# Install Flyway
###########################################################################

install_flyway() {
  e_title "Installing Flyway"

  wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/4.2.0/flyway-commandline-4.2.0-linux-x64.tar.gz
  sudo tar -zxvf flyway-commandline-4.2.0-linux-x64.tar.gz -C /usr/local
  sudo chmod +x /usr/local/flyway-4.2.0/flyway
  sudo ln -s /usr/local/flyway-4.2.0/flyway /usr/local/bin/flyway
  rm -rf flyway-commandline-4.2.0-linux-x64.tar.gz

  e_success "Flyway installed"
}

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
# Install Hostess
# https://github.com/cbednarski/hostess
###########################################################################

install_hostess() {

  e_title "Installing Hostess"

  sudo wget --quiet -O /usr/local/bin/hostess https://github.com/cbednarski/hostess/releases/download/v0.2.0/hostess_linux_amd64
  sudo chmod +x /usr/local/bin/hostess

  e_success "Hostess installed"

}

###########################################################################
# Install Supervisor
###########################################################################

install_supervisor() {
  e_title "Installing Supervisor"

  sudo apt-get install -y supervisor

  sudo systemctl enable supervisor.service
  sudo service supervisor start

  e_success "Supervisor installed"
}

###########################################################################
# Post Install
###########################################################################

post_install() {
  e_header "Cleaning Up"
  sudo apt-get -y upgrade
  sudo apt-get -y autoremove
  sudo apt-get -y clean
  sudo systemctl restart apache2
  sudo systemctl restart mysql
}

###########################################################################
# Program Start
###########################################################################

lamp_start() {
  e_header "Running LAMP Setup"

  pre_install
  install_apache
  install_mysql
  install_php
  install_composer
  install_wpcli
  install_sqlite
  # install_postgresql
  # install_mongodb # BROKEN
  # install_couchdb # BROKEN
  # install_golang
  # install_beanstalkd
  # install_memcached
  # install_redis
  install_adminer
  install_phpmyadmin
  # install_pimpmylog
  # install_ngrok
  # install_blackfire
  # install_zray # BROKEN
  # install_phantomjs
  # install_flyway
  # install_mailhog
  install_hostess
  # install_supervisor
  post_install
}

lamp_start
