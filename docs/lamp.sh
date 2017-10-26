#!/bin/bash

###########################################################################
#
# LAMP Bootstrap
# https://github.com/michaelcapx/playbook/docs/lamp.sh
#
# https://www.linode.com/docs/web-servers/lamp/install-lamp-stack-on-ubuntu-16-04
# https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04
# https://gist.github.com/Otienoh/6431b247d1bddfddb12f3dda436615d0
# https://gist.github.com/edouard-lopez/10008944
#
# Command:
# sudo ./lamp.sh
#
###########################################################################

export DEBIAN_FRONTEND=noninteractive

###########################################################################
# Constants and Global Variables
###########################################################################

readonly MACHINE_USER="$(who am i | awk '{print $1}')"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_header() { echo -e "\033[1;32m✔  $@\033[0m"; }
function e_error()  { echo -e "\033[1;31m✖  $@\033[0m"; }
function e_info()   { echo -e "\033[1;34m$@\033[0m"; }
function e_prompt() { echo -e "\033[1;33m$@\033[0m"; }

###########################################################################
# Update System Packages
###########################################################################

update_system() {
  e_header "Updating System......."
  sudo apt-get -y update
  sudo apt-get -y upgrade
  sudo apt-get install -y software-properties-common curl
}

###########################################################################
# Setup User
###########################################################################

setup_user() {
  e_header "Setup User......."
  usermod -a -G www-data $MACHINE_USER
  id $MACHINE_USER
  groups $MACHINE_USER
}

###########################################################################
# Install Apache
###########################################################################

install_apache() {
  e_header "Installing Apache......."
  sudo apt-get install -y apache2

  # Set global ServerName
  echo 'ServerName localhost' | sudo tee --append /etc/apache2/apache2.conf > /dev/null
  sudo apache2ctl configtest

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
}

###########################################################################
# Install MySQL
###########################################################################

install_mysql() {
  e_header "Installing MySQL......."

  # Install MySQL
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password secret'
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password secret'
  sudo apt-get install -y mysql-server

  # Configure MySQL Password Lifetime
  echo 'default_password_lifetime = 0' | sudo tee --append /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null

  # Setup root MySQL user
  mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO root@localhost IDENTIFIED BY 'secret' WITH GRANT OPTION;"
  sudo service mysql restart

  # Create main MySQL user
  mysql --user="root" --password="secret" -e "CREATE USER 'homestead'@'localhost' IDENTIFIED BY 'secret';"
  mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'homestead'@'localhost' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
  mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
  mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"
  mysql --user="root" --password="secret" -e "CREATE DATABASE homestead character set UTF8mb4 collate utf8mb4_bin;"
  sudo service mysql restart

  # Add Timezone Support To MySQL
  # mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=secret mysql
}

###########################################################################
# Install PHP
###########################################################################

install_php() {
  e_header "Installing PHP......."

  # Add PHP PPA
  if ! grep -q "ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding PHP PPA......."
    sudo apt-add-repository -y ppa:ondrej/php
    sudo apt-get update
  fi

  php_pkgs=(
    php7.1
    # libapache2-mod-php7.1
    # php7.1-apcu
    php7.1-bcmath
    php7.1-bz2
    php7.1-cgi
    # php7.1-cli
    # php7.1-common
    php7.1-curl
    php7.1-dev
    # php7.1-fpm
    php7.1-gd
    php7.1-intl
    php7.1-imagick
    php7.1-imap
    # php7.1-json
    php7.1-ldap
    php7.1-mbstring
    php7.1-mcrypt
    php7.1-memcached
    # php7.1-mongodb
    php7.1-mysql
    # php7.1-opcache
    php7.1-pgsql
    # php7.1-readline
    # php7.1-redis
    php7.1-soap
    php7.1-sqlite3
    # php7.1-xdebug
    # php7.1-xml
    php7.1-xmlrpc
    php7.1-yaml
    php7.1-zip
    php-xdebug
    # php-pear
  )

  # Install PHP Packages
  sudo apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages "${php_pkgs[@]}"

  # Set Apache DirectoryIndex
  sudo sed -i "s/ index.php / /" /etc/apache2/mods-enabled/dir.conf
  sudo sed -i "s/index.html /index.php index.html /" /etc/apache2/mods-enabled/dir.conf
  sudo systemctl restart apache2
  # sudo systemctl status apache2

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
}

###########################################################################
# Install Composer
###########################################################################

install_composer() {
  e_header "Installing Composer......."

  # Install Composer
  curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
  sudo chown -Rv $USER ~/.composer

  # Add Composer Global Bin To Path
  echo "export PATH=~/.composer/vendor/bin:\$PATH" >> ~/.bashrc
  source ~/.bashrc

  # Require Global Composer Packages
  composer global require "laravel/installer=~1.1"
  composer global require "laravel/envoy=~1.0"
  composer global require "phpunit/phpunit=@stable"
  composer global require "phpunit/dbunit=@stable"
  # composer global require "phpdocumentor/phpdocumentor=@stable"
  composer global require "sebastian/phpcpd=@stable"
  composer global require "phploc/phploc=@stable"
  composer global require "phpmd/phpmd=@stable"
  composer global require "squizlabs/php_codesniffer=@stable"
  composer global require "hirak/prestissimo=^0.3"
  composer global require "friendsofphp/php-cs-fixer=@stable"
  composer global require "codeception/codeception=@stable"
  composer global require "tightenco/jigsaw=@stable"

  # sudo git clone https://github.com/laravel/spark-installer.git /usr/local/share/spark-installer
  # sudo composer install -d /usr/local/share/spark-installer
  # sudo ln -s /usr/local/share/spark-installer/spark /usr/local/bin/spark

  git clone https://github.com/laravel/spark-installer.git ~/Documents/spark
  composer install -d ~/Documents/spark/spark
  sudo ln -s ~/Documents/spark/spark /usr/local/bin/spark
}

###########################################################################
# Install Node
###########################################################################

install_node() {
  e_header "Installing Node......."

  # Install NodeJS
  # curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
  # sudo apt-get install -y nodejs

  # Configure NodeJS Permissions
  # npm config get prefix
  # mkdir ~/.npm-global
  # npm config set prefix '~/.npm-global'
  # echo "export PATH=~/.npm-global/bin:\$PATH" >> ~/.profile
  # source ~/.profile

  # Install NVM
  sudo apt-get install -y build-essential libssl-dev
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash
  source ~/.profile
  nvm install --lts=boron

  # Install NodeJS Global Packages
  # npm install -g npm
  # npm install -g gulp
  npm install -g gulp-cli
  npm install -g bower
  npm install -g yarn
  npm install -g grunt-cli
  npm install -g browser-sync
  npm install -g webpack
  npm install -g webpack-dev-server
  npm install -g yo
  # npm install -g npm-check-updates
  # npm install -g phantomjs-prebuilt
  # npm install -g casperjs
  # npm install -g simplehttpserver
  # npm install -g xlsx
  # npm install -g webfont-dl
  # npm install -g diff-so-fancy
  npm install -g less
  npm install -g node-sass
  npm install -g jslint

  # Update NPM
  # npm update -g
}

###########################################################################
# Install SQLite
###########################################################################

install_sqlite() {
  e_header "Installing SQLite......."

  # Install SQLite
  sudo apt-get install -y sqlite3 libsqlite3-dev
}

###########################################################################
# Install Redis
###########################################################################

install_redis() {
  e_header "Installing Redis......."

  if ! grep -q "chris-lea/redis-server" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding Redis PPA......."
    sudo apt-add-repository -y ppa:chris-lea/redis-server
    sudo apt-get update
  fi

  sudo apt-get install -y redis-server
}

###########################################################################
# Install Memcached
###########################################################################

install_memcached() {
  e_header "Installing Memcached......."
  sudo apt-get install -y memcached
  sudo systemctl restart memcached
}

###########################################################################
# Install Beanstalkd
###########################################################################

install_beanstalkd() {
  e_header "Installing Beanstalkd......."
  sudo apt-get install -y beanstalkd

  # Configure Beanstalkd
  sudo sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
  sudo /etc/init.d/beanstalkd start
}

###########################################################################
# Install Blackfire
###########################################################################

install_blackfire() {
  e_header "Installing Blackfire......."

  curl -s https://packagecloud.io/gpg.key | sudo apt-key add -
  echo "deb http://packages.blackfire.io/debian any main" | sudo tee /etc/apt/sources.list.d/blackfire.list
  sudo apt-get update

  sudo apt-get install -y blackfire-agent blackfire-php

  # sudo blackfire-agent --register
  # sudo /etc/init.d/blackfire-agent start

  sudo systemctl restart apache2
}

###########################################################################
# Install Go
# https://www.digitalocean.com/community/tutorials/how-to-install-go-1-6-on-ubuntu-16-04
###########################################################################

install_golang() {
  e_header "Installing Go......."

  # Installing Go
  curl -O https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz
  tar xvf go1.9.1.linux-amd64.tar.gz
  sudo chown -R root:root ./go
  sudo mv go /usr/local
  rm go1.9.1.linux-amd64.tar.gz

  # Setting Go Paths
  echo "export GOPATH=\$HOME/Templates" >> ~/.profile
  echo "export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin" >> ~/.profile
  source ~/.profile
}

###########################################################################
# Install Mailhog
# https://agiletesting.blogspot.com/2016/02/setting-up-mailinator-like-test-mail.html
# https://pascalbaljetmedia.com/en/blog/setup-mailhog-with-laravel-valet
###########################################################################

install_mailhog() {
  e_header "Installing Mailhog......."

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
}

###########################################################################
# Install nGrok
###########################################################################

install_ngrok() {
  e_header "Installing Ngrok......."
  wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
  sudo unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin
  rm -rf ngrok-stable-linux-amd64.zip
}

###########################################################################
# Install Flyway
###########################################################################

install_flyway() {
  e_header "Installing Flyway......."
  wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/4.2.0/flyway-commandline-4.2.0-linux-x64.tar.gz
  sudo tar -zxvf flyway-commandline-4.2.0-linux-x64.tar.gz -C /usr/local
  sudo ln -s /usr/local/flyway-4.2.0/flyway /usr/local/bin/flyway
  rm -rf flyway-commandline-4.2.0-linux-x64.tar.gz
}

###########################################################################
# Install WP-CLI
###########################################################################

install_wpcli() {
  e_header "Installing WP-CLI......."
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  sudo mv wp-cli.phar /usr/local/bin/wp
}

###########################################################################
# Install phpMyAdmin
###########################################################################

install_phpmyadmin() {
  e_header "Installing phpMyAdmin......."

  if ! grep -q "nijel/phpmyadmin" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    e_header "Adding phpMyAdmin PPA......."
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
  sudo apt-get install -y phpmyadmin

  sudo phpenmod mcrypt
  sudo phpenmod mbstring

  sudo systemctl restart apache2
}

###########################################################################
# Install Adminer
###########################################################################

install_adminer() {
  e_header "Installing Adminer......."
  sudo mkdir /usr/share/adminer
  sudo wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php
  sudo ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php
  echo "Alias /adminer.php /usr/share/adminer/adminer.php" | sudo tee /etc/apache2/conf-available/adminer.conf
  sudo a2enconf adminer.conf
  sudo systemctl restart apache2
}

###########################################################################
# Install PhantomJS
# https://www.vultr.com/docs/how-to-install-phantomjs-on-ubuntu-16-04
# https://gist.github.com/julionc/7476620
# https://gist.github.com/telbiyski/ec56a92d7114b8631c906c18064ce620
###########################################################################

install_phantomjs() {
  e_header "Installing PhantomJS......."

  sudo apt-get install -y build-essential chrpath libssl-dev libxft-dev libfreetype6-dev libfreetype6 libfontconfig1-dev libfontconfig1

  sudo wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
  sudo tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
  sudo ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
  phantomjs --version
  rm -fr phantomjs-2.1.1-linux-x86_64.tar.bz2

}

###########################################################################
# Install PimpMyLog
###########################################################################

install_pimpmylog() {
  e_header "Installing PimpMyLog......."
  sudo git clone https://github.com/potsky/PimpMyLog.git /var/www/html/pimpmylog
  sudo chmod -R 0777 /var/www/html/pimpmylog/
  sudo systemctl restart apache2
}

###########################################################################
# Configure Supervisor
###########################################################################

configure_supervisor() {
  e_header "Configure Supervisor......."
  sudo systemctl enable supervisor.service
  sudo service supervisor start
}

###########################################################################
# Cleanup LAMP
###########################################################################

cleanup_lamp() {
  e_header "Cleaning Up......."
  sudo apt-get -y autoremove
  sudo apt-get -y clean
  sudo systemctl restart apache2
  sudo systemctl restart mysql
}

###########################################################################
# Program Start
###########################################################################

setup_lamp() {
  update_system
  install_apache
  install_mysql
  install_php
  install_composer
  install_node
  install_sqlite
  install_redis
  install_memcached
  install_beanstalkd
  install_blackfire
  install_golang
  install_mailhog
  install_ngrok
  install_flyway
  install_wpcli
  install_phpmyadmin
  install_adminer
  install_phantomjs
  install_pimpmylog
  configure_supervisor
  cleanup_lamp
}

setup_lamp
