#!/bin/bash
BLACKBOX_EXPORTER_VERSION="0.24.0"
wget https://github.com/prometheus/blackbox_exporter/releases/download/v${BLACKBOX_EXPORTER_VERSION}/blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xzvf blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-amd64.tar.gz
cd blackbox_exporter-${BLACKBOX_EXPORTER_VERSION}.linux-amd64
cp blackbox_exporter /usr/local/bin

# Create directory
mkdir -p /etc/blackbox/

# Copy config
cp blackbox.yml /etc/blackbox/blackbox.yml

# Create user
useradd --no-create-home --shell /bin/false blackbox_exporter

# Set permitions
chown blackbox_exporter:blackbox_exporter /usr/local/bin/blackbox_exporter
chown -R blackbox_exporter:blackbox_exporter /etc/blackbox/

echo '[Unit]
Description=Blackbox Exporter Service
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=blackbox_exporter
Group=blackbox_exporter
ExecStart=/usr/local/bin/blackbox_exporter \
  --config.file=/etc/blackbox/blackbox.yml \
  --web.listen-address=":9115"

Restart=always

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/blackbox_exporter.service

# Enable node_exporter in systemctl
systemctl daemon-reload
systemctl start blackbox_exporter
systemctl enable blackbox_exporter
