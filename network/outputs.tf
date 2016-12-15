output "network_interface_id" {
  value = "${azurerm_network_interface.bastion.id}"
}

output "ip_address" {
  value = "${azurerm_public_ip.bastion.ip_address}"
}
