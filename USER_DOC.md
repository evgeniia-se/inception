# USER DOCUMENTATION

### 🗂️ Provided Services
The infrastructure provisions a secure web publishing environment containing:
*   **NGINX Web Server**: Serves as the TLS gateway (Port 443).
*   **WordPress Platform**: Delivers the CMS framework powered by PHP-FPM.
*   **MariaDB Database**: Manages data models and transaction storage.


### 🚀 Control Commands (Start & Stop)
Run these lifecycle operations from the repository root:
*   Start Stack: `make` (or `docker compose -f srcs/docker-compose.yml up -d`)
*   Stop Stack: `make down` (or `docker compose -f srcs/docker-compose.yml down`)


### 🌐 Web & Administration Access
*   Public Site: Access via secure browser address: `https://esergeev.42.fr`
*   Administration Dashboard: Access via management console: `https://esergeev.42.fr/wp-admin`


### 🔐 Credentials
All credentials are stored in `srcs/.env` — this file is git-ignored and never committed to the repository.
Variable:
WP_ADMIN_USER / WP_ADMIN_PASSWORD	WordPress admin login
WP_USER / WP_USER_PASSWORD	 		WordPress author login
MYSQL_USER / MYSQL_PASSWORD			Database user access
MYSQL_ROOT_PASSWORD					Database root access


### 🩺 System Health and Integrity Checks
Are the containers running?

`docker ps`   All three containers (nginx, wordpress, mariadb) should appear as "Up"


# Check container logs

`docker logs nginx`       NGINX output
`docker logs wordpress`   WordPress / PHP-FPM output
`docker logs mariadb`     MariaDB output

# PID 1 verification

`docker exec -it wordpress ps ax`          # PHP-FPM must be PID 1
`docker exec -it nginx cat /proc/1/cmdline`  # NGINX must be PID 1
