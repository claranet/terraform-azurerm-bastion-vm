output "bastion_network_public_ip" {
  description = "Bastion public ip"
  value       = "${azurerm_public_ip.bastion.ip_address}"
}

output "bastion_network_public_ip_id" {
  description = "Bastion public ip id"
  value       = "${azurerm_public_ip.bastion.id}"
}

output "bastion_network_interface_id" {
  description = "Bastion network interface id"
  value       = "${azurerm_network_interface.bastion.id}"
}

output "bastion_network_interface_private_ip" {
  description = "Bastion private ip"
  value       = "${azurerm_network_interface.bastion.private_ip_address}"
}

output "bastion_virtual_machine_id" {
  description = "Bastion virtual machine id"
  value       = "${azurerm_virtual_machine.bastion_instance.id}"
}
