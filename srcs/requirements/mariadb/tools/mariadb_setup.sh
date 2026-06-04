#!/bin/bash

set -e
#The script stops immediately if any command fails.

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
#Reads passwords from Docker secrets. These secrets are mounted later on as files, so they dont appear in the Dockerfile or env.

MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wp_user}
#Reads values from the env variables.
#The syntax ":-" tells to use default if the variable is empty.

mkdir -p /var/run/mysqld
chown mysql:mysql /var/run/mysqld
#Creates the directory MariaDB needs for its socket file and gives ownership to the mysql user.

if [ ! -d "/var/lib/mysql/mysql" ]; then
#checks if the database has already been initialized

    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db
    #Creates the initial MariaDB system tables

    mysqld --user=mysql --skip-networking & TEMP_PID=$!
    #Starts MariaDB only on the local socket and captures the process ID to later shut it down

    until mysqladmin ping --silent 2>/dev/null; do
        sleep 1
    #Waits until MariaDB is actually ready to accept commands.
    #Without this the next SQL commands would run before MariaDB is ready and fail.

    done

    mysql -u root << SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
SQL
#1. Sets the root password
#2. Creates the Wordpress database
#3. Creates the Wordpress user
#4. Gives that user full access to the WordPress database

    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
    wait $TEMP_PID
    #Shuts down the temporart MariaDB instance and waits for it to fully stop
fi

exec mysqld --user=mysql
#Starts MariaDB for real, in the foreground
#Exec replaces the shell process with mysqld, makung it PID 1 in the container.
#Docker needs to be PID 1 to handle signals correctly.

EOF

chmod +x srcs/requirements/mariadb/tools/mariadb_setup.sh
