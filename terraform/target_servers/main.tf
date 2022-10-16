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

resource "azurerm_resource_group" "target" {
  name     = "tig-demo-targets-rg"
  location = "koreacentral"
}

resource "azurerm_virtual_network" "target" {
  name                = "target-vnet"
  location            = azurerm_resource_group.target.location
  resource_group_name = azurerm_resource_group.target.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "target" {
  name                 = "target-subnet"
  resource_group_name  = azurerm_resource_group.target.name
  virtual_network_name = azurerm_virtual_network.target.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "monitor" {
  name                 = "mgmt-subnet"
  resource_group_name  = azurerm_resource_group.target.name
  virtual_network_name = azurerm_virtual_network.target.name
  address_prefixes     = ["10.0.100.0/24"]
}

# Ubuntu
resource "azurerm_public_ip" "target_ubuntu" {
  name                = "target-ubuntu-pip"
  resource_group_name = azurerm_resource_group.target.name
  location            = azurerm_resource_group.target.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "target_ubuntu" {
  name                = "target-ubuntu-nic"
  location            = azurerm_resource_group.target.location
  resource_group_name = azurerm_resource_group.target.name

  ip_configuration {
    name                          = "target-ubuntu-nic-config"
    subnet_id                     = azurerm_subnet.target.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.target_ubuntu.id
  }
}

resource "azurerm_linux_virtual_machine" "target_ubuntu" {
  name                = "target-ubuntu"
  resource_group_name = azurerm_resource_group.target.name
  location            = azurerm_resource_group.target.location
  size                = "Standard_B2s"

  network_interface_ids = [
    azurerm_network_interface.target_ubuntu.id,
  ]

  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
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

# CentOS
resource "azurerm_public_ip" "target_centos" {
  name                = "target-centos-pip"
  resource_group_name = azurerm_resource_group.target.name
  location            = azurerm_resource_group.target.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "target_centos" {
  name                = "target-centos-nic"
  location            = azurerm_resource_group.target.location
  resource_group_name = azurerm_resource_group.target.name

  ip_configuration {
    name                          = "target-centos-nic-config"
    subnet_id                     = azurerm_subnet.target.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.target_centos.id
  }
}

resource "azurerm_linux_virtual_machine" "target_centos" {
  name                = "target-centos"
  resource_group_name = azurerm_resource_group.target.name
  location            = azurerm_resource_group.target.location
  size                = "Standard_B2s"

  network_interface_ids = [
    azurerm_network_interface.target_centos.id,
  ]

  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
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
