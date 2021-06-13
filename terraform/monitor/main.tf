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
    name                          = "monitoring-server-nic-ip-config"
    subnet_id                     = data.azurerm_subnet.monitoring_vnet_subnet.id
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

resource "null_resource" "make_inventory" {
  depends_on = [azurerm_linux_virtual_machine.monitoring_server]
  provisioner "local-exec" {
    working_dir = "../../ansible/monitor-server"
    command = <<EOH
cat <<EOF > inventory.ini
[monitor]
${azurerm_linux_virtual_machine.monitoring_server.public_ip_address}

[monitor:vars]
ansible_user="${var.admin_username}"
ansible_password="${var.admin_password}"
EOF
EOH
  }
}

resource "null_resource" "trigger_ansible" {
  depends_on = [null_resource.make_inventory]
  provisioner "local-exec" {
  working_dir =  "../../ansible/monitor-server"
  command = "./excute_ansible.sh"
  }
}