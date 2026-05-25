#!/bin/sh

# Ensure the directory for SSL certificates exists inside the container
mkdir -p /etc/nginx/ssl

# Check if the SSL certificate already exists to avoid regeneration on restart
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
	echo " Generating SSL certificate for Inception..."

# Generate a self-signed SSL certificate using openssl
    # -x509: outputs a self-signed certificate instead of a certificate request
    # -nodes: skips the option to secure the certificate with a passphrase (so Nginx can start automatically)
    # -days 365: certificate valid for one year
    # -subj: automatically fills the certificate information with your 42 data
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42Paris/CN=esergeev.42.fr"
fi

echo "🚀 Starting Nginx..."

# Start Nginx in the foreground (daemon off;) as required by PID 1 rules
exec nginx -g "daemon off;"
