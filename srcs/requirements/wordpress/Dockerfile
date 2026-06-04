FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysqlp \
    php7.4-curl \
    php7.4-gd \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    curl \
    && rm -rf /var/lib/apt/lists/*
    #Installs PHP and the extensions WordPress needs

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp
    #Downloads a command line tool for managing WordPress

RUN mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html
    #Creates the directory where WordPRess files will live

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/wordpress_setup.sh /usr/local/bin/wordpress_setup.sh
RUN chmod +x /usr/local/bin/wordpress_setup.sh
#Configures how PHP runs and setup script

EXPOSE 9000
#Listens on port 9000

ENTRYPOINT ["/usr/local/bin/wordpress_setup.sh"]
