#!/bin/bash

# Shell script - edit telegraf.conf 
sudo apt install -y net-tools

SERVER_IP=$(ifconfig | awk 'NR==2 {print $2}')
sudo sed -i "s/urls = \[\"http:\/\/127.0.0.1\:8086\"\]/urls = \[\"http:\/\/$SERVER_IP\:8086\"\]/" /etc/telegraf/telegraf.d/telegraf-custom.conf