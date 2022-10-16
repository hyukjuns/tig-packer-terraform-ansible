# Demo
## 데모 시나리오용 가상머신, 네트워크 생성
### 배포목록
1. Network: 1 Vnet, 2 Subnet (target, mgmt)
2. Target server : ubuntu 1, centos 1

### 변수
- terraform.tfvars
    ```
    admin_username="username"
    admin_password="password"
    ```
- output
    ```
    ubuntu private ip
    centos private ip
    ```