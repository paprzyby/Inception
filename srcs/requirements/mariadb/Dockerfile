FROM debian:bookworm

RUN apt update && apt install mariadb-server -y

COPY conf/my.cnf /etc/mysql/my.cnf
COPY tools/setup.sh /setup.sh

RUN chmod 777 /setup.sh

ENTRYPOINT ["/setup.sh"]