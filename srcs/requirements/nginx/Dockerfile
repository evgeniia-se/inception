FROM debian:bookworm

# Update the package manager and install required utilities
#apt-get(like google play)
#nginx - veb-server
#ssl(secret key) for security protocol https
#curl(consol browser)
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    nginx \
    openssl \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Remove the default Nginx configuration file
RUN rm -f /etc/nginx/nginx.conf

# Copy custom configuration and initialization script
#etc(system folder in Debian): nginx created own folder in container
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./tools/setup_nginx.sh /setup_nginx.sh

# Grant execution permissions to the script
RUN chmod +x /setup_nginx.sh

# Expose the standard HTTPS port
EXPOSE 443

# Execute the setup script on container startup
#sh = we ask : run commandnuiy obolochky sh
ENTRYPOINT ["sh", "/setup_nginx.sh"]
