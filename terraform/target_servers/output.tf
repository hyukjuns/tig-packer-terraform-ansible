output "ubuntu_priavte_ip" {
  value = azurerm_linux_virtual_machine.target_ubuntu.private_ip_address
}
output "centos_priavte_ip" {
  value = azurerm_linux_virtual_machine.target_centos.private_ip_address
}

# Monitoring 서버가 사용할 네트워크 정보
output "network_resource_group_name" {
  value = azurerm_subnet.monitor.resource_group_name
}
output "network_vnet_name" {
  value = azurerm_subnet.monitor.virtual_network_name
}
output "network_subnet_name" {
  value = azurerm_subnet.monitor.name
}