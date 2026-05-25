FROM debian:bookworm

# Update package manager and install PHP with required extensions, plus curl and wget
#PHP-FPM умеет работать как сервер: он садится на порт 9000 и слушает запросы от Nginx
#php8.2-mysql — «Мост» между WordPress и базой данных. SQL-запросы в контейнер MariaDB
#и сможет сохранять статьи или пароли.
#wget и curl — Инструменты-скачиватели.
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Copy the PHP-FPM pool configuration file
COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copy the initialization script
COPY ./tools/setup_wordpress.sh /setup_wordpress.sh
RUN chmod +x /setup_wordpress.sh

# Expose the port PHP-FPM listens on (as seen in the subject diagram)
EXPOSE 9000

# Run the setup script on container startup
ENTRYPOINT ["sh", "/setup_wordpress.sh"]
