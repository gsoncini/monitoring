#!/bin/bash
# Ubuntu and Debian
GRAFANA_VERSION="9.5.7"
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_${GRAFANA_VERSION}_amd64.deb
sudo dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb

systemctl daemon-reload 
systemctl start grafana-server 
systemctl enable grafana-server.service 

# Letsencrypt (Certbot) + Nginx
sudo add-apt-repository ppa:certbot/certbot
sudo apt update
sudo apt install python-certbot-nginx


# Add Conf on /etc/nginx/sites-avaliable/default
 
#echo 'server {
#  listen 80;
#  root /usr/share/nginx/www;
#  index index.html index.htm;
#  server_name grafana.dominio.com.br;
#  location /grafana/ {
#   proxy_pass http://localhost:3000/;
#  }
#}' > /etc/nginx/sites-avaliable/default
# 
#systemctl restart nginx
# 
#sudo certbot --nginx -d grafana.dominio.com.br
 
#Select the appropriate number [1-2] then [enter] (press 'c' to cancel): 
#Select Option 2


