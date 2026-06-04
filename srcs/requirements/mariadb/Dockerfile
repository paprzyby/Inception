#This Dockerfile defines how the MariaDB image gets built:

FROM debian:bullseye
#Base image

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*
#Installs MariaDB.
#rm -rf cleans up the package cache which is a hood practice

COPY tools/mariadb_setup.sh /usr/local/bin/mariadb_setup.sh
RUN chmod +x /usr/local/bin/mariadb_setup.sh
#Copies the setup script from host to the container and then makes it executable.

EXPOSE 3306
#It's just an information on which port will the container listen.
#Good practice

ENTRYPOINT ["/usr/local/bin/mariadb_setup.sh"]
#Command that runs when the container starts.
