module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure_network_vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "azure_network_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.azure_network_vnet.virtual_network_name
  subnet_cidr_list     = ["10.10.0.0/24"]
}

module "network_security_group" {
  source  = "claranet/nsg/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short

  # You can set either a prefix for generated name or a custom one for the resource naming
  custom_network_security_group_name = var.security_group_name
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

module "az_monitor" {
  source  = "claranet/run-iaas/azurerm//modules/vm-monitoring"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name        = module.rg.resource_group_name
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  extra_tags = {
    foo = "bar"
  }
}

resource "tls_private_key" "bastion" {
  algorithm = "RSA"
}

module "bastion" {
  source = "git::https://github.com/claranet/terraform-azurerm-bastion-vm?ref=vx.x.x"

  client_name         = var.client_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  # Custom resource name
  #custom_vm_name = local.bastion_name

  subnet_bastion_id = module.azure_network_subnet.subnet_id

  vm_size                 = "Standard_DS1_v2"
  storage_os_disk_size_gb = "100"
  private_ip_bastion      = "10.10.10.10"

  # Optional: Put your SSH key here
  ssh_public_key  = tls_private_key.bastion.public_key_openssh
  ssh_private_key = tls_private_key.bastion.private_key_pem

  # Diag/logs
  diagnostics_storage_account_name      = module.logs.logs_storage_account_name
  diagnostics_storage_account_sas_token = null # used by legacy agent only
  azure_monitor_data_collection_rule_id = module.az_monitor.data_collection_rule_id
  log_analytics_workspace_guid          = module.logs.log_analytics_workspace_guid
  log_analytics_workspace_key           = module.logs.log_analytics_workspace_primary_key
}
