#!/bin/bash

# Install Grafana 8 on Ubuntu 22.04|20.04|18.04

# Add Grafana gpg key which allows you to install signed packages
sudo apt-get install -y gnupg2 curl software-properties-common
curl https://packages.grafana.com/gpg.key | sudo apt-key add -

# Then install Grafana APT repository
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

apt-get update 
apt-get install grafana -y 
systemctl daemon-reload 
systemctl start grafana-server 
systemctl enable grafana-server.service 

# Install Nginx + Letsencrypt (Certbot)

sudo apt update
sudo apt install nginx

sudo add-apt-repository ppa:certbot/certbot
sudo apt update
sudo apt install python-certbot-nginx

echo 'server {
  listen 80;
  root /usr/share/nginx/www;
  index index.html index.htm;
  server_name grafana.domain.com;
  location /grafana/ {
   proxy_pass http://localhost:3000/;
  }
}' > /etc/nginx/sites-avaliable/default
 
systemctl restart nginx
 
sudo certbot --nginx -d grafana.dominio.com

# Select Option 2 for automatic redirect HTTPS

