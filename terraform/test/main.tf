terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.56.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
    features {}
}

data "azurerm_resource_group" "monitoring_rg" {
  name     = "monitoring-rg"
}

data "azurerm_virtual_network" "monitoring_rg_vnet" {
  name                = "monitoring-rg-vnet"
  resource_group_name = "monitoring-rg"
}

data "azurerm_subnet" "monitoring_rg_vnet_subnet" {
  name                 = "default"
  virtual_network_name = "monitoring-rg-vnet"
  resource_group_name  = "monitoring-rg"
}

# Monitoring Server
resource "azurerm_public_ip" "monitoring_server_pip" {
  name                = "monitoring-server-pip"
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
  location            = data.azurerm_resource_group.monitoring_rg.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "monitoring_server_nic" {
  name                = "monitoring-server-nic"
  location            = data.azurerm_resource_group.monitoring_rg.location
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.monitoring_rg_vnet_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.monitoring_server_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "monitoring_server" {
  name                = "monitoring-server"
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
  location            = data.azurerm_resource_group.monitoring_rg.location
  size                = "Standard_F2"
  
  network_interface_ids = [
    azurerm_network_interface.monitoring_server_nic.id,
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

# Terget VMs(Ubuntu 1, CentOS 1)
resource "azurerm_public_ip" "monitoring_client_pip" {
  name                = "monitoring-client-pip"
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
  location            = data.azurerm_resource_group.monitoring_rg.location
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "monitoring_client_nic" {
  name                = "monitoring-client-nic"
  location            = data.azurerm_resource_group.monitoring_rg.location
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.monitoring_rg_vnet_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.monitoring_client_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "monitoring_client" {
  name                = "monitoring-client"
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
  location            = data.azurerm_resource_group.monitoring_rg.location
  size                = "Standard_F2"
  
  network_interface_ids = [
    azurerm_network_interface.monitoring_client_nic.id,
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
resource "azurerm_public_ip" "monitoring_client_2_pip" {
  name                = "monitoring-client-2-pip"
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
  location            = data.azurerm_resource_group.monitoring_rg.location
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "monitoring_client_2_nic" {
  name                = "monitoring-client-2-nic"
  location            = data.azurerm_resource_group.monitoring_rg.location
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.monitoring_rg_vnet_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.monitoring_client_2_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "monitoring_client_2" {
  name                = "monitoring-client-2"
  resource_group_name = data.azurerm_resource_group.monitoring_rg.name
  location            = data.azurerm_resource_group.monitoring_rg.location
  size                = "Standard_F2"
  
  network_interface_ids = [
    azurerm_network_interface.monitoring_client_2_nic.id,
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
