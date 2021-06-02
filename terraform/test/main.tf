terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.60.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
    features {}
}

data "azurerm_resource_group" "monitoring_rg" {
  name     = "tig"
}

data "azurerm_virtual_network" "monitoring_rg_vnet" {
  name                = "tig-network"
  resource_group_name = "tig"
}

data "azurerm_subnet" "monitoring_rg_vnet_subnet" {
  name                 = "tig-subnet-01"
  virtual_network_name = "tig-network"
  resource_group_name  = "tig"
}
# monitor ip
module "monitor-pip" {
  source                = "github.com/namhj94/Terraform/modules/public-ip"
  resource_group_name   = data.azurerm_resource_group.monitoring_rg.name
  location              = data.azurerm_resource_group.monitoring_rg.location
  pip_name              = "monitor-ip"
  pip_allocation_method = "Static"


}

# monitor
module "monitor_server" {
  source               = "github.com/namhj94/Terraform/modules/linux_server"
  resource_group_name  = data.azurerm_resource_group.monitoring_rg.name
  location             = data.azurerm_resource_group.monitoring_rg.location
  hostname             = "monitor"
  size                 = "Standard_F2"
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  os_disk_sku          = "Standard_LRS"
  publisher            = "Canonical"
  offer                = "UbuntuServer"
  sku                  = "18.04-LTS"
  os_tag               = "latest"
  subnet_id            = data.azurerm_subnet.monitoring_rg_vnet_subnet.id
  nic_name             = "monitor-nic"
  public_ip_address_id = module.monitor-pip.public_ip_address_id

}

# Target ip
module "client-ubuntu-pip" {
  source                = "github.com/namhj94/Terraform/modules/public-ip"
  resource_group_name   = data.azurerm_resource_group.monitoring_rg.name
  location              = data.azurerm_resource_group.monitoring_rg.location
  pip_name              = "ubuntu-ip"
  pip_allocation_method = "Static"


}
module "client-centos-pip" {
  source                = "github.com/namhj94/Terraform/modules/public-ip"
  resource_group_name   = data.azurerm_resource_group.monitoring_rg.name
  location              = data.azurerm_resource_group.monitoring_rg.location
  pip_name              = "centos-ip"
  pip_allocation_method = "Static"


}

# Target server
module "client_ubuntu_server" {
  source               = "github.com/namhj94/Terraform/modules/linux_server"
  resource_group_name  = data.azurerm_resource_group.monitoring_rg.name
  location             = data.azurerm_resource_group.monitoring_rg.location
  hostname             = "client-ubuntu"
  size                 = "Standard_F2"
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  os_disk_sku          = "Standard_LRS"
  publisher            = "Canonical"
  offer                = "UbuntuServer"
  sku                  = "18.04-LTS"
  os_tag               = "latest"
  subnet_id            = data.azurerm_subnet.monitoring_rg_vnet_subnet.id
  nic_name             = "ubuntu-nic"
  public_ip_address_id = module.client-ubuntu-pip.public_ip_address_id

}
module "client_centos_server" {
  source               = "github.com/namhj94/Terraform/modules/linux_server"
  resource_group_name  = data.azurerm_resource_group.monitoring_rg.name
  location             = data.azurerm_resource_group.monitoring_rg.location
  hostname             = "client-centos"
  size                 = "Standard_F2"
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  os_disk_sku          = "Standard_LRS"
  publisher            = "OpenLogic"
  offer                = "CentOS"
  sku                  = "7.5"
  os_tag               = "latest"
  subnet_id            = data.azurerm_subnet.monitoring_rg_vnet_subnet.id
  nic_name             = "centos-nic"
  public_ip_address_id = module.client-centos-pip.public_ip_address_id
  
}