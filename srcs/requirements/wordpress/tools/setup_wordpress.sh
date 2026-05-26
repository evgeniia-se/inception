#!/bin/sh

# Wait for MariaDB to be fully up and running before installing WordPress
# (We will use a simple sleep for now, but it's crucial since DB takes time to start)
sleep 5

# Navigate to the directory where WordPress should be installed
cd /var/www/wordpress

# Check if WordPress is already downloaded to avoid overwriting data
if [ ! -f "-sin.php" ] && [ ! -f "index.php" ]; then
    echo "📥 Downloading WordPress via wp-cli..."

    # Download the command-line tool for managing WordPress (wp-cli)
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar

    # Download the core WordPress files
    ./wp-cli.phar core download --allow-root

    # Create the wp-config.php file using environment variables from .env
    # Note: These variables (MYSQL_DATABASE, MYSQL_USER, etc.) will come from docker-compose
    ./wp-cli.phar config create --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb:3306

    # Install WordPress and set up the Administrator account (No 'admin' in username!)
    ./wp-cli.phar core install --allow-root \
        --url=${DOMAIN_NAME} \
        --title="Inception Blog" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

    # Create the second ordinary user as required by the subject
    ./wp-cli.phar user create --allow-root \
        ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=author

    # Clean up wp-cli if not strictly needed, or leave it for future use
    mv wp-cli.phar /usr/local/bin/wp
fi

echo "🚀 Starting PHP-FPM..."

# Start PHP-FPM 8.2 in the foreground (--nodaemonize) to satisfy PID 1 requirement
# We create the directory for the PID file first, just in case
mkdir -p /run/php
exec /usr/sbin/php-fpm8.2 --nodaemonize
