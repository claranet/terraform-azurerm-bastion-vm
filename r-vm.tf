module "bastion_vm" {
  source  = "claranet/linux-vm/azurerm"
  version = "4.1.2"

  location            = var.location
  location_short      = var.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name

  subnet_id         = var.subnet_bastion_id
  static_private_ip = var.private_ip_bastion

  custom_public_ip_name = coalesce(var.custom_public_ip_name, "${local.default_basename}-pubip")
  custom_nic_name       = coalesce(var.custom_nic_name, "${local.default_basename}-nic")
  custom_ipconfig_name  = coalesce(var.custom_ipconfig_name, "${local.default_basename}-ipconfig")
  custom_dns_label      = local.hostname

  diagnostics_storage_account_name      = var.diagnostics_storage_account_name
  diagnostics_storage_account_sas_token = var.diagnostics_storage_account_sas_token

  vm_size     = var.vm_size
  custom_name = coalesce(var.custom_vm_name, "${local.default_basename}-vm")

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
