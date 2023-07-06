# Ansible
Install telegraf agent to target servers

# Usage
## Steps
1. Edit inventory.ini
    ```
    # ubuntu, centos
    [target]
    # Ubuntu
    <UBUBTU_PRIVATE_IP> ansible_user="" ansible_password=""

    # CentOS
    <CENTOS_PRIVATE_IP> ansible_user="" ansible_password=""  ansible_become_password=""
    ```

2. Check target servers
    ```
    ansible -m ping target
    ```

3. Run ansible-playbook
    ```
    ansible-playbook telegraf.yml
    ```
# Result
![ansible](../_img/ansible.png)