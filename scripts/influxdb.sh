#!/bin/sh

# InfluxDB 설치
wget https://dl.influxdata.com/influxdb/releases/influxdb_1.8.5_amd64.deb
sudo dpkg -i influxdb_1.8.5_amd64.deb

# Config 수정
curl "http://localhost:8086/query" --data-urlencode "q=CREATE DATABASE "<DBNAME>""
curl "http://localhost:8086/query" --data-urlencode "q=CREATE USER <USERNAME> WITH PASSWORD '<PASSWORD>' WITH ALL PRIVILEGES"
curl "http://localhost:8086/query" --data-urlencode "q=GRANT ALL PRIVILEGES TO "<USERNAME>""
sudo sed -i "s/# auth-enabled = false/auth-enabled = true/g" /etc/influxdb/influxdb.conf

# 서비스 시작
sudo systemctl start influxd
sudo systemctl enable influxdb

## User Create Command
# influx \
#   -precision 'rfc3339' \
#   -host '*' -port '8086' \
#   -username '' -password '' \
#   -database ''
