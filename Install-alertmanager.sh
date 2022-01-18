#!/bin/bash
ALERTMANAGER_VERSION="0.23.0"
wget https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
tar xvzf alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
cd alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/

useradd --no-create-home --shell /bin/false alertmanager 

# Create directories
mkdir /etc/alertmanager
mkdir /etc/alertmanager/template
mkdir -p /var/lib/alertmanager/data

# Create config
touch /etc/alertmanager/alertmanager.yml

# Set ownership
chown -R prometheus:prometheus /etc/alertmanager
chown -R prometheus:prometheus /var/lib/alertmanager

# Copy binaries
cp alertmanager /usr/local/bin/
cp amtool /usr/local/bin/

# Set ownership
chown prometheus:prometheus /usr/local/bin/alertmanager
chown prometheus:prometheus /usr/local/bin/amtool

# Setup systemd
echo '[Unit]
Description=alertmanager
Wants=network-online.target
After=network-online.target
 
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/alertmanager --config.file=/etc/alertmanager/alertmanager.yml --storage.path /var/lib/alertmanager/data
 
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/alertmanager.service

systemctl daemon-reload
systemctl enable alertmanager
systemctl start alertmanager

# Restart prometheus
systemctl restart prometheus


echo "(1/2)Instalacao Completada.
Adicionar os seguintes dados em /etc/alertmanager/alertmanager.yml:

global:
  smtp_smarthost: 'localhost:25'
  smtp_from: 'alertmanager@prometheus.com'
  smtp_auth_username: ''
  smtp_auth_password: ''
  smtp_require_tls: false

templates:
- '/etc/alertmanager/template/*.tmpl'

route:
  repeat_interval: 1h
  receiver: operations-team

receivers:
- name: 'operations-team'
  email_configs:
  - to: 'operations-team+alerts@example.org'
  slack_configs:
  - api_url: https://hooks.slack.com/services/XXXXXX/XXXXXX/XXXXXX
    channel: '#prometheus-course'
    send_resolved: true
 "

  echo "(2/2) Instalacao Completada.
Adicione os seguintes dados em /etc/prometheus/prometheus.yml:

alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - localhost:9093"


