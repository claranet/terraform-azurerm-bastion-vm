# Azure Support Bastion module

This module creates a virtual machine to be used as a bastion/jump-host instance for Claranet.

## Requirements

* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/) >= 1.32
* [Ansible](https://github.com/ansible/ansible/) >= 2.5

## Terraform version compatibility

| Module version | Terraform version |
|----------------|-------------------|
| >= 2.x.x       | 0.12.x            |
| < 2.x.x        | 0.11.x            |

## Usage

Terraform module declaration example for your bastion support stack with all required modules:

```hcl
module "azure-region" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

  azure_region = var.azure_region
}

module "rg" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure-network-vnet" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/vnet.git?ref=vX.X.X"
    
  environment      = var.environment
  location         = module.azure-region.location
  location_short   = module.azure-region.location_short
  client_name      = var.client_name
  stack            = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "azure-network-subnet" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/subnet.git?ref=vX.X.X"

  environment           = var.environment
  location_short        = module.azure-region.location_short
  client_name           = var.client_name
  stack                 = var.stack
  custom_subnet_names   = var.custom_subnet_names

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.vnet.virtual_network_name
  subnet_cidr_list     = ["10.10.10.0/24"]
}


module "network-security-group" {
    source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/nsg.git?ref=vX.X.X"

    client_name         = var.client_name
    environment         = var.environment
    stack               = var.stack
    resource_group_name = module.rg.resource_group_name
    location            = module.azure-region.location
    location_short      = module.azure-region.location_short

    # You can set either a prefix for generated name or a custom one for the resource naming
    custom_name = var.security_group_name
}

module "bastion" {
    source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/bastion.git?ref=vX.X.X"

    client_name         = var.client_name
    location            = module.azure-region.location
    location_short      = module.azure-region.location_short
    environment         = var.environment
    stack               = var.stack
    name                = var.name
    resource_group_name = module.rg.resource_group_name

    subnet_bastion_id = element(module.subnet.subnet_ids, 0)

    vm_size                 = "Standard_DS1_v2"
    storage_os_disk_size_gb = "100"
    private_ip_bastion      = "10.10.10.10"

    # Put your SSH Public Key here
    ssh_key_pub      = file("./put_the_key_here.pub")
    private_key_path = var.private_key_path
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| admin\_username | Name of the admin user | `string` | `"claranet"` | no |
| ani\_extra\_tags | Additional tags to associate with your network interface. | `map(string)` | `{}` | no |
| bastion\_extra\_tags | Additional tags to associate with your bastion instance. | `map(string)` | `{}` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_disk\_name | Bastion disk name as displayed in the console | `string` | `""` | no |
| custom\_vm\_hostname | Bastion hostname | `string` | `""` | no |
| custom\_vm\_name | VM Name as displayed on the console | `string` | `""` | no |
| delete\_os\_disk\_on\_termination | Enable delete disk on termination | `bool` | `true` | no |
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
| storage\_os\_disk\_create\_option | Specifies how the OS disk shoulb be created | `string` | `"FromImage"` | no |
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
| bastion\_network\_public\_ip\_id | Bastion public ip id |
| bastion\_public\_domain\_name\_label | Bastion public DNS |
| bastion\_storage\_image\_reference | Bastion storage image reference object |
| bastion\_storage\_os\_disk | Bastion storage OS disk object |
| bastion\_virtual\_machine\_id | Bastion virtual machine id |
| bastion\_virtual\_machine\_name | Bastion virtual machine name |
| bastion\_virtual\_machine\_size | Bastion virtual machine size |

## Related documentation

Azure remote management security documentation: [docs.microsoft.com/en-us/azure/security/azure-security-management](https://docs.microsoft.com/en-us/azure/security/azure-security-management)
