#!/bin/bash

# Keep up to date!
sudo apt update && apt -y upgrade
sudo apt update
sudo apt install -y software-properties-common

# Install php
sudo apt install -y php php-cli php-fpm php-json php-pdo php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath

# Install node
sudo apt install -y nodejs

# Install npm
sudo apt install -y npm

# Install composer
sudo apt install -y composer

# Intall vim
sudo apt install -y vim

# Open ports & remove apache2
sudo ufw allow http && sudo ufw allow https && sudo ufw reload
sudo apt remove -y --purge --auto-remove apache2
sudo rm -rf /var/www/html

# Install nginx
sudo apt install -y nginx
sudo apt install -y python3-certbot-nginx python3-pyparsing
sudo rm -rf /var/www/html

# Install gettext for envsubst
sudo apt-get install -y gettext-base

# Install mysql
sudo apt install -y mysql-server mysql-client

# Install certbot
sudo apt install -y certbot python3-certbot-nginx

# Install snap for certbot
sudo snap install -y core
sudo snap refresh core
sudo snap install -y --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Check / Start & Reload nginx
sudo nginx -t
sudo service nginx start
sudo service nginx reload

# SSL
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

sudo cp ./ssl-params.conf /etc/nginx/snippets/ssl-params.conf

# fail2ban
sudo apt install -y fail2ban
sudo cp ./jail.local /etc/fail2ban/jail.local
sudo service fail2ban restart && sudo fail2ban-client status
sudo service fail2ban reload

# Permissions
sudo usermod -a -G www-data ${USER}

# ACL
sudo apt -y install acl

## sudo su
sudo chown -R www-data:www-data /var/www && setfacl -Rd -m g:www-data:rwx /var/www && setfacl -R -m g:www-data:rwx /var/www && chmod -R g+s /var/www

# Nginx configuration
cp ./nginx.conf.template /nginx.conf.template
cp ./nginx.conf.template /etc/nginx/sites-available/nginx.conf
cp ./nginx-ssl.conf.template /etc/nginx/sites-available/nginx-ssl.conf

# Run second script
sudo ./config.sh
