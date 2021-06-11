output "target_Ubuntu_private_ip" {
    value = azurerm_linux_virtual_machine.target_00_server.private_ip_address
}
output "target_CentOS_private_ip" {
    value = azurerm_linux_virtual_machine.target_01_server.private_ip_address
}