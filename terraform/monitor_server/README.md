# Setting up monitor server

## Steps
1. Provisioning Monitor server (Terraform)
    - Ubuntu 18.04
2. Edit Configuration and Make inventory
    - edit telegraf config (Perl)
    - make ansible inventory
2. Deploy and Config (Ansible)
    - InfluxDB and Grafana and Ansible Engine

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