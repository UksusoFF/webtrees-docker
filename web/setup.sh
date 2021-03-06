#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TARGETARCH=${TARGETARCH:-amd64}

source "${SCRIPT_DIR}/.env"

apt-get update
apt-get dist-upgrade -y

apt-get install -y --no-install-recommends nginx mysql-client \
  ca-certificates \
  php-cli php-fpm php-mbstring php-xml php-dom php-curl php-zip php-gd php-pgsql php-bcmath php-intl \
  curl sudo

curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php --install-dir=/usr/bin --filename=composer && rm composer-setup.php
ln -s /usr/bin/composer /usr/local/bin/composer

curl -sS https://deb.nodesource.com/setup_16.x -o node-setup.sh
bash node-setup.sh && rm node-setup.sh
apt-get install -y nodejs

apt-get install -y --no-install-recommends php-dev php-pear make
pecl channel-update pecl.php.net && pecl install xdebug
cp /var/tmp/app/config/xdebug.ini /etc/php/7.4/mods-available/xdebug.ini
phpenmod xdebug

apt-get -y autoremove && apt-get clean

cp /var/tmp/private/ssl.crt /etc/ssl/webtrees.crt
cp /var/tmp/private/ssl.key /etc/ssl/webtrees.key
cp /var/tmp/app/config/nginx.conf /etc/nginx/sites-enabled/webtrees
sed -i "s/APP_DOMAIN/${APP_DOMAIN}/" /etc/nginx/sites-enabled/webtrees

cp /var/tmp/private/*CA.crt /usr/local/share/ca-certificates/
update-ca-certificates

init_user() {
  USERNAME=webtrees
  HOME_DIR="/home/${USERNAME}"

  useradd --create-home --password "$(openssl passwd -1 ${USERNAME})" -g www-data "${USERNAME}"
  usermod -aG sudo "${USERNAME}"

  chown ${USERNAME}:www-data -R "${HOME_DIR}"
}

init_user
