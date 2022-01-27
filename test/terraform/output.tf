output "monitoring_server_public_ip" {
    value = azurerm_linux_virtual_machine.monitor.public_ip_address
}
output "monitoring_server_public_ip_02" {
    value = azurerm_windows_virtual_machine.windows.public_ip_address
}