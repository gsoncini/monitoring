#!/bin/bash

HOST="localhost"
PORT="9100"

# run script as root or with sudo

# install nginx and openssl
apt -y install nginx openssl apache2-utils

# generate ssl certificate (host prometheus.example.com)
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -subj '/CN=prometheus.example.com' -nodes
mv key.pem /etc/ssl/private/nginx.pem
chmod 600 /etc/ssl/private/nginx.pem
mv cert.pem /etc/ssl/certs/nginx.pem

echo 'server {
  listen 3031;
  ssl    on;
  ssl_certificate /etc/ssl/certs/nginx.pem;
  ssl_certificate_key /etc/ssl/private/nginx.pem;
  location / {
    proxy_pass http://'${HOST}':'${PORT}'/;
    auth_basic "Node_Exporter";
    auth_basic_user_file /etc/nginx/.htpasswd;
  }
}' > /etc/nginx/sites-enabled/node_exporter

systemctl enable nginx
systemctl restart nginx

# After execute Script:
# htpasswd -c /etc/nginx/.htpasswd admin
