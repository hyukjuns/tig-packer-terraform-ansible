output "ubuntu_priavte_ip" {
    value = azurerm_linux_virtual_machine.target_ubuntu.private_ip_address
}
output "centos_priavte_ip" {
    value = azurerm_linux_virtual_machine.target_centos.private_ip_address
}