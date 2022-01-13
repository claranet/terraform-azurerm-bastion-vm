locals {
  ssh_public_key  = coalesce(var.ssh_public_key, tls_private_key.ssh.public_key_openssh)
  ssh_private_key = coalesce(var.ssh_private_key, tls_private_key.ssh.private_key_pem)

  bastion_ansible_inventory_ip = var.public_ip_sku == null ? module.bastion_vm.vm_private_ip_address : module.bastion_vm.vm_public_ip_address

  bastion_tags = {
    env    = var.environment
    stack  = var.stack
    module = "bastion"
  }
}
