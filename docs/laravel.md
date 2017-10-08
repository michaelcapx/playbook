# Laravel Project Setup

This document outlines how to setup a fresh [Laravel](https://laravel.com) project on a local development machine using an Apache webserver.

## Contents
1. [Installing Laravel](#installing-laravel)
2. [Configure Virtual Hosts](#configure-virtual-hosts)
3. [Spark Installation](#spark-installation)
4. [Setting Permissions](#setting-permissions)
5. [Create a MySQL Database](#create-a-mysql-database)

## Installing Laravel

Laravel utilizes [Composer](https://getcomposer.org/) to manage its dependencies. So, before using Laravel, make sure you have Composer installed on your machine.

### Via Laravel Installer

Once the laravel installer is installed, the `laravel new` command will create a fresh Laravel installation in the directory you specify. For instance, `laravel new projectname` will create a directory named projectname containing a fresh Laravel installation with all of Laravel's dependencies already installed:

    cd ~/Documents
    laravel new projectname

### Via Composer Create-Project

Alternatively, you may also install Laravel by issuing the Composer `create-project` command in your terminal:

    cd ~/Documents
    composer create-project --prefer-dist laravel/laravel projectname

## Configure Virtual Hosts

You can set up virtual hosts several ways; however, below is the recommended method. By default, Apache listens on all IP addresses available to it. For all steps below, replace `username` with your user name and `projectname` with your project/domain name.

Create a copy of the default Apache configuration file for your site:

    sudo cp /etc/apache2/sites-available/laravel.conf /etc/apache2/sites-available/projectname.conf

Edit the new `projectname.conf` configuration file with a `ServerName`, `ServerAlias`, `DocumentRoot`, and `Directory` block:

```
<VirtualHost *:80>
  ServerName projectname.dev
  ServerAlias *.projectname.dev

  ServerAdmin webmaster@localhost
  DocumentRoot /home/username/Documents/projectname/public

  <Directory /home/username/Documents/projectname/public/>
    Options Indexes Includes FollowSymLinks  MultiViews
    AllowOverride All
    Require all granted
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
```

Link your virtual host file from the `sites-available` directory to the `sites-enabled` directory:

    sudo a2ensite projectname.conf

Reload Apache:

    sudo systemctl reload apache2

Setup `/etc/hosts` hosts file:

    echo "127.0.0.1 projectname.dev" | sudo tee --append /etc/hosts > /dev/null

Virtual hosting should now be enabled. To allow the virtual host to use your domain name, be sure that you have configured DNS services for your domain.

## Spark Installation

### Installation via Github

Spark provides a [Private Github repository](https://github.com/laravel/spark) which makes it simple to install Spark just like any other Github package.

Clone or download the repository into your main laravel project directory:

    git clone git@github.com:laravel/spark.git ~/Documents/projectname/spark

Add the `spark` directory as a repository to the project's `composer.json` file:

```
"repositories": [
  {
    "type": "path",
    "url": "./spark"
  }
]
```
You should also add the following dependency to your `composer.json` file's require section:

    "laravel/spark": "*@dev",

Next, you should add Cashier to your project. If you are using Stripe, you should use the `laravel/cashier` package. If you are using Braintree, you should use the `laravel/cashier-braintree` package:

    "laravel/cashier": "~7.0"

or

    "laravel/cashier-braintree": "~2.0"

Next, run the composer update command inside the project root:

    composer update

Once the dependencies are installed, add the following service providers to your `app.php` configuration file:

    Laravel\Spark\Providers\SparkServiceProvider::class,
    Laravel\Cashier\CashierServiceProvider::class,

Next, run the `spark:install --force` command:

    php artisan spark:install --force

Once Spark is installed, add the following provider to your `app.php` configuration file:

    App\Providers\SparkServiceProvider::class,

### Installation via Composer

Spark provides a [Satis repository](https://spark-satis.laravel.com/) which makes it simple to install Spark just like any other Composer package.

## Setting Permissions

To ensure the site loads properly in the browser, make sure to set the project's file and directory permissions:

    sudo chown -R www-data:www-data /home/username/Documents/projectname
    sudo chmod -R 775 /home/username/Documents/projectname/.

## Create a MySQL Database

Log into MySQL root:

    mysql -u root -p

Create the database:

    CREATE DATABASE projectname;

Create database user:

    CREATE USER dbuser@localhost IDENTIFIED BY 'dbpassword';

Add user to database:

    GRANT ALL PRIVILEGES ON projectname.* TO dbuser@localhost;

Flush privledges:

    FLUSH PRIVILEGES;

Exit MySQL console:

    exit

Setup database credentials:

    sed -i 's/DB_DATABASE=homestead/DB_DATABASE=projectname/' ~/Documents/projectname/.env
    sed -i 's/DB_USERNAME=homestead/DB_USERNAME=dbuser/' ~/Documents/projectname/.env
    sed -i 's/DB_PASSWORD=secret/DB_PASSWORD=dbpassword/' ~/Documents/projectname/.env
