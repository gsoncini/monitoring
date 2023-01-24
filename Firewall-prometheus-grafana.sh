#!/bin/bash
# Firewall Grafana + Prometheus + Node Exporter
# Variables
# -------------------------------------------------------
iptables -F
iptables -X
iptables -F -t nat
iptables -X -t nat
iptables -F -t mangle
iptables -X -t mangle

# Default Policy
# -------------------------------------------------------
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#################################################
# FILTER                                        #                                     
#################################################
 
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED,NEW -j ACCEPT
 
# Permit Loopback
# -------------------------------------------------------
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -t filter -A INPUT -j ACCEPT -i lo
# Permit Local Networks
# -------------------------------------------------------
iptables -I INPUT -s 127.0.0.1 -j ACCEPT
iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT
iptables -A INPUT -s 172.16.0.0/12 -j ACCEPT
# Permit General Services
# -------------------------------------------------------
iptables -A INPUT -p tcp --dport 22 -j ACCEPT # SSH
# HTTP/HTTPS
# -------------------------------------------------------
iptables -A INPUT -p tcp --dport 443 -j ACCEPT # HTTPS
iptables -A INPUT -p tcp --dport 80 -j ACCEPT # HTTP
iptables -A INPUT -p tcp --dport 3000 -j ACCEPT # GRAFANA
iptables -A INPUT -p tcp --dport 9100 -j DROP # NODE_EXPORTER
iptables -A INPUT -p tcp --dport 9090 -j DROP # PROMETHEUS


