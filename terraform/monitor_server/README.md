# Setting up monitor server

## Steps
1. Provisioning Monitor server (by Terraform)
    - Ubuntu 18.04
2. Edit Telegraf config and Make ansible inventory for monitor server (by Shell Script in Terraform's null_resource)
    - Edit telegraf config by Perl
    - Make ansible inventory within Monitor server info(ansible target), InfluxDB info(ansible variables)
        - Use InfluxDB info(ansible variables) in ansible-playbook (setup influxdb configuration)
        - Ex) Create database using inventory variables
            ```
            - name: Setting up InfluxDB Config 01 - Setup DB Name
              shell: curl "http://localhost:8086/query" --data-urlencode "q=CREATE DATABASE "{{ db_name }}""
            ```
2. Deploy and Config (by Ansible)
    - InfluxDB
    - Grafana
    - Ansible Engine (for Telegraf deploy to targets)
    - Copy Telegraf config file to monitor server

## Usage
1. Setup terraform.tfvars
    ```
    location = "koreacentral"
    admin_username = "username"
    admin_password = "password"
    influxdb_db_name = "dbname"
    db_admin_username = "username"
    db_admin_password = "password"
    ```
2. Plan & Apply
3. and After Provisioning, Ansible-Playbook will automatically triggered by Terraform