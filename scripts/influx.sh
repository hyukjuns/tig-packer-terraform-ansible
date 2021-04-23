#!/bin/sh

# Install
wget https://dl.influxdata.com/influxdb/releases/influxdb_1.8.5_amd64.deb
sudo dpkg -i influxdb_1.8.5_amd64.deb


# # Set Configuration
# sudo sed -i "s/# auth-enabled = false/auth-enabled = true/g" /etc/influxdb/influxdb.conf

# Start Service
sudo systemctl start influxd
sudo systemctl enable influxdb

# influx \
#   -precision 'rfc3339' \
#   -host '[호스트]' -port '[포트번호]' \
#   -username '[유저네임]' -password '[비밀번호; 비워두면 물어봄]' \
#   -database '[데이터베이스 이름]'
# 쉘에 이렇게 하면 한번에 들어가나 보네요
