terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = " ~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 모니터링 서버가 사용할 네트워크 환경
data "azurerm_subnet" "monitor" {
  name                 = var.network_subnet_name
  virtual_network_name = var.network_vnet_name
  resource_group_name  = var.network_resource_group_name
}

# 모니터링 서버가 생성될 리소스 그룹
resource "azurerm_resource_group" "monitor" {
  name     = var.monitor_resource_group_name
  location = var.monitor_resource_group_location
}

# Monitoring Server Spec (Ubuntu)
resource "azurerm_public_ip" "monitor" {
  name                = "monitor-pip"
  resource_group_name = azurerm_resource_group.monitor.name
  location            = azurerm_resource_group.monitor.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "monitor" {
  name                = "monitor-nic"
  resource_group_name = azurerm_resource_group.monitor.name
  location            = azurerm_resource_group.monitor.location

  ip_configuration {
    name                          = "monitor-nic-config"
    subnet_id                     = data.azurerm_subnet.monitor.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.monitor.id
  }
}

resource "azurerm_linux_virtual_machine" "monitor" {
  name                = "monitor-server"
  resource_group_name = azurerm_resource_group.monitor.name
  location            = azurerm_resource_group.monitor.location
  size                = "Standard_F2"

  network_interface_ids = [
    azurerm_network_interface.monitor.id,
  ]

  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_id = var.source_image_id
}

# NSG
resource "azurerm_network_security_group" "monitor" {
  name                = "monitor-server-nsg"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name

  security_rule {
    name                       = "grafana"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ssh"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "monitor" {
  network_interface_id      = azurerm_network_interface.monitor.id
  network_security_group_id = azurerm_network_security_group.monitor.id
}