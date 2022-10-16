# Build Image

## Software Versions
- Grafana: 설치 시점의 Stable Latest (2022.10 기준 v9.x)
- InfluxDB: 1.8.x
- Ansible: 설치 시점의 Stable Latest (2022.10 기준 v2.9.x)

### main.pkr.hcl
- InfluxDB 설치
- DB 생성, DB config 설정 (Basic Auth)
- Grafana 설치
- Ansible 설치
- Ansible 작업공간 생성 및 초기작업
    - ansible 디렉터리 복사 (/opt)
    - telegraf.conf 에 influxdb 정보 입력(db name, user, password)