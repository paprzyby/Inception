FROM debian:bookworm

RUN apt update && apt install -y \
php \
php-fpm \
php-mysql \
wget \
curl

COPY tools/setup.sh /setup.sh

RUN chmod 777 /setup.sh

ENTRYPOINT ["/setup.sh"]