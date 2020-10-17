#!/bin/bash
set -a
source .env

# Export variables from .env
export NGINX_HOST=${NGINX_HOST}
export CERTBOT_MAIL=${CERTBOT_MAIL}

export MYSQL_HOST=${MYSQL_HOST}
export MYSQL_DATABASE=${MYSQL_DATABASE}
export MYSQL_ROOT_USER=${MYSQL_ROOT_USER}
export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
export MYSQL_USER=${MYSQL_USER}
export MYSQL_PASSWORD=${MYSQL_PASSWORD}

sudo unlink /etc/nginx/sites-enabled/default

sudo mkdir -p /var/lib/letsencrypt/.well-known
sudo chgrp www-data /var/lib/letsencrypt
sudo chmod g+s /var/lib/letsencrypt
sudo cp letsencrypt.conf /etc/nginx/snippets/letsencrypt.conf



# Create directory for host
sudo mkdir -p /var/www/${NGINX_HOST}/public

# Replace variables
envsubst "$(printf '${%s} ' $(env | sed 's/=.*//'))" < ./nginx.conf.template > /etc/nginx/sites-available/nginx.conf

# Copy to virtual host
sudo cp /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-available/${NGINX_HOST}

# Symlink
sudo ln -s /etc/nginx/sites-available/${NGINX_HOST} /etc/nginx/sites-enabled/

# Reload nginx
sudo nginx -t
sudo service nginx reload

# Generating Certificate
sudo certbot certonly --webroot --non-interactive --agree-tos --email laureta.dzika@gmail.com \
    -w /var/www/${NGINX_HOST}/public -d ${NGINX_HOST} -d www.${NGINX_HOST}

# Replace variables for ssl Virtual Host
envsubst "$(printf '${%s} ' $(env | sed 's/=.*//'))" < ./nginx-ssl.conf.template > /etc/nginx/sites-available/nginx-ssl.conf
# Copy to Virtual Host
sudo cp /etc/nginx/sites-available/nginx-ssl.conf /etc/nginx/sites-available/${NGINX_HOST}

# Reload nginx
sudo nginx -t
sudo service nginx reload

sudo certbot renew --dry-run

# .well-known directory
sudo mkdir /var/www/${NGINX_HOST}/public/.well-known
sudo chown www-data:www-data -R /var/www/${NGINX_HOST}/public/.well-known
sudo chmod 755 -R /var/www/${NGINX_HOST}/public/.well-known

# Copy index to domain path
sudo cp ./index.php /var/www/${NGINX_HOST}/public






