output "bastion_network_public_ip" {
  description = "Bastion public ip"
  value       = module.bastion-vm.vm_public_ip_address
}

output "bastion_public_domain_name_label" {
  description = "Bastion public DNS"
  value       = module.bastion-vm.vm_public_domain_name_label
}

output "bastion_network_public_ip_id" {
  description = "Bastion public ip ID"
  value       = module.bastion-vm.vm_public_ip_id
}

output "bastion_network_interface_id" {
  description = "Bastion network interface id"
  value       = module.bastion-vm.vm_nic_id
}

output "bastion_network_interface_private_ip" {
  description = "Bastion private ip"
  value       = module.bastion-vm.vm_private_ip_address
}

output "bastion_virtual_machine_id" {
  description = "Bastion virtual machine id"
  value       = module.bastion-vm.vm_id
}

output "bastion_virtual_machine_name" {
  description = "Bastion virtual machine name"
  value       = module.bastion-vm.vm_name
}

output "bastion_admin_username" {
  description = "Username of the admin user"
  value       = var.admin_username
}

output "bastion_virtual_machine_size" {
  description = "Bastion virtual machine size"
  value       = var.vm_size
}

output "bastion_hostname" {
  description = "Bastion hostname"
  value       = local.hostname
}
