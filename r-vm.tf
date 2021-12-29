module "bastion_vm" {
  # source  = "claranet/linux-vm/azurerm"
  # version = "4.1.2"
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/modules/linux-vm.git?ref=AZ-515_caf_naming"

  location            = var.location
  location_short      = var.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name

  subnet_id         = var.subnet_bastion_id
  static_private_ip = var.private_ip_bastion

  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix
  use_caf_naming = var.use_caf_naming

  custom_public_ip_name = var.custom_public_ip_name
  custom_nic_name       = var.custom_nic_name
  custom_ipconfig_name  = var.custom_ipconfig_name
  custom_dns_label      = local.hostname

  diagnostics_storage_account_name      = var.diagnostics_storage_account_name
  diagnostics_storage_account_sas_token = var.diagnostics_storage_account_sas_token

  vm_size     = var.vm_size
  custom_name = var.custom_vm_name

  admin_username = var.admin_username
  ssh_public_key = local.ssh_public_key

  zone_id = 1

  vm_image = {
    publisher = var.storage_image_publisher
    offer     = var.storage_image_offer
    sku       = var.storage_image_sku
    version   = var.storage_image_version
  }

  os_disk_caching     = var.storage_os_disk_caching
  os_disk_custom_name = var.storage_os_disk_custom_name
  os_disk_size_gb     = var.storage_os_disk_size_gb

  extra_tags           = merge(local.bastion_tags, var.bastion_extra_tags)
  public_ip_extra_tags = merge(local.bastion_tags, var.pubip_extra_tags)
  nic_extra_tags       = merge(local.bastion_tags, var.ani_extra_tags)

  public_ip_sku = var.public_ip_sku
}
