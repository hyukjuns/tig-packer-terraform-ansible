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
#   -host '*' -port '8086' \
#   -username '' -password '' \
#   -database ''
