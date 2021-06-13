#!/bin/sh

# install
wget https://dl.influxdata.com/telegraf/releases/telegraf_1.18.1-1_amd64.deb
sudo dpkg -i telegraf_1.18.1-1_amd64.deb

# Set Configuration
sudo sed -i "/\[\[outputs.influxdb\]\]/a\urls = [\"http://10.0.0.4:8086\"]" /etc/telegraf/telegraf.conf
sudo sed -i "/\[\[outputs.influxdb\]\]/a\database = \"telegrafdb\"" /etc/telegraf/telegraf.conf

# Start Service 
sudo systemctl daemon-reload
sudo systemctl start telegraf.service
sudo systemctl enable telegraf.service