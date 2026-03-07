FROM debian:bookworm

RUN apt update && apt install nginx openssl -y

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/setup.sh /setup.sh

RUN chmod 777 /setup.sh

ENTRYPOINT ["/setup.sh"]