# Provisioning Mointor Server (VM)
모니터링 서버를 생성합니다.
## Usage
1. Packer로 생성한 Managed Image의 Resource ID를 확인합니다.
2. ```terraform.tfvars```를 작성합니다.
    - ```variables.tf```에 default값이 정의되지 않은 변수들을 정의합니다.
    - ```terraform.tfvars.example``` 참고
3. 모니터링 서버를 생성합니다.