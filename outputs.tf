output "bastion_network_public_ip" {
  description = "Bastion public ip"
  value       = azurerm_public_ip.bastion.ip_address
}

output "bastion_network_public_ip_id" {
  description = "Bastion public ip id"
  value       = azurerm_public_ip.bastion.id
}

output "bastion_network_interface_id" {
  description = "Bastion network interface id"
  value       = azurerm_network_interface.bastion.id
}

output "bastion_network_interface_private_ip" {
  description = "Bastion private ip"
  value       = azurerm_network_interface.bastion.private_ip_address
}

output "bastion_virtual_machine_id" {
  description = "Bastion virtual machine id"
  value       = azurerm_virtual_machine.bastion_instance.id
}

output "bastion_virtual_machine_name" {
  description = "Bastion virtual machine name"
  value       = azurerm_virtual_machine.bastion_instance.name
}

output "bastion_admin_username" {
  description = "Username of the admin user"
  value       = var.admin_username
}

output "bastion_virtual_machine_size" {
  description = "Bastion virtual machine size"
  value       = azurerm_virtual_machine.bastion_instance.vm_size
}

output "bastion_hostname" {
  description = "Bastion hostname"
  value       = local.hostname
}

output "bastion_storage_image_reference" {
  description = "Bastion storage image reference object"
  value       = azurerm_virtual_machine.bastion_instance.storage_image_reference
}

output "bastion_storage_os_disk" {
  description = "Bastion storage OS disk object"
  value       = azurerm_virtual_machine.bastion_instance.storage_os_disk
}

output "bastion_public_domain_name_label" {
  description = "Bastion public DNS"
  value       = azurerm_public_ip.bastion.domain_name_label
}
