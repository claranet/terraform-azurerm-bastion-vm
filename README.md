# Azure Support Bastion module
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/bastion-vm/azurerm/)

This module creates a virtual machine to be used as a bastion/jump-host instance for Claranet.
## Requirements

* [Ansible](https://github.com/ansible/ansible/) >= 2.5

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
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

module "az_vm_backup" {
  source  = "claranet/run-iaas/azurerm//modules/backup"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id
  ]
}

resource "tls_private_key" "bastion" {
  algorithm = "RSA"
}

module "bastion" {
  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://github.com/claranet/terraform-azurerm-bastion-vm"

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

  # Set to null to deactivate backup
  backup_policy_id = module.az_vm_backup.vm_backup_policy_id

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
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.1 |
| local | >= 2.0 |
| null | >= 3.0 |
| template | >= 2.0 |
| tls | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| bastion\_vm | claranet/linux-vm/azurerm | 6.5.0 |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.vm_host](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [local_file.rendered_ansible_inventory](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.ssh_private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.ansible_bootstrap_vm](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [template_file.ansible_inventory](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aad\_ssh\_login\_admin\_objects\_ids | Azure Active Directory objects IDs allowed to connect as administrator on the VM. | `list(string)` | `[]` | no |
| aad\_ssh\_login\_enabled | Enable SSH logins with Azure Active Directory. | `bool` | `false` | no |
| aad\_ssh\_login\_extension\_version | VM Extension version for Azure Active Directory SSH Login extension. | `string` | `"1.0"` | no |
| aad\_ssh\_login\_user\_objects\_ids | Azure Active Directory objects IDs allowed to connect as standard user on the VM. | `list(string)` | `[]` | no |
| admin\_username | Name of the admin user. | `string` | `"claranet"` | no |
| ani\_extra\_tags | Additional tags to associate with your network interface. | `map(string)` | `{}` | no |
| azure\_monitor\_agent\_auto\_upgrade\_enabled | Automatically update agent when publisher releases a new version of the agent | `bool` | `false` | no |
| azure\_monitor\_agent\_version | Azure Monitor Agent extension version | `string` | `"1.12"` | no |
| azure\_monitor\_data\_collection\_rule\_id | Data Collection Rule ID from Azure Monitor for metrics and logs collection. Used with new monitoring agent, set to `null` if legacy agent is used. | `string` | n/a | yes |
| backup\_policy\_id | Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup). | `string` | n/a | yes |
| bastion\_extra\_tags | Additional tags to associate with your bastion instance. | `map(string)` | `{}` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_ipconfig\_name | Name for the Network Interface ip configuration | `string` | `""` | no |
| custom\_nic\_name | Name for the Network Interface | `string` | `""` | no |
| custom\_public\_ip\_name | Name for the Public IP Address resource | `string` | `""` | no |
| custom\_vm\_hostname | Bastion hostname | `string` | `""` | no |
| custom\_vm\_name | VM Name as displayed on the console | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostics\_storage\_account\_name | Name of the Storage Account in which store vm diagnostics | `string` | n/a | yes |
| diagnostics\_storage\_account\_sas\_token | SAS token of the Storage Account in which store vm diagnostics. Used only with legacy monitoring agent, set to `null` if not needed. | `string` | `null` | no |
| environment | Project environment | `string` | n/a | yes |
| extensions\_extra\_tags | Extra tags to set on the VM extensions. | `map(string)` | `{}` | no |
| identity | Map with identity block informations as described here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | <pre>{<br>  "identity_ids": [],<br>  "type": "SystemAssigned"<br>}</pre> | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_agent\_enabled | Deploy Log Analytics VM extension - depending of OS (cf. https://docs.microsoft.com/fr-fr/azure/azure-monitor/agents/agents-overview#linux) | `bool` | `true` | no |
| log\_analytics\_agent\_version | Azure Log Analytics extension version | `string` | `"1.13"` | no |
| log\_analytics\_workspace\_guid | GUID of the Log Analytics Workspace to link with | `string` | `null` | no |
| log\_analytics\_workspace\_key | Access key of the Log Analytics Workspace to link with | `string` | `null` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `"bastion"` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| private\_ip\_bastion | Allows to define the private ip to associate with the bastion | `string` | n/a | yes |
| pubip\_extra\_tags | Additional tags to associate with your public ip. | `map(string)` | `{}` | no |
| public\_ip\_sku | Public IP SKU attached to the VM. Can be `null` if no public IP is needed.<br>If set to `null`, the Terraform module must be executed from a host having connectivity to the bastion private ip.<br>Thus, the bootstrap's ansible playbook will use the bastion private IP for inventory. | `string` | `"Standard"` | no |
| public\_ip\_zones | Zones for public IP attached to the VM. Can be `null` if no zone distpatch. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| ssh\_private\_key | SSH private key, generated if empty | `string` | n/a | yes |
| ssh\_public\_key | SSH public key, generated if empty | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| storage\_image\_id | Specifies the image ID used to create the virtual machine | `string` | `null` | no |
| storage\_image\_offer | Specifies the offer of the image used to create the virtual machine | `string` | `"UbuntuServer"` | no |
| storage\_image\_publisher | Specifies the publisher of the image used to create the virtual machine | `string` | `"Canonical"` | no |
| storage\_image\_sku | Specifies the SKU of the image used to create the virtual machine | `string` | `"18.04-LTS"` | no |
| storage\_image\_version | Specifies the version of the image used to create the virtual machine | `string` | `"latest"` | no |
| storage\_os\_disk\_caching | Specifies the caching requirements for the OS Disk | `string` | `"ReadWrite"` | no |
| storage\_os\_disk\_custom\_name | Bastion OS disk name as displayed in the console | `string` | `""` | no |
| storage\_os\_disk\_extra\_tags | Additional tags to set on the OS disk. | `map(string)` | `{}` | no |
| storage\_os\_disk\_size\_gb | Specifies the size of the OS Disk in gigabytes. | `string` | n/a | yes |
| storage\_os\_disk\_tagging\_enabled | Should OS disk tagging be enabled? Defaults to `true`. | `bool` | `true` | no |
| subnet\_bastion\_id | The bastion subnet id | `string` | n/a | yes |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_*_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| use\_legacy\_monitoring\_agent | True to use the legacy monitoring agent instead of Azure Monitor Agent | `bool` | `false` | no |
| vm\_size | Bastion virtual machine size | `string` | n/a | yes |
| vm\_zone | Bastion Virtual Machine zone. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_admin\_username | Username of the admin user |
| bastion\_hostname | Bastion hostname |
| bastion\_network\_interface\_id | Bastion network interface id |
| bastion\_network\_interface\_private\_ip | Bastion private ip |
| bastion\_network\_public\_ip | Bastion public ip |
| bastion\_network\_public\_ip\_id | Bastion public ip ID |
| bastion\_public\_domain\_name\_label | Bastion public DNS |
| bastion\_ssh\_private\_key | SSH private key |
| bastion\_ssh\_public\_key | SSH public key |
| bastion\_virtual\_machine\_id | Bastion virtual machine id |
| bastion\_virtual\_machine\_identity | System Identity assigned to Bastion virtual machine |
| bastion\_virtual\_machine\_name | Bastion virtual machine name |
| bastion\_virtual\_machine\_size | Bastion virtual machine size |
| ssh\_private\_key | SSH private key |
| ssh\_public\_key | SSH public key |
| terraform\_module | Information about this Terraform module |
<!-- END_TF_DOCS -->

## Related documentation

Azure remote management security documentation: [docs.microsoft.com/en-us/azure/security/azure-security-management](https://docs.microsoft.com/en-us/azure/security/azure-security-management)
