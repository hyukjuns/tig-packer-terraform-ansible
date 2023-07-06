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
provider "template" {
  
}

# Resource Group
resource "azurerm_resource_group" "monitor" {
  name     = var.resource_group_name
  location = var.location
}

# vnet
resource "azurerm_virtual_network" "monitor" {
  name                = "monitor-vnet-001"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name
}

resource "azurerm_subnet" "monitor" {
  name                 = "monitor-subnet"
  resource_group_name  = azurerm_resource_group.monitor.name
  virtual_network_name = azurerm_virtual_network.monitor.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Monitoring Server Spec (Ubuntu)
resource "azurerm_public_ip" "monitor" {
  name                = "${var.monitor_server_name}-pip"
  resource_group_name = azurerm_resource_group.monitor.name
  location            = azurerm_resource_group.monitor.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "monitor" {
  name                = "${var.monitor_server_name}-nic"
  resource_group_name = azurerm_resource_group.monitor.name
  location            = azurerm_resource_group.monitor.location

  ip_configuration {
    name                          = "monitor-nic-ipconfig"
    subnet_id                     = azurerm_subnet.monitor.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.monitor.id
  }
}

resource "azurerm_linux_virtual_machine" "monitor" {
  name                = var.monitor_server_name
  resource_group_name = azurerm_resource_group.monitor.name
  location            = azurerm_resource_group.monitor.location
  size                = "Standard_DS2_v2"

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
  
  # Shell script - edit telegraf.conf 
  custom_data    = base64encode(data.template_file.custom.rendered)
}

# Shell script - edit telegraf.conf 
data "template_file" "custom" {
  template = file("custom.sh")
}

# NSG
resource "azurerm_network_security_group" "monitor" {
  name                = "${var.monitor_server_name}-nsg"
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