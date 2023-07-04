#!/bin/bash

DATABASE=""
DB_USERNAME=""
$DB_PASSWORD=""
#-----------------------------------
# Influxdb v1.8.10
# Ubuntu/Debian AMD64
echo 
echo "=====Install InfluxDB====="
echo
wget https://dl.influxdata.com/influxdb/releases/influxdb_1.8.10_amd64.deb
dpkg -i influxdb_1.8.10_amd64.deb
systemctl enable --now influxdb
curl "http://localhost:8086/query" --data-urlencode "q=CREATE DATABASE "$DATABASE""
curl "http://localhost:8086/query" --data-urlencode "q=CREATE USER $DB_USERNAME WITH PASSWORD '$DB_PASSWORD' WITH ALL PRIVILEGES"
curl "http://localhost:8086/query" --data-urlencode "q=GRANT ALL PRIVILEGES TO "$DB_USERNAME""
sed -i "s/# auth-enabled = false/auth-enabled = true/g" /etc/influxdb/influxdb.conf
systemctl restart influxdb


#-----------------------------------
# telegraf v1.27.1
# Ubuntu/Debian
echo 
echo "=====Install Telegraf====="
echo
wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list
sudo apt-get update && sudo apt-get install telegraf

# # RHEL/CentOS
# echo 
# echo "=====Install Telegraf====="
# echo
# cat <<EOF | sudo tee /etc/yum.repos.d/influxdata.repo
# [influxdata]
# name = InfluxData Repository - Stable
# baseurl = https://repos.influxdata.com/stable/\$basearch/main
# enabled = 1
# gpgcheck = 1
# gpgkey = https://repos.influxdata.com/influxdata-archive_compat.key
# EOF
# sudo yum install -y telegraf

# Setup
telegraf config > telegraf-custom.conf --output-filter=influxdb
# IP Check tool
apt install -y net-tools
# get server internalip
SERVER_IP=$(ifconfig | awk 'NR==2 {print $2}')
# sed telegraf-custom.conf
sed -i "s/\# urls = \[\"http:\/\/127.0.0.1\:8086\"\]/urls = \[\"http:\/\/$SERVER_IP\:8086\"\]/" telegraf-custom.conf
sed -i "s/\# database = \"telegraf\"/database = \"$DATABASE\"/" telegraf-custom.conf
sed -i "s/\# username = \"telegraf\"/username = \"$DB_USERNAME\"/" telegraf-custom.conf
sed -i "s/\# password = \"metricsmetricsmetricsmetrics\"/password = \"$DB_PASSWORD\"/" telegraf-custom.conf

cp telegraf-custom.conf /etc/telegraf/telegraf.d/
systemctl enable --now telegraf

#-----------------------------------
# grafana
echo 
echo "=====Install Grafana====="
echo
apt-get install -y apt-transport-https
apt-get install -y software-properties-common wget
wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list
apt-get update -y
apt-get install -y grafana
systemctl enable --now grafana-server

#-----------------------------------
# ansible
# "sudo apt update -y",
# "sudo apt install -y software-properties-common",
# "sudo add-apt-repository --yes --update ppa:ansible/ansible",
# "sudo apt install -y ansible"