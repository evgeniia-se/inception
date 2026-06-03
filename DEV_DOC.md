# DEVELOPER DOCUMENTATION

## Prerequisites

Ensure the following tools are installed on Debian-based GNU/Linux environment:

`sudo apt-get update && sudo apt-get install -y docker-ce docker-compose-plugin make`

Secrets & Configuration

Sensitive credentials must not be committed to the repository. Before the first launch, create the .env file manually:

`cp srcs/.env.template srcs/.env`
`nano srcs/.env`

Populate it using the following template — replace all placeholder values with secure ones:


# Build & Launch

All commands are run from the project root.

`make`        # Build images and start all containers
`make down`   # Stop and remove containers
`make clean`  # Stop containers and remove volumes
`make re`     # Full rebuild from scratch

# Container Management
General Status

`docker ps`                  # List active containers and exposed ports
`docker logs esergeev`         # Stream output from a container's init script
`docker volume ls`           # List all volumes

PID 1 Compliance

Every service must run its binary natively as PID 1. Patterns like sleep infinity or tail -f /dev/null are non-compliant.

# Verify PHP-FPM is PID 1 in the WordPress container
`docker exec -it wordpress ps ax`

# Verify NGINX binary is PID 1
`docker exec -it nginx cat /proc/1/cmdline`

# Network Isolation

Services must communicate via the isolated bridge network — host networking is forbidden.

`docker network ls`                          # List active networks
`docker network inspect inception_network`   # Inspect inter-container links

# Data Persistence

All persistent data is mapped from Docker volumes to the host filesystem and survives container restarts.
Volume	Host Path
WordPress web files	/home/esergeev/data/wordpress
MariaDB database	/home/esergeev/data/mariadb

# Verify mount targets:

`docker volume inspect srcs_wordpress_data`
`docker volume inspect srcs_mariadb_data`
# The "Mountpoint" field must point to /home/esergeev/data/
