FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
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

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/wordpress_setup.sh /usr/local/bin/wordpress_setup.sh
RUN chmod +x /usr/local/bin/wordpress_setup.sh
#Configures how PHP runs and setup script

EXPOSE 9000
#Listens on port 9000

ENTRYPOINT ["/usr/local/bin/wordpress_setup.sh"]
