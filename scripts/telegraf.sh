#!/bin/sh

# Telegraf 설치
wget https://dl.influxdata.com/telegraf/releases/telegraf_1.18.1-1_amd64.deb
sudo dpkg -i telegraf_1.18.1-1_amd64.deb

# Cofig 수정
sudo sed -i "/\[\[outputs.influxdb\]\]/a\urls = [\"http://<DB_SERVER_IP>:8086\"]" /etc/telegraf/telegraf.conf
sudo sed -i "/\[\[outputs.influxdb\]\]/a\database = \"<DATABASE>\"" /etc/telegraf/telegraf.conf

# 서비스 시작 
sudo systemctl daemon-reload
sudo systemctl start telegraf.service
sudo systemctl enable telegraf.service