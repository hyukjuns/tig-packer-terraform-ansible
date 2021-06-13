output "monitoring_server_public_ip" {
    value = azurerm_linux_virtual_machine.monitoring_server.public_ip_address
}