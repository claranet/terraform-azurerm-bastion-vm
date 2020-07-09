module "bastion-vm" {
  #   source  = "claranet/linux-vm/azurerm"
  #   version = "x.x.x"
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/modules/linux-vm.git?ref=AZ-234_nic_nsg"

  location            = var.location
  location_short      = var.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name

  subnet_id         = var.subnet_bastion_id
  static_private_ip = var.private_ip_bastion

  custom_public_ip_name = coalesce(var.custom_publicip_name, "${local.default_basename}-pubip")
  custom_nic_name       = coalesce(var.custom_nic_name, "${local.default_basename}-nic")
  custom_ipconfig_name  = coalesce(var.custom_ipconfig_name, "${local.default_basename}-ipconfig")
  custom_dns_label      = local.hostname

  diagnostics_storage_account_name      = module.run-common.logs_storage_account_name
  diagnostics_storage_account_sas_token = lookup(module.run-common.logs_storage_account_sas_token, "sastoken")

  vm_size     = var.vm_size
  custom_name = coalesce(var.custom_vm_name, "${local.default_basename}-vm")

  admin_username = var.admin_username
  ssh_public_key = var.ssh_key_pub

  zone_id = 1

  vm_image = {
    publisher = var.storage_image_publisher
    offer     = var.storage_image_offer
    sku       = var.storage_image_sku
    version   = var.storage_image_version
  }

  storage_os_disk_config = {
    name              = coalesce(var.custom_disk_name, "${local.default_basename}-osdisk")
    caching           = var.storage_os_disk_caching
    create_option     = var.storage_os_disk_create_option
    managed_disk_type = var.storage_os_disk_managed_disk_type
    disk_size_gb      = var.storage_os_disk_size_gb
  }

  delete_os_disk_on_termination = var.delete_os_disk_on_termination

  extra_tags = merge(local.bastion_tags, var.bastion_extra_tags)
}
