terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.90.0"
    }
  }
  cloud {
    organization = "cloocus-mspdevops"

    workspaces {
      name = "hyukjun-tig-monitoring-workspace"
    }
  }
}

provider "azurerm" {
  # Configuration options
    features {}
}

resource "azurerm_resource_group" "monitor" {
  name = "rg-monitor"
  location = "koreacentral"
}

resource "azurerm_network_security_group" "monitor" {
  name                = "monitor-security-group"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "monitor" {
  name                = "monitor-network"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "monitor-subnet"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.monitor.id
  }
}

resource "azurerm_public_ip" "monitor" {
  name                = "monitor-server-pip"
  resource_group_name = azurerm_resource_group.monitor.name
  location            = azurerm_resource_group.monitor.location
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_network_interface" "monitor" {
  name                = "monitor-server-nic"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name

  ip_configuration {
    name                          = "monitor-server-nic-ip-config"
    subnet_id                     = azurerm_virtual_network.monitor.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.monitor.id
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

# windows
resource "azurerm_public_ip" "monitor_02" {
  name                = "windows-server-pip"
  resource_group_name = azurerm_resource_group.monitor.name
  location            = azurerm_resource_group.monitor.location
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_network_interface" "monitor_02" {
  name                = "windows-nic"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.monitor.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.monitor_02.id
  }
}

resource "azurerm_windows_virtual_machine" "windows" {
  name                = "windows-server"
  resource_group_name = azurerm_resource_group.monitor.name
  location            = azurerm_resource_group.monitor.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.monitor_02.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}