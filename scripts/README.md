# Install Software
- Influxdb
- Telegraf
- Grafana
- Ansible

# InfluxDB Setup query
```
CREATE DATABASE $DATABASE
CREATE USER $DB_USERNAME WITH PASSWORD '$DB_PASSWORD' WITH ALL PRIVILEGES
GRANT ALL PRIVILEGES TO $DB_USERNAME
sed -i "s/# auth-enabled = false/auth-enabled = true/g" /etc/influxdb/influxdb.conf
```
# telegraf troubleshoot
```
telegraf --debug
journalctl --no-pager -u telegraf
```
# telegraf config
```
[[outputs.influxdb]]
  urls = ["http://127.0.0.1:8086"]
  database = ""
  username = ""
  password = ""
```