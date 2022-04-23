# Setting up targets

## Target info
1. Network: 1 Vnet, 1 Subnet
1. Target server : ubuntu 1, centos 1
2. Middleware : apache web server

## Usage
1. Make tfvars
    - terraform.tfvars
    ```
    location="LOCATION"
    admin_username="username"
    admin_password="password"
    ```
2. Plan & Apply

3. output
    1. ubuntu private ip
    2. centos private ip