###########################################################
###########################################################
#
# PART D: SETTING UP WILDCARD DOMAINS
#
###########################################################
###########################################################

###########################################################
# Install DNSMasq
###########################################################

# Install dnsmasq
sudo apt-get install dnsmasq

# Edit /etc/rc.local
sudo nano /etc/rc.local

# Add dnsmasq startup line
/etc/init.d/dnsmasq start

# Remove resolvconf
sudo apt-get remove resolvconf

## Change DNS servers to localhost and Google DNS

### Reboot.

###########################################################
# Create a Catchall VHost [12]
###########################################################

# Enable Apache's vhost_alias module
sudo a2enmod vhost_alias

# Create catchall file
sudo nano /etc/apache2/sites-available/001-catchall.conf

# Add vhosts
```
<VirtualHost *:80>
  ServerAlias localhost *.*.dev
  VirtualDocumentRoot /var/www/%2/public_html
  UseCanonicalName Off
</VirtualHost>

<VirtualHost *:80>
  ServerAlias localhost *.dev
  VirtualDocumentRoot /var/www/%1/public_html
  UseCanonicalName Off
  <Directory "/var/www">
    Options FollowSymLinks
    AllowOverride All
    Order allow,deny
    Allow from all
  </Directory>
</VirtualHost>
```

# Enable virtual conf
sudo a2ensite 001-catchall.conf

# Reload apache
sudo service apache2 reload

# Restart apache
sudo service apache2 restart

###########################################################
# Enable Wildcard DNS Servers [13][14]
###########################################################

# Edit dns conf
sudo nano /etc/dnsmasq.conf

# uncomment
no-resolv

# Add line
address=/dev/127.0.0.1

# Add line
listen-address=127.0.0.1

# restart dnsmasq
sudo /etc/init.d/dnsmasq restart

###########################################################
# Have localhost resolve domain names
###########################################################

# Open dhclient
sudo nano /etc/dhcp/dhclient.conf

# Uncomment line
prepend domain-name-servers 127.0.0.1;

# Refresh local DNS handling
sudo dhclient

## Reboot

# Test dnsmasq
ping jdedeiji.dev
