NAME = inception

COMPOSE_FILE = srcs/docker-compose.yml

all: build up

#folder for volume in vm before start of project
init:
	@mkdir -p /home/$(USER)/data/mariadb
	@mkdir -p /home/$(USER)/data/wordpress

build: init
	docker compose -f $(COMPOSE_FILE) build

up:
	docker compose -f $(COMPOSE_FILE) up -d
#stop container
clean:
	docker compose -f $(COMPOSE_FILE) down

fclean: clean
	@echo "Attention: delete all containers, images and volumes etc."
	docker compose -f $(COMPOSE_FILE) down --rmi all --volumes
	@sudo rm -rf /home/$(USER)/data

re: fclean all

.PHONY: all init build up clean fclean re

