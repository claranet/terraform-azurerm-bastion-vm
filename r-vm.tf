module "bastion-vm" {
  #   source  = "claranet/linux-vm/azurerm"
  #   version = "x.x.x"
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/modules/linux-vm.git?ref=AZ-189-azurerm-v2-0"

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

  diagnostics_storage_account_name      = var.diagnostics_storage_account_name
  diagnostics_storage_account_sas_token = var.diagnostics_storage_account_sas_token

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

  os_disk_caching = var.storage_os_disk_caching
  os_disk_size_gb = var.storage_os_disk_size_gb
  os_disk_type    = var.storage_os_disk_managed_disk_type

  extra_tags = merge(local.bastion_tags, var.bastion_extra_tags)
}
