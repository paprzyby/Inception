COMPOSE_FILE	= srcs/docker-compose.yml

DATA_DIR		= /home/paprzyby/data

all: setup
	docker-compose -f $(COMPOSE_FILE) up --build -d
#Builds all images and starts all contatiner

setup:
	mkdir -p $(DATA_DIR)/mariadb
	mkdir -p $(DATA_DIR)/wordpress
#Creates the host directories before Docker tries to mount them as volumes

down:
	docker-compose -f $(COMPOSE_FILE) down
#Stops and removes containers and the network. Does not delete volumes or images.

re: down all
#Rebuilds everything

clean: down
	docker system prune -af
	docker volume prune -f
#Stops containers, then removes all unused images, containers, networks and volumes from Docker.
fclean: clean
	rm -rf $(DATA_DIR)
#Clean and the deletes the actual WordPress and MariaDB data from the host.

.PHONY: all setup down re clean fclean
