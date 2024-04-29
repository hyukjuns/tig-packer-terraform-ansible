#!/bin/bash

# InfluxDB v1 (1.8.10)
echo "---> Add GPG Key and deb file"
wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list

echo "---> Install InfluxDB v1"
sudo apt-get update -y && sudo apt-get install influxdb

echo "---> Enable InfluxDB v1"
systemctl enable --now influxdb

# Telegraf 1.30.2
echo "--> Add GPG Key and Repository"
curl -s https://repos.influxdata.com/influxdata-archive_compat.key > influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list

echo "---> Install Telegraf Agent"
sudo apt-get update -y && sudo apt-get install telegraf

# Grafana v10.4 
echo "---> Install the prerequisite packages:"
sudo apt-get install -y apt-transport-https software-properties-common wget

echo "---> Import the GPG key:"
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

echo "---> To add a repository for stable releases:"
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

echo "--> Updates the list of available packages"
sudo apt-get update

echo "---> Installs the latest OSS release:"
sudo apt-get install grafana

echo "---> Start & Enable Grafana Server"
systemctl enable --now grafana-server

# Grafana v7.3.7
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/oss/release/grafana_7.3.7_amd64.deb
sudo dpkg -i grafana_7.3.7_amd64.deb

