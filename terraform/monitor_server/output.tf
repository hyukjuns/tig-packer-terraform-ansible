output "monitor_server_public_ip" {
    value = azurerm_linux_virtual_machine.monitor.public_ip_address
}
output "monitor_server_private_ip" {
    value = azurerm_linux_virtual_machine.monitor.private_ip_address
}