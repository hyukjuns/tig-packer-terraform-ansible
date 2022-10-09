# Install TIG Stack by Packer, Terraform, Ansible
Packer를 사용해 InfluxDB, Grafana, Ansible이 설치된 Monitoring 서버 이미지를 만든 후 Terraform을 사용해 가상머신을 Provisioning 한 뒤, Ansible을 사용해 모니터링 대상 VM에 Telegraf 에이전트를 Deploy 합니다.

## Workflows
1. **Build** monitoring server image by Packer
2. **Provisioning** monitoring server vm by Terraform
3. **Deploy** telegraf agent by Ansible

## Prerequistes
1. Azure Credentials
2. Packer >= 1.8.3
3. Terraform >= 1.3.1
4. Ansible >= 2.9.27
5. Bash (perl, sed)

## Usage
1. Packer
2. Terraform
3. Ansible

## Tags
- v1.0 -> Terraform, Asnible을 사용한 TIG Stack 구축
- v2.0 부터는 Packer를 도입합니다.