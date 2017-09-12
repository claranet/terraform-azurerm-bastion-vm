output "bastion_network_interface_id" {
  value = "${azurerm_network_interface.bastion.id}"
}

output "bastion_network_private_ip" {
  value = "${azurerm_network_interface.bastion.private_ip_address}"
}

output "bastion_network_public_ip" {
  value = "${azurerm_public_ip.bastion.ip_address}"
}
