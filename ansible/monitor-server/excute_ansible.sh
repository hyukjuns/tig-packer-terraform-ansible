#!/bin/bash

# inventory 생성 확인
ls ./inventory.ini
LS_STATUS=$?

# 대기
sleep 10

# ansbile ping 시도 5회
count=0
while [ $count -le 5 ];do
ansible -m ping monitor -i ./inventory.ini
PING_STATUS=$?
if [ $PING_STATUS -eq 0 ];then
    break
fi
count=$((count + 1))
sleep 5
done

# inventory존재 && ansible ping ok면 playbook 실행
if [ $LS_STATUS -eq 0 -a $PING_STATUS -eq 0 ];then
    ansible-playbook ./grafana_influxdb_ansible.yml
else 
    echo "ansible ping failed"
fi