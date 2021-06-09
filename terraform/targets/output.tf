output "target_Ubuntu_public_ip" {
    value = azurerm_linux_virtual_machine.target_00_server.public_ip_address
}
output "target_CentOS_public_ip" {
    value = azurerm_linux_virtual_machine.target_01_server.public_ip_address
}