#!/bin/bash
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_USER=$(cut -d: -f1 /run/secrets/credentials)
WP_ADMIN_PASS=$(cut -d: -f2 /run/secrets/credentials)

MYSQL_HOST=mariadb
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wp_user}
DOMAIN_NAME=${DOMAIN_NAME:-pprzyby2.42.fr}
WP_TITLE=${WP_TITLE:-Inception}
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-pprzyby2@student.42heilbronn.de}
WP_USER=${WP_USER:-john}
WP_USER_PASS=${WP_USER_PASS:-JohnPass42!}
WP_USER_EMAIL=${WP_USER_EMAIL:-john@pprzyby2.42.fr}
#Sets all of the variables that the script needs

cd /var/www/html

until bash -c "echo > /dev/tcp/${MYSQL_HOST}/3306" 2>/dev/null; do
    echo "Waiting for MariaDB..."
    sleep 2
done

#Opens a TCP connection

if [ ! -f wp-config.php ]; then
    wp core download --allow-root

    wp config create \
        --allow-root \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="${MYSQL_HOST}"
    #Generates config with the datavase connection details. This is the main WordPress config file.

    wp core install \
        --allow-root \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email

    wp user create \
        --allow-root \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASS}"
fi

exec php-fpm7.4 -F
