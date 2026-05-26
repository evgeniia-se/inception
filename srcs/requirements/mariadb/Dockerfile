FROM debian:bookworm
#mariadb-server -bd
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	mariadb-server \
	curl \
	vim \
    && rm -rf /var/lib/apt/lists/*

# Copy our custom configuration to allow external connections (from WordPress)
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/setup_mariadb.sh /setup_mariadb.sh
RUN chmod +x /setup_mariadb.sh

EXPOSE 3306

# Run the setup script on container startup
ENTRYPOINT ["sh", "/setup_mariadb.sh"]
