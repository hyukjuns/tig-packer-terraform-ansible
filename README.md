### 남은 미션
1. Ansible User 권한 구체화
2. Windows 추가
3. ansible-galaxy로 role 생성
4. Azure의 Dynamic Inventory사용 
5. Terraform Grafana Provider

# TIG Monitoring Provision & Configuration
### 소개
***terraform apply 한번으로 TIG Monitoring Service 배포 및 구성까지***
<p>Terraform으로 Monitor Server를 생성힘과 동시에 Ansible playbook을 Trigger하여 Monitoring Service를 구성하고 Agent를 배포합니다.</p>

***시나리오***
```
운영중인 Production 환경에 Monitoring서비스를 구축하는 시나리오로 가정,
따라서 Target Server들과 Vnet,Subnet은 이미 존재하며 그 안에 monitor server를 생성
```
- 사전 구성 필요
    - infra: vnet, subnet, nsg
    - ansbile/telegraf 디렉토리
        - inventory.ini -> 타겟 서버 ip 및 ansible user 정의
        - telegraf.conf -> db server url, db name, db user, db user password
    - ansbile user의 sudo권한 필요
        - become_method는 sudo이므로 ansible user는 sudo 명령을 사용할 수 있어야 함
        - andible.cfg -> become method 정의
        - inventory.ini -> ansbile_user 정의
    - grafana_influxdb_ansible.yml
        - influxdb의 database, 사용자 및 비밀번호 셋팅 필요
### Diagram
![archi](./images/tig.svg)

### Skill Stack
- ***Terraform 0.14.10***
- ***Ansible 2.10.7***
- ***Bash Shell Script***
### Working Flow
**Step 1. Provision & Configure Monitor server**
1. Enter ***terraform apply***
    - Provisioning Monitor Server(Ubuntu 18.04) (생성 후 자동으로 ansible 실행)
    - Auto Triggered Ansbile playbook<br>
        ***Ansible Tasks***
        - Deploy InfluxDB(+ Create DB and User)
        - Deploy Grafana
        - Deploy Ansible Engine(+ Copy Telegraf Workspace to Monitor server)

**Step 2. Deploy Telegraf to Target Servers** 
1. Monitor server 접속
2. telegraf Workspace - inventory 작업(타겟 private ip 및 user 등록)
3. Playbook 실행 -> Telegraf Agent 배포 완료

### 실행 화면
1. local에서 terraform apply -> 서버 프로비젼 후 ansible 자동 트리거
![autotrigger](./images/AutoTriggering.png)
2. monitor server에서 ansible-playbook 실행 -> telegraf agent 배포
![deploy_telegraf](./images/deploy_telegraf.png)
3. Dashboard
![dashboard](./images/dashboard.png)
![dashboard2](./images/dashboard2.png)