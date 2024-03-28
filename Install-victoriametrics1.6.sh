#!/bin/bash
groupadd -r victoriametrics
useradd -g victoriametrics -d /var/lib/victoriametrics -s /sbin/nologin --system victoriametrics
apt install jq curl -y

curl -L https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v1.64.1/victoria-metrics-amd64-v1.64.1.tar.gz --output victoria-metrics-amd64-v1.64.1.tar.gz

export VM_VER=`curl -s https://api.github.com/repos/VictoriaMetrics/VictoriaMetrics/releases/latest | jq -r '.tag_name'` && curl -L https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/${VM_VER}/victoria-metrics-amd64-${VM_VER}.tar.gz --output victoria-metrics-amd64-${VM_VER}.tar.gz

tar xvf victoria-metrics-amd64-*.tar.gz -C /usr/local/bin/

chown -v root:root /usr/local/bin/victoria-metrics-prod

mkdir -v /var/lib/victoria-metrics-data
chown -v victoriametrics:victoriametrics /var/lib/victoria-metrics-data


vi /etc/systemd/system/victoriametrics.service



echo '[Unit]
Description=High-performance, cost-effective and scalable time series database, long-term remote storage for Prometheus
After=network.target
[Service]
Type=simple
User=victoriametrics
Group=victoriametrics
StartLimitBurst=5
StartLimitInterval=0
Restart=on-failure
RestartSec=1
ExecStart=/usr/local/bin/victoria-metrics-prod \
        -storageDataPath=/var/lib/victoria-metrics-data \
        -httpListenAddr=127.0.0.1:8428 \
        -retentionPeriod=1
ExecStop=/bin/kill -s SIGTERM $MAINPID
LimitNOFILE=65536
LimitNPROC=32000
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/victoriametrics.service

systemctl daemon reload
systemctl enable victoriametrics.service --now
systemctl start victoriametrics.service


#-storageDataPath - o caminho do diretório de dados. A VictoriaMetrics armazena todos os dados neste diretório.

#-httpListenAddr - O endereço IP e a porta na qual a VictoriaMetrics ouvirá. Se você quiser se conectar ao VictoriaMetrics não apenas a partir do localhost (127.0.0.1), especifique 0.0.0.0:8428. Neste caso, usado 127.0.0.1 porque o vmauth (para autenticação) será usado para conexão externa e será encaminhado todas as consultas para a VictoriaMetrics.

#-retentionPeriod - retenção para dados armazenados. Os dados mais antigos são excluídos automaticamente. retentionPeriod=1 significa que os dados serão armazenados por 1 mês e depois excluídos.
