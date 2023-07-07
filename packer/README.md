# Packer
Make Monitoring VM Image

# Usage
### Prerequire
- **Azure App registration**
    
    Azure Service Principal, Packer가 이미지 빌드시 사용합니다.

- **Azure Resourece Group**<br>
    
    Packer로 만든 관리 이미지가 저장되는 리소스 그룹입니다.

### Step
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

>Output으로 나오는 Managed Image ID를 메모해주세요, 테라폼으로 VM 배포할때 사용합니다.

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
