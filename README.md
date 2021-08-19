# Azure Support Bastion module
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/bastion-vm/azurerm/)

This module creates a virtual machine to be used as a bastion/jump-host instance for Claranet.
## Requirements

* [Ansible](https://github.com/ansible/ansible/) >= 2.5

## Version compatibility

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

Terraform module declaration example for your bastion support stack with all required modules:

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure-network-vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "azure-network-subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  environment         = var.environment
  location_short      = module.azure-region.location_short
  client_name         = var.client_name
  stack               = var.stack
  custom_subnet_names = keys(local.subnets)

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.azure-network-vnet.virtual_network_name
  subnet_cidr_list     = values(local.subnets)
}

module "network-security-group" {
  source  = "claranet/nsg/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short

  # You can set either a prefix for generated name or a custom one for the resource naming
  custom_network_security_group_names = [var.security_group_name]
}

module "bastion" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/bastion.git?ref=vX.X.X"

  client_name         = var.client_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  # Custom resource name
  #custom_vm_name = local.bastion_name

  subnet_bastion_id = element(module.azure-network-subnet.subnet_ids, 0)

  vm_size                 = "Standard_DS1_v2"
  storage_os_disk_size_gb = "100"
  private_ip_bastion      = "10.10.10.10"

  # Put your SSH Public Key here
  ssh_key_pub      = file("./put_the_key_path_here.pub")
  private_key_path = var.private_key_path
}
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| local | >= 2.0 |
| null | >= 3.0 |
| template | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| bastion\_vm | claranet/linux-vm/azurerm | 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [local_file.rendered_ansible_inventory](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.ansible_bootstrap_vm](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
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
| name\_prefix | Optional prefix for resources naming | `string` | `"bastion-"` | no |
| private\_ip\_bastion | Allows to define the private ip to associate with the bastion | `string` | n/a | yes |
| private\_key\_path | Root SSH private key path | `string` | n/a | yes |
| pubip\_extra\_tags | Additional tags to associate with your public ip. | `map(string)` | `{}` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| ssh\_key\_pub | Root SSH pub key to deploy on the bastion | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| storage\_image\_offer | Specifies the offer of the image used to create the virtual machine | `string` | `"UbuntuServer"` | no |
| storage\_image\_publisher | Specifies the publisher of the image used to create the virtual machine | `string` | `"Canonical"` | no |
| storage\_image\_sku | Specifies the SKU of the image used to create the virtual machine | `string` | `"18.04-LTS"` | no |
| storage\_image\_version | Specifies the version of the image used to create the virtual machine | `string` | `"latest"` | no |
| storage\_os\_disk\_caching | Specifies the caching requirements for the OS Disk | `string` | `"ReadWrite"` | no |
| storage\_os\_disk\_custom\_name | Bastion OS disk name as displayed in the console | `string` | `""` | no |
| storage\_os\_disk\_managed\_disk\_type | Specifies the type of Managed Disk which should be created [Standard\_LRS, StandardSSD\_LRS, Premium\_LRS] | `string` | `"Standard_LRS"` | no |
| storage\_os\_disk\_size\_gb | Specifies the size of the OS Disk in gigabytes | `string` | n/a | yes |
| subnet\_bastion\_id | The bastion subnet id | `string` | n/a | yes |
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
<!-- END_TF_DOCS -->
## Related documentation

Azure remote management security documentation: [docs.microsoft.com/en-us/azure/security/azure-security-management](https://docs.microsoft.com/en-us/azure/security/azure-security-management)
