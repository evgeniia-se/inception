#!/bin/sh

# Ensure the database directory is initialized
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Initializing MariaDB database..."

    # Create temporary file with SQL commands to configure the database securely
    # Using environment variables provided by Docker Compose from .env
    cat << EOF > /tmp/init_db.sql
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Run MariaDB in bootstrap mode to execute our SQL initialization file
    # This sets up the database before the main server starts running publicly
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    mysqld --user=mysql --bootstrap < /tmp/init_db.sql
    rm -f /tmp/init_db.sql
fi

echo "🚀 Starting MariaDB Server..."

# Run MariaDB server in the foreground (PID 1 rule)
# --mysqld-safe helps recover from runtime crashes automatically
exec mysqld_safe --user=mysql
