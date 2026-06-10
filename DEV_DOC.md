# DEVELOPER DOCUMENTATION

### Prerequisites

Ensure the following tools are installed on Debian-based GNU/Linux environment:

`sudo apt-get update && sudo apt-get install -y docker-ce docker-compose-plugin make`


### Secrets & Configuration

Sensitive credentials must not be committed to the repository. Before the first launch, create the .env file from the provided template:

`cp srcs/.env.template srcs/.env`
`nano srcs/.env`   # replace all placeholder values with secure ones

The template defines the following variables:

── Global ──────────────────────────────────────
DOMAIN_NAME=esergeev.42.fr

── MariaDB ─────────────────────────────────────
MYSQL_DATABASE=inception_db
MYSQL_USER=wp_user
MYSQL_PASSWORD=your_secure_user_pass
MYSQL_ROOT_PASSWORD=your_secure_root_pass

── WordPress Admin ──────────────────────────────
WP_ADMIN_USER=wp_boss
WP_ADMIN_PASSWORD=your_secure_boss_pass
WP_ADMIN_EMAIL=esergeev@student.42.fr

── WordPress Author ─────────────────────────────
WP_USER=wp_author
WP_USER_PASSWORD=your_secure_wp_user_pass
WP_USER_EMAIL=author@example.com

# Build & Launch

All commands are run from the project root.

`make`        Build images and start all containers
`make fclean`  # Stop and remove containers, volumes
`make re`     Full rebuild from scratch

# Container Management
General Status

`docker ps`                  List active containers and exposed ports
`docker logs esergeev`       Stream output from a container's init script
`docker volume ls`           List all volumes

PID 1 Compliance

Every service must run its binary natively as PID 1. Patterns like sleep infinity or tail -f /dev/null are non-compliant.

# Verify PHP-FPM is PID 1 in the WordPress container
`docker exec -it wordpress ps ax`

# Verify NGINX binary is PID 1
`docker exec -it nginx cat /proc/1/cmdline`

### Network Isolation

Services must communicate via the isolated bridge network — host networking is forbidden.

`docker network ls`                          List active networks
`docker network inspect inception_network`   Inspect inter-container links

# Data Persistence

All persistent data is mapped from Docker volumes to the host filesystem and survives container restarts.
Volume	Host Path
WordPress web files	/home/esergeev/data/wordpress
MariaDB database	/home/esergeev/data/mariadb

# Verify mount targets:

`docker volume inspect srcs_wordpress_data`
`docker volume inspect srcs_mariadb_data`

# The "Mountpoint" field must point to /home/esergeev/data/


# Change port and check resultat

1. nginx: 8443:443 in .yml
`docker compose ps` -> https://esergeev.42.fr:8443
for 8443:42
'nginx.conf' 		listen 42 ssl; etc.
'.env'				WP_URL=https://esergeev.42.fr:4242

2. wordpress(www.conf): listen = 9042
	nginx.conf fastcgi_pass wordpress:9042
`docker exec -it wordpress sh -c "grep -R 'listen =' /etc/php"`

3. mariadb(50-server.cnf): port = 3333
	setup_wordpress.sh: --dbhost=mariadb:3333
`docker exec -it mariadb mysql -u wp_user -p -e "SHOW VARIABLES LIKE 'port';"`
