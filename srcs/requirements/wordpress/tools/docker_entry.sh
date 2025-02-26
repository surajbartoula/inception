# #!/usr/bin/env bash

# cd $WP_ROUTE

# wp core download --force --allow-root

# wp config create --path=$WP_ROUTE --allow-root --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=$DB_HOST --dbprefix=wp_

# if ! wp core is-installed --allow-root --path=$WP_ROUTE; then
# wp core install --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL --allow-root
# wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASS --allow-root
# fi

# php-fpm7.4 -F

#!/bin/bash
set -e

# Define WordPress installation path
WP_PATH="/var/www/html"

# Ensure the directory exists
mkdir -p $WP_PATH
cd $WP_PATH

# If WordPress is not installed, download and configure it
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "Installing WordPress..."
    wp core download --allow-root
    wp config create --dbname=wordpress --dbuser=root --dbpass=root --dbhost=mariadb --allow-root
    wp core install --url="http://localhost" --title="Docker WordPress" --admin_user="admin" --admin_password="admin" --admin_email="admin@example.com" --allow-root
    chown -R www-data:www-data $WP_PATH
fi

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F

