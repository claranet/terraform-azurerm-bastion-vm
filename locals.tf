locals {
  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""

  default_basename = lower("${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")

  hostname = coalesce(var.custom_vm_hostname, local.default_basename)

  ssh_public_key  = coalesce(var.ssh_public_key, tls_private_key.ssh.public_key_openssh)
  ssh_private_key = coalesce(var.ssh_private_key, tls_private_key.ssh.private_key_pem)

  bastion_ansible_inventory_ip = var.public_ip_sku == null ? module.bastion_vm.vm_private_ip_address : module.bastion_vm.vm_public_ip_address

  bastion_tags = {
    env    = var.environment
    stack  = var.stack
    module = "bastion"
  }
}
