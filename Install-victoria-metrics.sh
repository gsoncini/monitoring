#!/bin/bash
# Git
git clone https://github.com/VictoriaMetrics/VictoriaMetrics.git
# Docker
curl -fsSL https://get.docker.com | sh; >/dev/null
systemctl start docker
systemctl enable docker

cd VictoriaMetrics/
Make

cd bin
cp victoria-metrics-prod /usr/local/bin/

# Set ownership
chown victoriametrics:victoriametrics /usr/local/bin/victoria-metrics-prod

# Create directories
mkdir /var/lib/victoriametrics
mkdir /run/victoriametrics/

# Set ownership
chown victoriametrics.victoriametrics -R /var/lib/victoriametrics/
chown victoriametrics.victoriametrics -R /run/victoriametrics/

echo '[Unit]
Description=VictoriaMetrics
After=network.target

[Service]
User=victoriametrics
Group=victoriametrics
Type=simple
StartLimitBurst=5
StartLimitInterval=0
Restart=on-failure
RestartSec=1
PIDFile=/run/victoriametrics/victoriametrics.pid
ExecStart=/usr/local/bin/victoria-metrics-prod -storageDataPath /var/lib/victoriametrics -rentionPeriod 90
ExecStop=/bin/kill -s SIGTERM $MAINPID

[Install]
WantedBy=multi-user.target

[Service]
LimitNOFILE=32000
LimitNPROC=32000' > /etc/systemd/system/victoriametrics.service

