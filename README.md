# Azure Support Bastion module
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/bastion-vm/azurerm/)

This module creates a virtual machine to be used as a bastion/jump-host instance for Claranet.
## Requirements

* [Ansible](https://github.com/ansible/ansible/) >= 2.5

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
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

resource "tls_private_key" "bastion" {
  algorithm = "RSA"
}

module "bastion" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/bastion-vm.git?ref=vX.X.X"

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

  diagnostics_storage_account_name      = module.logs.logs_storage_account_name
  diagnostics_storage_account_sas_token = module.logs.logs_storage_account_sas_token["sastoken"]
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
| bastion\_vm | git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/modules/linux-vm.git | AZ-515_caf_naming |

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
| admin\_username | Name of the admin user | `string` | `"claranet"` | no |
| ani\_extra\_tags | Additional tags to associate with your network interface. | `map(string)` | `{}` | no |
| bastion\_extra\_tags | Additional tags to associate with your bastion instance. | `map(string)` | `{}` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_ipconfig\_name | Name for the Network Interface ip configuration | `string` | `""` | no |
| custom\_nic\_name | Name for the Network Interface | `string` | `""` | no |
| custom\_public\_ip\_name | Name for the Public IP Address resource | `string` | `""` | no |
| custom\_vm\_hostname | Bastion hostname | `string` | `""` | no |
| custom\_vm\_name | VM Name as displayed on the console | `string` | `""` | no |
| diagnostics\_storage\_account\_name | Name of the Storage Account in which store vm diagnostics | `string` | n/a | yes |
| diagnostics\_storage\_account\_sas\_token | SAS token of the Storage Account in which store vm diagnostics | `string` | n/a | yes |
| environment | Project environment | `string` | n/a | yes |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| name\_prefix | Optional prefix for the generated name | `string` | `"bastion"` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| private\_ip\_bastion | Allows to define the private ip to associate with the bastion | `string` | n/a | yes |
| pubip\_extra\_tags | Additional tags to associate with your public ip. | `map(string)` | `{}` | no |
| public\_ip\_sku | Public IP SKU attached to the VM. Can be `null` if no public IP is needed.<br>If set to `null`, the Terraform module must be executed from a host having connectivity to the bastion private ip. <br>Thus, the bootstrap's ansible playbook will use the bastion private IP for inventory. | `string` | `"Standard"` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| ssh\_private\_key | SSH private key, generated if empty | `string` | n/a | yes |
| ssh\_public\_key | SSH public key, generated if empty | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| storage\_image\_offer | Specifies the offer of the image used to create the virtual machine | `string` | `"UbuntuServer"` | no |
| storage\_image\_publisher | Specifies the publisher of the image used to create the virtual machine | `string` | `"Canonical"` | no |
| storage\_image\_sku | Specifies the SKU of the image used to create the virtual machine | `string` | `"18.04-LTS"` | no |
| storage\_image\_version | Specifies the version of the image used to create the virtual machine | `string` | `"latest"` | no |
| storage\_os\_disk\_caching | Specifies the caching requirements for the OS Disk | `string` | `"ReadWrite"` | no |
| storage\_os\_disk\_custom\_name | Bastion OS disk name as displayed in the console | `string` | `""` | no |
| storage\_os\_disk\_size\_gb | Specifies the size of the OS Disk in gigabytes | `string` | n/a | yes |
| subnet\_bastion\_id | The bastion subnet id | `string` | n/a | yes |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_*_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| vm\_size | Bastion virtual machine size | `string` | n/a | yes |

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
| bastion\_virtual\_machine\_id | Bastion virtual machine id |
| bastion\_virtual\_machine\_identity | System Identity assigned to Bastion virtual machine |
| bastion\_virtual\_machine\_name | Bastion virtual machine name |
| bastion\_virtual\_machine\_size | Bastion virtual machine size |
| ssh\_private\_key | SSH private key |
| ssh\_public\_key | SSH public key |
<!-- END_TF_DOCS -->

## Related documentation

Azure remote management security documentation: [docs.microsoft.com/en-us/azure/security/azure-security-management](https://docs.microsoft.com/en-us/azure/security/azure-security-management)
