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
  name     = "monitoring"
}

data "azurerm_virtual_network" "monitoring_vnet" {
  name                = "monitor-vnet"
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
}

data "azurerm_subnet" "monitoring_vnet_subnet" {
  name                 = "default"
  virtual_network_name = data.azurerm_virtual_network.monitoring_vnet.name
  resource_group_name  = data.azurerm_resource_group.monitoring_rg.name
}

# Target Ubuntu Server
resource "azurerm_public_ip" "target_00_pip" {
  name                = "target-00-pip"
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
  location            = data.azurerm_resource_group.monitoring_rg.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "target_00_nic" {
  name                = "target-00-nic"
  location            = data.azurerm_resource_group.monitoring_rg.location
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name

  ip_configuration {
    name                          = "target-00-nic-ip-config"
    subnet_id                     = data.azurerm_subnet.monitoring_vnet_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.target_00_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "target_00_server" {
  name                = "target-00-server"
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
  location            = data.azurerm_resource_group.monitoring_rg.location
  size                = "Standard_F2"
  
  network_interface_ids = [
    azurerm_network_interface.target_00_nic.id,
  ]

  admin_username = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Target CentOS Server
resource "azurerm_public_ip" "target_01_pip" {
  name                = "target-01-pip"
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
  location            = data.azurerm_resource_group.monitoring_rg.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "target_01_nic" {
  name                = "target-01-nic"
  location            = data.azurerm_resource_group.monitoring_rg.location
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name

  ip_configuration {
    name                          = "target-01-nic-ip-config"
    subnet_id                     = data.azurerm_subnet.monitoring_vnet_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.target_01_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "target_01_server" {
  name                = "target-01-server"
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
  location            = data.azurerm_resource_group.monitoring_rg.location
  size                = "Standard_F2"
  
  network_interface_ids = [
    azurerm_network_interface.target_01_nic.id,
  ]

  admin_username = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }
}
