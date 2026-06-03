*This project has been created as part of the 42 curriculum by esergeev*


## 📝 Description

This project aims to broaden the knowledge of system administration by using **Docker Compose** to build a small infrastructure of isolated services. Every service runs inside its own dedicated container, built from a clean, specific base image, ensuring strict network isolation, health monitoring, and data persistence without reliance on ready-made third-party images.

The stack consists of the following interconnected microservices:
* **NGINX**: The single entry point to the infrastructure, strictly serving over **TLS v1.2/v1.3** on port 443.
* **WordPress with PHP-FPM**: The dynamic content management system, fully pre-configured via `wp-cli`(WordPress Command Line Interface).
* **MariaDB**: The relational database management system, initialized securely with non-root privileges.


## 📐 Architecture & Infrastructure Overview

All containers communicate through a custom isolated **Docker Bridge Network**.
* **No `network: host` or `links:`** are utilized, adhering to strict infrastructure constraints.
* Inter-container communication relies entirely on Docker's internal **DNS service discovery** by utilizing service names as hostnames (e.g., `mariadb`, `wordpress`).
* Data persistence is achieved via independent Docker **Volumes**, mapped to the host's dedicated directory structural guidelines (`/home/esergeev/data/`).


## Service Interaction

NGINX receives an `HTTPS` request from the browser on **port 443**.
->
If the request is for a `.php file`, it acts as a reverse proxy and forwards the request to `WordPress (PHP-FPM)` via the FastCGI protocol on **port 9000**.
->
WordPress processes the core application logic and queries MariaDB on **port 3306** over the private Docker Network if data is needed.
->
MariaDB returns the requested data to WordPress, which builds a standard **HTML** page.
->
The final result is sent back through **NGINX** directly to the user's browser.



## 🚀 Instructions

### Prerequisites
* A Debian-based GNU/Linux environment.
* `docker` and `docker-compose` (or the integrated `docker compose` plugin) installed.
* `make` utility installed.

### Setup & Credentials
Due to security restrictions, sensitive authentication data (passwords, database names, administrative logins) **must not** be committed to the Git repository.

1.  Create a `.env` file inside the `srcs/` directory before triggering the initialization.
2.  Populate it using the following structural baseline (adjust names and values dynamically):

```env
# Global Infrastructure Settings
DOMAIN_NAME=esergeev.42.fr

# MySQL / MariaDB Configuration
MYSQL_DATABASE=inception_db
MYSQL_USER=wp_user
##
MYSQL_PASSWORD=user_pass
##
MYSQL_ROOT_PASSWORD=root_pass

# WordPress Configuration
WP_ADMIN_USER=wp_boss
##
WP_ADMIN_PASSWORD=boss_pass
WP_ADMIN_EMAIL=esergeev@student.42.fr

WP_USER=wp_author
##
WP_USER_PASSWORD=wp_user_pass
WP_USER_EMAIL=author@example.com

