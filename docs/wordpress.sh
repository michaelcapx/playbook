###########################################################
###########################################################
#
# INSTALL WORDPRESS
#
###########################################################
###########################################################

###########################################################
# Create a MySQL database
###########################################################

# Log into MySQL root
mysql -u root -p

# Create database
CREATE DATABASE machina;

# Create user
CREATE USER machinauser@localhost IDENTIFIED BY 'password';

# Add user to database
GRANT ALL PRIVILEGES ON machina.* TO machinauser@localhost;

# flush privledges
FLUSH PRIVILEGES;

# exit
exit

###########################################################
# Setup local hosts file
###########################################################

# Edit hosts files
sudo nano /etc/hosts

# Add virtual host entry
127.0.0.1   machina.dev

###########################################################
# Download WordPress
###########################################################

# Download WordPress
wget -P ~/Downloads http://wordpress.org/latest.tar.gz

# Extract WordPress
tar xzvf ~/Downloads/latest.tar.gz -C ~/Downloads

# Copy WordPress config file
cp ~/Downloads/wordpress/wp-config-sample.php ~/Downloads/wordpress/wp-config.php

# Edit WordPress config file
sed -i 's/database_name_here/machina/' ~/Downloads/wordpress/wp-config.php
sed -i 's/username_here/machinauser/' ~/Downloads/wordpress/wp-config.php
sed -i 's/password_here/password/' ~/Downloads/wordpress/wp-config.php

###########################################################
# Create Directory Structure
###########################################################

# Create document root structure
sudo mkdir -p /var/www/machina

# Grant Permissions
sudo chown -R $USER:$USER /var/www/machina

# Modify permissions
sudo chmod -R 755 /var/www

###########################################################
# Copy files to Document Root
###########################################################

# Transfer Wordpress to document root
sudo rsync -avP ~/Downloads/wordpress/ /var/www/machina/

# Assign ownership to files
sudo chown -R $USER:www-data /var/www/machina*

# Create uploads directory
mkdir /var/www/machina/wp-content/uploads

# Assign group ownership
sudo chown -R :www-data /var/www/machina/wp-content/uploads

###########################################################
# Complete Installation via Web
###########################################################

# Register site via the browser
http://machina.dev OR http://localhost/machina/

###########################################################
# Create an .htaccess File
###########################################################

# Create the htaccess file
touch /var/www/machina/.htaccess

# Give ownership to the server
sudo chown :www-data /var/www/machina/.htaccess

# Allow WordPress to modify the file
chmod 664 /var/www/machina/.htaccess

sudo chown www-data:www-data -R /var/www/machina*
sudo chmod -R 775 /var/www/machina/.

###########################################################
# When Manually Adding Plugins/Themes
###########################################################

sudo chown www-data:www-data -R /var/www/machina*
sudo chmod -R 775 /var/www/machina/.

###########################################################
# Adding user to Usergroup
###########################################################
sudo usermod -a -G www-data YOURUSERNAME
