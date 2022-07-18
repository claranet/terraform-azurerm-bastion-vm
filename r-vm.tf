module "bastion_vm" {
  source  = "claranet/linux-vm/azurerm"
  version = "6.0.0"

  location            = var.location
  location_short      = var.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name

  subnet_id         = var.subnet_bastion_id
  static_private_ip = var.private_ip_bastion

  # Naming
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix
  use_caf_naming = var.use_caf_naming

  custom_public_ip_name = var.custom_public_ip_name
  custom_nic_name       = var.custom_nic_name
  custom_ipconfig_name  = var.custom_ipconfig_name
  custom_dns_label      = local.hostname

  # Diag/logs
  diagnostics_storage_account_name         = var.diagnostics_storage_account_name
  diagnostics_storage_account_sas_token    = var.diagnostics_storage_account_sas_token
  use_legacy_monitoring_agent              = var.use_legacy_monitoring_agent
  azure_monitor_data_collection_rule_id    = var.azure_monitor_data_collection_rule_id
  azure_monitor_agent_version              = var.azure_monitor_agent_version
  azure_monitor_agent_auto_upgrade_enabled = var.azure_monitor_agent_auto_upgrade_enabled
  log_analytics_workspace_guid             = var.log_analytics_workspace_guid
  log_analytics_workspace_key              = var.log_analytics_workspace_key
  log_analytics_agent_enabled              = var.log_analytics_agent_enabled
  log_analytics_agent_version              = var.log_analytics_agent_version

  vm_size     = var.vm_size
  custom_name = var.custom_vm_name

  public_ip_sku   = var.public_ip_sku
  public_ip_zones = var.public_ip_zones

  admin_username = var.admin_username
  ssh_public_key = local.ssh_public_key

  zone_id = 1

  vm_image = var.storage_image_publisher != "" ? {
    publisher = var.storage_image_publisher
    offer     = var.storage_image_offer
    sku       = var.storage_image_sku
    version   = var.storage_image_version
  } : {}

  vm_image_id = var.storage_image_id

  os_disk_caching        = var.storage_os_disk_caching
  os_disk_custom_name    = var.storage_os_disk_custom_name
  os_disk_size_gb        = var.storage_os_disk_size_gb
  os_disk_overwrite_tags = var.storage_os_disk_overwrite_tags

  default_tags_enabled    = var.default_tags_enabled
  os_disk_tagging_enabled = var.storage_os_disk_tagging_enabled

  extra_tags           = merge(local.bastion_tags, var.bastion_extra_tags)
  public_ip_extra_tags = merge(local.bastion_tags, var.pubip_extra_tags)
  nic_extra_tags       = merge(local.bastion_tags, var.ani_extra_tags)
  os_disk_extra_tags   = merge(local.bastion_tags, var.storage_os_disk_extra_tags)
}
