output "bastion_network_public_ip" {
  description = "Bastion public ip"
  value       = try(module.bastion_vm.vm_public_ip_address, "")
}

output "bastion_public_domain_name_label" {
  description = "Bastion public DNS"
  value       = try(module.bastion_vm.vm_public_domain_name_label, "")
}

output "bastion_network_public_ip_id" {
  description = "Bastion public ip ID"
  value       = try(module.bastion_vm.vm_public_ip_id, "")
}

output "bastion_network_interface_id" {
  description = "Bastion network interface id"
  value       = module.bastion_vm.vm_nic_id
}

output "bastion_network_interface_private_ip" {
  description = "Bastion private ip"
  value       = module.bastion_vm.vm_private_ip_address
}

output "bastion_virtual_machine_id" {
  description = "Bastion virtual machine id"
  value       = module.bastion_vm.vm_id
}

output "bastion_virtual_machine_name" {
  description = "Bastion virtual machine name"
  value       = module.bastion_vm.vm_name
}

output "bastion_admin_username" {
  description = "Username of the admin user"
  value       = var.admin_username
}

output "bastion_admin_password" {
  description = "Password of the admin user"
  value       = var.admin_password
}

output "bastion_virtual_machine_size" {
  description = "Bastion virtual machine size"
  value       = var.vm_size
}

output "bastion_hostname" {
  description = "Bastion hostname"
  value       = local.hostname
}

output "bastion_virtual_machine_identity" {
  description = "System Identity assigned to Bastion virtual machine"
  value       = module.bastion_vm.vm_identity
}

output "ssh_public_key" {
  description = "SSH public key"
  value       = local.ssh_public_key
}

output "ssh_private_key" {
  description = "SSH private key"
  value       = local.ssh_private_key
  sensitive   = true
}

output "bastion_ssh_public_key" {
  description = "SSH public key"
  value       = local.ssh_public_key
}

output "bastion_ssh_private_key" {
  description = "SSH private key"
  value       = local.ssh_private_key
  sensitive   = true
}

output "bastion_virtual_machine_os_disk" {
  description = "Bastion virtual Machine OS disk"
  value       = module.bastion_vm.vm_os_disk
}

output "bastion_maintenance_configurations_assignments" {
  description = "Maintenance configurations assignments configurations."
  value       = module.bastion_vm.maintenance_configurations_assignments
}
