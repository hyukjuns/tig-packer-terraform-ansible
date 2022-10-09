# Build Image

## Software Versions
- Grafana: 설치 시점의 Stable Latest (2022.10월 기준 v9.1.7)
- InfluxDB: 1.8.x
- Ansible: 설치 시점의 Stable Latest (2022.10월 기준 v2.9.27)

## Usage
1. Image가 생성될 Resource Group 생성
    ```
    az group create -n <RG_NAME> -l <LOCATION>
    ```
2. ```variables.pkrvars.hcl``` 작성
    - variables.pkr.hcl에 선언된 변수들 중 ```default```값이 정의되지 않은 변수들을 정의합니다.
3. 이미지 생성
    ```
    packer validate -var-file=variables.pkrvars.hcl .
    packer build -var-file=variables.pkrvars.hcl .
    ```
4. 생성된 Image의 Resource ID를 사용해 Terraform 배포

## Ref
- ```configs/telegraf.conf```는 Ansible을 사용해 모니터링 대상 VM에 Telegraf Agent를 배포할때 사용될 Conf 입니다. 해당 파일은 임시로 ```/etc/influxdb``` 경로에 넣어줬습니다.
- Telegraf Agent 배포 전 ```configs/telegraf.conf```에 InfluxDB의 Private IP를 세팅해야 합니다.