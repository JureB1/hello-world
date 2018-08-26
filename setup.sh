#!/bin/bash

if [[ ! -v $DEBUG ]]; then
  SILENCE=' > /dev/null'
  echo -e "Running at info level, use DEBUG=1 to enable detailed logging\n"
else
  SILENCE=''
fi


echo -e "Setup: \n"

if which service 2>&1 > /dev/null; then
  # Used in docker ubuntu images
  echo "Init System: Upstart/Initd"
  USE_SYSTEMD=false
else
  echo "Init System: SystemD"
  USE_SYSTEMD=true
fi

if [[ ! -v $MYSQL_PASSWORD ]]; then
  MYSQL_PASSWORD='password'
  echo "MySQL Root Password unspecified. Using: '${MYSQL_PASSWORD}'"
fi

if [[ ! -v $REGION ]]; then
  REGION='Australia'
  echo "Timezone Region unspecified. Using: '${REGION}'"
fi

if [[ ! -v $PORT ]]; then
  PORT='80'
  echo "Port unspecified. Using: '${PORT}'"
fi

if [[ ! -v $WORDPRESS_DB_NAME ]]; then
  WORDPRESS_DB_NAME='wordpress_db'
  echo "Wordpress DB name unspecified. Using: '${WORDPRESS_DB_NAME}'"
fi

if [[ ! -v $WORDPRESS_DB_USER ]]; then
  WORDPRESS_DB_USER='wordpress'
  echo "Wordpress DB user unspecified. Using: '${WORDPRESS_DB_USER}'"
fi

if [[ ! -v $WORDPRESS_DB_USER_PASSWORD ]]; then
  WORDPRESS_DB_USER_PASSWORD='password'
  echo "Wordpress DB user password unspecified. Using: '${WORDPRESS_DB_USER_PASSWORD}'"
fi

if [[ ! -v $WORDPRESS_DB_HOST ]]; then
  WORDPRESS_DB_HOST='localhost'
  echo "Wordpress DB host unspecified. Using: '${WORDPRESS_DB_HOST}'"
fi

if [[ ! -v $WORDPRESS_DB_SALT ]]; then
  WORDPRESS_DB_SALT='some salted passphrase'
  echo "Wordpress Salts unspecified. Using: '${WORDPRESS_DB_SALT}'"
  echo -e "\e[33mWarn: Ideally these should not be the same, feel free to change them after.\e[0m"
fi

echo -e "\nRunning tasks: \n"

echo "1. Setting Non Interactive"

export TERM=linux
export DEBIAN_FRONTEND=noninteractive

echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

echo "2. Updating apt-cache"

eval apt-get update $SILENCE

echo "3. Ensuring standard packages exist "
# Only matters on Docker based vms

eval apt-get install -y wget tar apt-utils $SILENCE

echo "4. Setting debconf selections"

eval debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQL_PASSWORD}"
eval debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQL_PASSWORD}"
eval debconf-set-selections <<< "tzdata tzdata/Areas select ${REGION}"

echo "5. Installing Apache"

eval apt-get install -y apache2 $SILENCE

echo "6. Starting Apache"

if ! $USE_SYSTEMD; then
  eval service apache2 start $SILENCE
else
  eval systemctl start apache2 $SILENCE
fi

echo "8. Installing MySql"

eval apt-get install -y mysql-server $SILENCE

echo "7. Installing PHP 7"

eval apt-get install -y php7.0 libapache2-mod-php7.0 php7.0-mbstring php7.0-xml php7.0-mysql php7.0-common php7.0-gd php7.0-json php7.0-cli php7.0-curl $SILENCE

echo "9. Installing PHPMyAdmin"

eval apt-get install -y phpmyadmin $SILENCE

echo "10. Restarting Apache and MySQL"

if ! $USE_SYSTEMD; then
  eval service apache2 restart $SILENCE
  eval service mysql restart $SILENCE
else
  eval systemctl restart apache2 $SILENCE
  eval systemctl restart mysql $SILENCE
fi

echo "11. Exposing port 80"
if which iptables 2>&1 > /dev/null; then
  eval iptables -A INPUT -m state --state NEW -p tcp --dport $PORT -j ACCEPT $SILENCE
else
  echo "iptables not found, assuming this script is being run inside a container and no ports need to be opened"
fi

echo "12. Getting Wordpress"

eval `wget -P /tmp/ https://wordpress.org/latest.tar.gz` 2>&1 $SILENCE

echo "13. Extracting Wordpress"

eval tar xzvf /tmp/latest.tar.gz -C /var/www/html/ --strip-components=1 $SILENCE

echo "14. Creating htaccess"

eval touch /var/www/html/.htaccess $SILENCE

eval chmod 644 /var/www/html/.htaccess $SILENCE

echo "DirectoryIndex index.php" >  /var/www/html/.htaccess

sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

echo "15. Copying example config"

eval touch /var/www/html/wp-config.php $SILENCE
eval chmod 755 /var/www/html/wp-config.php $SILENCE

echo "<?php
define('DB_NAME', '${WORDPRESS_DB_NAME}');
define('DB_USER', '${WORDPRESS_DB_USER}');
define('DB_PASSWORD', '${WORDPRESS_DB_USER_PASSWORD}');
define('DB_HOST', '${WORDPRESS_DB_HOST}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define('AUTH_KEY',         '${WORDPRESS_DB_SALT}');
define('SECURE_AUTH_KEY',  '${WORDPRESS_DB_SALT}');
define('LOGGED_IN_KEY',    '${WORDPRESS_DB_SALT}');
define('NONCE_KEY',        '${WORDPRESS_DB_SALT}');
define('AUTH_SALT',        '${WORDPRESS_DB_SALT}');
define('SECURE_AUTH_SALT', '${WORDPRESS_DB_SALT}');
define('LOGGED_IN_SALT',   '${WORDPRESS_DB_SALT}');
define('NONCE_SALT',       '${WORDPRESS_DB_SALT}');
\$table_prefix  = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');" > /var/www/html/wp-config.php

echo "16. Setup MySQL Wordpress tables"

mysql -u "root" --password="${MYSQL_PASSWORD}" -Bse "CREATE DATABASE ${WORDPRESS_DB_NAME};CREATE USER '${WORDPRESS_DB_USER}'@'${WORDPRESS_DB_HOST}' IDENTIFIED BY '${WORDPRESS_DB_USER_PASSWORD}';GRANT ALL PRIVILEGES ON ${WORDPRESS_DB_NAME}.* TO '${WORDPRESS_DB_USER}'@'${WORDPRESS_DB_HOST}';FLUSH PRIVILEGES"

echo "17. Restarting Apache and MySQL"

if ! $USE_SYSTEMD; then
  eval service apache2 restart $SILENCE
  eval service mysql restart $SILENCE
else
  eval systemctl restart apache2 $SILENCE
  eval systemctl restart mysql $SILENCE
fi
