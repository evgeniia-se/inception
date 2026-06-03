# USER DOCUMENTATION

## 🗂️ Provided Services
The infrastructure provisions a secure web publishing environment containing:
*   **NGINX Web Server**: Serves as the TLS gateway (Port 443).
*   **WordPress Platform**: Delivers the CMS framework powered by PHP-FPM.
*   **MariaDB Database**: Manages data models and transaction storage.

## 🚀 Control Commands (Start & Stop)
Run these lifecycle operations from the repository root:
*   **Start Stack**: `make` (or `docker compose -f srcs/docker-compose.yml up -d`)
*   **Stop Stack**: `make down` (or `docker compose -f srcs/docker-compose.yml down`)

## 🌐 Web & Administration Access
*   **Public Site**: Access via secure browser address: `https://esergeev.42.fr`
*   **Administration Dashboard**: Access via management console: `https://esergeev.42.fr/wp-admin`

## 🔐 Credentials Management
All operational credentials are isolated inside the local configuration template:
*   **Location**: `srcs/.env` (This file is strictly excluded from Git tracking for security).
*   **Target Variables**: Contains keys for database access (`MYSQL_PASSWORD`), WordPress administrative access (`WP_ADMIN_PASSWORD`), and regular user setups.

## 🩺 System Health and Integrity Checks (No Background Hacks)
To guarantee that no bad practices (like forbidden loops or detached processes) are active, use these verification commands:

### 1. Process Master Status Verification (PID 1 Check)
Every service must run its binary natively as the master process (**PID 1**). Background execution strings like `sleep infinity` or `tail -f /dev/null` are absent.
```bash
# Verify WordPress is executing PHP-FPM natively as PID 1
docker exec -it wordpress ps ax

# Verify NGINX is handling traffic natively as PID 1
docker exec -it nginx cat /proc/1/cmdline
