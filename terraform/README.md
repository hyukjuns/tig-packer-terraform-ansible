# Terraform
Provisiong Monitoring VM

# Usage
### Prerequire

- **Azure Account login in shell**
    
    테라폼을 실행하는 쉘에서 Azure에 로그인해주세요, 테라폼 자격증명으로 사용합니다.

- **Source Image ID**
    
    패커로 빌드한 Managed Image의 ID가 필요합니다.

### Step
1. Edit terraoform.tfvars

    ```
    # Monitor Server info
    resource_group_name = ""
    location            = ""
    monitor_server_name = ""
    source_image_id     = ""

    # Server admin info
    admin_username = ""
    admin_password = ""
    ```

2. Terraform plan and apply

    ```
    terraform plan
    terraform apply
    ```
# Info
### custom.sh
telegraf.conf 파일을 수정하는 스크립트 입니다. 모니터링 서버의 Private IP를 conf 파일에 넣어줍니다.

### dependency
```cusotm.sh > template_file.custom > azurerm_linux_virtual_machine.custom_data```
