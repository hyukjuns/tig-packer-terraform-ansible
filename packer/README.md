# Packer
Make Monitoring VM Image

# Usage
### Prerequire
- **Azure App registration**
    
    Using by packer,

    To use packer's Pre-vm provisioning and make Managed Image

- **Azure Resourece Group**<br>
    
    To use making Pakcer's Managed Image

### Steps
1. Edit variables.pkrvars.hcl

    ```
    # App info
    client_id       = ""
    client_secret   = ""
    subscription_id = ""
    tenant_id       = ""

    # Managed Image info
    managed_image_resource_group_name = ""
    managed_image_name                = ""

    # Inflxudb info
    influxdb_name = ""
    influxdb_username = ""
    influxdb_password = ""
    ```

2. Vaildate 

    ```packer validate -var-file=variables.pkrvars.hcl .```

3. Build 

    ```packer build -var-file=variables.pkrvars.hcl .```

4. Keep Managed Image's Id to use Terraform Provisionig

# Info
### Software Versions
- influxdb v1.8.10
- telegraf v1.27.1
- grafana stable latest
- ansilbe stable latest

### Script file
- software.sh

### Grafana Dashboard
- import number: ```928```

### Base image
#### urn > publisher:offer:sku:version
```
Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:20.04.202307010
```
#### JMEpath query
```
az vm image list -f 0001-com-ubuntu-server-focal -p Canonical --all --query "[?sku=='20_04-lts-gen2']"
```
