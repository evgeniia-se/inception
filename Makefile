NAME = inception

COMPOSE_FILE = srcs/docker-compose.yml

DATA_DIR = /home/esergeev/data

all: build up

#folder for volume in vm before start of project
init:
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress

build: init
	docker compose -f $(COMPOSE_FILE) build

up:
	docker compose -f $(COMPOSE_FILE) up -d
#stop container
clean:
	docker compose -f $(COMPOSE_FILE) down

fclean: clean
	docker compose -f $(COMPOSE_FILE) down --rmi all --volumes
	@rm -rf $(DATA_DIR)/wordpress/*
	@rm -rf $(DATA_DIR)/mariadb/*
	@sudo rm -rf $(DATA_DIR) 2>/dev/null || true

re: fclean all

.PHONY: all init build up clean fclean re

