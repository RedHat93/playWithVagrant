#!/usr/bin/env bash

apt-get update
apt-get install -y apache2
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

sudo cp -f /vagrant/apache_virtual_host/000-default.conf /etc/apache2/sites-enabled/

# SSL Cert
sudo mkdir /etc/apache2/ssl

# Set our CSR variables
SUBJ="
C=IT
ST=Italy
O=FANCHO
localityName=Bologna
commonName=127.0.0.1
organizationalUnitName=DevOPS
CN=127.0.0.1
"

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt -subj "$(echo -n "$SUBJ" | tr "\n" "/")"

sudo cp -f /vagrant/apache_virtual_host/default-ssl.conf /etc/apache2/sites-enabled/

#sudo a2ensite default-ssl.conf
sudo a2enmod ssl

sudo service apache2 restart