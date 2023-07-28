#!/bin/bash
# PushGateway Version
PUSHGW_VERSION="1.6.0"
wget https://github.com/prometheus/pushgateway/releases/download/v${PUSHGW_VERSION}/pushgateway-${PUSHGW_VERSION}.linux-amd64.tar.gz
tar -xvf pushgateway-${PUSHGW_VERSION}.linux-amd64.tar.gz

#Create the pushgateway user:
useradd --no-create-home --shell /bin/false pushgateway

#Move the binary in place and update the permissions to the user that we created:
cp pushgateway-${PUSHGW_VERSION}.linux-amd64/pushgateway /usr/local/bin/pushgateway
chown pushgateway:pushgateway /usr/local/bin/pushgateway

#Create the systemd unit file:
cat >/etc/systemd/system/pushgateway.service <<EOF
[Unit]
Description=Prometheus Pushgateway
Wants=network-online.target
After=network-online.target
[Service]
User=pushgateway
Group=pushgateway
Type=simple
ExecStart=/usr/local/bin/pushgateway
[Install]
WantedBy=multi-user.target
EOF

#Reload systemd and restart the pushgateway service:
systemctl daemon-reload
systemctl restart pushgateway

#Ensure that pushgateway has been started:
systemctl status pushgateway
