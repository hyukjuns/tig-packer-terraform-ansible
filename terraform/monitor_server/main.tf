terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "monitor" {
  name     = "tig-demo-rg"
}

data "azurerm_virtual_network" "monitor" {
  name                = "target-vnet"
  resource_group_name = data.azurerm_resource_group.monitor.name
}

data "azurerm_subnet" "monitor" {
  name                 = "target-subnet"
  virtual_network_name = data.azurerm_virtual_network.monitor.name
  resource_group_name  = data.azurerm_resource_group.monitor.name
}

# Monitoring Server (Ubuntu)
resource "azurerm_public_ip" "monitor" {
  name                = "monitor-pip"
  resource_group_name = data.azurerm_resource_group.monitor.name
  location            = data.azurerm_resource_group.monitor.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "monitor" {
  name                = "monitor-nic"
  location            = data.azurerm_resource_group.monitor.location
  resource_group_name = data.azurerm_resource_group.monitor.name

  ip_configuration {
    name                          = "monitor-nic-config"
    subnet_id                     = data.azurerm_subnet.monitor.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.monitor.id
  }
}

resource "azurerm_linux_virtual_machine" "monitor" {
  name                = "monitor-server"
  resource_group_name = data.azurerm_resource_group.monitor.name
  location            = data.azurerm_resource_group.monitor.location
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
# Telegraf Cofig 수정
resource "null_resource" "telegraf_config" {
  depends_on = [azurerm_linux_virtual_machine.monitor]

  provisioner "local-exec" {
    working_dir = "../../ansible/telegraf/config"
    command = <<EOH
perl -i -pe 's/MONITOR_SERVER_PIP/${azurerm_linux_virtual_machine.monitor.public_ip_address}/g' telegraf.conf
perl -i -pe 's/DB_NAME/${var.influxdb_db_name}/g' telegraf.conf
perl -i -pe 's/DB_ADMIN_NAME/${var.db_admin_username}/g' telegraf.conf
perl -i -pe 's/DB_ADMIN_PASSWORD/${var.db_admin_password}/g' telegraf.conf
EOH
  }
}

resource "null_resource" "make_inventory" {
  depends_on = [azurerm_linux_virtual_machine.monitor]

  provisioner "local-exec" {
    working_dir = "../../ansible/influxdb_grafana"
    command = <<EOH
cat <<EOF > inventory.ini
[monitor]
${azurerm_linux_virtual_machine.monitor.public_ip_address}

[monitor:vars]
ansible_user="${var.admin_username}"
ansible_password="${var.admin_password}"
db_name=${var.influxdb_db_name}
db_admin_username=${var.db_admin_username}
db_admin_password=${var.db_admin_password}
EOF
EOH
  }
}

resource "null_resource" "trigger_ansible" {
  depends_on = [null_resource.make_inventory]
  
  provisioner "local-exec" {
  working_dir =  "../../ansible/influxdb_grafana"
  command = "./trigger_playbook.sh"
  }
}