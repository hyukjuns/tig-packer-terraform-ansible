# Terraform
Provisiong Monitoring VM

# Usage
### Prerequire

- **Azure Account login in shell**
    terraform's auth method is azcli credential (in user's shell)
- **Source Image ID**
    Managed Image ID (made by packer)

### Steps
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