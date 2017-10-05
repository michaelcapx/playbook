###########################################################
###########################################################
#
# INSTALL LARAVEL
#
###########################################################
###########################################################

###########################################################
# Setup Laravel
###########################################################

# Go to documents directory
cd ~/Documents

# Install laravel
laravel new <PROJECTNAME>

# Create apache config
sudo cp /etc/apache2/sites-available/laramail.conf /etc/apache2/sites-available/<PROJECTNAME>.conf

```
<VirtualHost *:80>
  ServerName PROJECTNAME.dev
  ServerAlias *.PROJECTNAME.dev

  ServerAdmin webmaster@localhost
  DocumentRoot /home/user/Documents/PROJECTNAME/public

  <Directory /home/user/Documents/PROJECTNAME/public/>
    Options Indexes Includes FollowSymLinks  MultiViews
    AllowOverride All
    Require all granted
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
```

# Enable apache configuration file
sudo a2ensite <PROJECTNAME>.conf
sudo service apache2 restart

# Setup hosts file
sudo nano /etc/hosts
127.0.0.1 PROJECTNAME.dev

###########################################################
# Spark install
###########################################################

# Add the `spark` directory as a repository to the project's `composer.json` file
```
"repositories": [
    {
        "type": "path",
        "url": "./spark"
    }
]
```

# Add the `laravel/spark` requirement to your composer.json file
```
"require": {
    "php": ">=5.5.9",
    "laravel/framework": "5.2.*",
    "laravel/cashier": "~6.0",
    "laravel/spark": "*@dev"
}
```
# Run composer update in project root.
composer update

###########################################################
# Setup Laravel Permissions
###########################################################

sudo chown -R www-data:www-data /home/user/Documents/PROJECTNAME
sudo chmod -R 775 /home/user/Documents/PROJECTNAME/.


###########################################################
# Create a MySQL database
###########################################################

# Log into MySQL root
mysql -u root -p

# Create database
CREATE DATABASE <PROJECTNAME>;

# Create user
CREATE USER machinauser@localhost IDENTIFIED BY 'password';

# Add user to database
GRANT ALL PRIVILEGES ON machina.* TO machinauser@localhost;

# flush privledges
FLUSH PRIVILEGES;

# exit
exit

# Setup database credentials
sed -i 's/DB_DATABASE=homestead/DB_DATABASE=machina/' ~/Documents/machina/.env
sed -i 's/DB_USERNAME=homestead/DB_USERNAME=machinauser/' ~/Documents/machina/.env
sed -i 's/DB_PASSWORD=secret/DB_PASSWORD=password/' ~/Documents/machina/.env

# Migrate the DB tables
php artisan migrate
