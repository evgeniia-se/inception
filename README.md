*This project has been created as part of the 42 curriculum by esergeev*


## 📝 Description

This project aims to broaden the knowledge of system administration by using **Docker Compose** to build a small infrastructure of isolated services. Every service runs inside its own dedicated container, built from a clean, specific base image, ensuring strict network isolation, health monitoring, and data persistence without reliance on ready-made third-party images.

The srcs/ directory contains all custom **Dockerfiles**, configuration files, and shell scripts needed to build the entire infrastructure from scratch.

The stack consists of the following interconnected microservices:
* **NGINX**: The single entry point to the infrastructure, strictly serving over **TLS v1.2/v1.3** on port 443.
* **WordPress with PHP-FPM**: The dynamic content management system, fully pre-configured via `wp-cli`(WordPress Command Line Interface).
* **MariaDB**: The relational database management system, initialized securely with non-root privileges.


### Design Choices & Infrastructure Comparisons

* **Virtual Machines vs Docker**: VMs virtualize the hardware and require a full guest OS, consuming massive resources. Docker virtualizes only the OS kernel, making containers incredibly fast, lightweight, and efficient.

* **Secrets vs Environment Variables**: Environment variables (via `.env`) are injected into processes and are great for local setups, though visible in process trees. Docker Secrets are encrypted in-memory and safer for production. Here, a git-ignored `.env` provides the right balance of simplicity and security.

* **Docker Network vs Host Network**: The `host` network blindly exposes all container ports to the outside world. Our custom **Docker Bridge Network** securely isolates the environment, allowing internal DNS communication between WordPress and MariaDB, while leaving only NGINX accessible from the outside.

* **Docker Volumes vs Bind Mounts**: Bind mounts are hardcoded to the host's directory structure, causing portability issues. **Named Volumes** are fully managed by Docker, providing superior data persistence, performance, and security (safely mapped to `/home/esergeev/data`).


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

1. Local Domain Mapping
Before building the stack, bind the application domain to your local loopback interface so the browser knows where to route the traffic:
`echo "127.0.0.1 esergeev.42.fr" | sudo tee -a /etc/hosts`

2. Secrets & Configuration

Sensitive credentials must not be committed to the repository. Before the first launch, create the .env file manually based on the file `.env.template`:

`cp srcs/.env.template srcs/.env`
`nano srcs/.env`

### Execution

`make`        # Build images and start all containers
`make down`   # Stop and remove containers
`make clean`  # Stop containers and remove volumes
`make re`     # Full rebuild from scratch

Once running, access the site at https://esergeev.42.fr.


### Resources & AI Statement
References

Inception Tutorial            https://tuto.grademe.fr/inception/

Docker Compose Documentation  https://docs.docker.com/compose/

NGINX Official Setup Guides   https://nginx.org/en/docs/

MariaDB Server Administration https://mariadb.com/docs/


### AI Assistance Disclosure

Tool: Gemini (AI Collaborator).

Usage: AI was utilized to debug specific Bash execution logic, verify Docker Compose syntax parameters, and structure Markdown documentation for better readability.

Validation: Every AI-generated script line or configuration flag was manually reviewed, verified using docker compose config, and cross-checked against standard Unix administrative practices within a localized Virtual Machine to ensure full personal comprehension.


**************************
## 🔎 Evaluation Checklist

Quick commands to verify compliance before or during evaluation:

# No 'network: host' or 'links:' in docker-compose.yml
grep -n "network: host\|links:" srcs/docker-compose.yml

# Network is defined
grep -n "networks:" srcs/docker-compose.yml

# No '--link' in Makefile or scripts
grep -rn -e "--link" Makefile srcs/

# No background hacks in Dockerfiles (tail -f, sleep infinity, etc.)
grep -rn "tail -f\|sleep infinity\|tail -f /dev/null" srcs/

# Examine the Dockerfiles for debian:bookworm
grep -rn "^FROM" srcs/

# ENTRYPOINT must run a script, not a bare shell or background process
OK:   ENTRYPOINT ["sh", "my_script.sh"]
grep -rn "ENTRYPOINT" srcs/

# Ensure no infinite loop
\| in grep - if
grep -rn "sleep infinity\|tail -f /dev/null\|tail -f /dev/random\|while true\|sleep [0-9]" srcs/
