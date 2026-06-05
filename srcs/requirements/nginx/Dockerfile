FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*
    #Installs nginx the web server and openssl for the TLS cert

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/pprzyby2.42.fr.key \
    -out /etc/nginx/ssl/pprzyby2.42.fr.crt \
    -subj "/C=DE/ST=BW/L=Heilbronn/O=42/CN=pprzyby2.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
