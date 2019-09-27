# Azure Support Bastion module

This module creates a virtual machine to be used as a bastion/jump-host instance for Claranet.

## Requirements

- SSH key files should be generated: `~/.ssh/keys/${var.client_name}_${var.environment}.[pem,pub]`
- Ansible version >= 2.5

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
    location-short      = module.azure-region.location_short
    environment         = var.environment
    stack               = var.stack
    name                = var.name
    resource_group_name = module.rg.resource_group_name

    subnet_bastion_id = element(module.subnet.subnet_ids, 0)

    vm_size                      = "Standard_DS1_v2"
    storage_os_disk_disk_size_gb = "100"

    # Put your SSH Public Key here
    ssh_key_pub      = file("./put_the_key_here.pub")
    private_key_path = var.private_key_path
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ani\_extra\_tags | Custom map of tags to apply on network interface resource | map(string) | `<map>` | no |
| bastion\_extra\_tags | Custom map of tags to apply on bastion resource | map(string) | `<map>` | no |
| client\_name | Client name/account used in naming | string | n/a | yes |
| custom\_disk\_name | Bastion disk name as displayed in the console | string | `""` | no |
| custom\_username | Default username to create on the bastion | string | `""` | no |
| custom\_vm\_hostname | Bastion hostname | string | `""` | no |
| custom\_vm\_name | VM Name as displayed on the console | string | `""` | no |
| delete\_os\_disk\_on\_termination | Enable delete disk on termination | string | `"true"` | no |
| environment | Project environment | string | n/a | yes |
| location | Azure region to use | string | n/a | yes |
| location\_short | Short string for Azure location | string | n/a | yes |
| name\_prefix | Optional prefix for subnet names | string | `""` | no |
| private\_ip\_bastion | Allows to define the private ip to associate with the bastion | string | `""` | no |
| private\_key\_path | Root SSH private key path | string | n/a | yes |
| pubip\_extra\_tags | Custom map of tags to apply on public ip resource | map(string) | `<map>` | no |
| resource\_group\_name | Name of the resource group | string | n/a | yes |
| ssh\_key\_pub | Root SSH pub key to deploy on the bastion | string | n/a | yes |
| stack | Project stack name | string | n/a | yes |
| storage\_image\_offer | Specifies the offer of the image used to create the virtual machine | string | `"UbuntuServer"` | no |
| storage\_image\_publisher | Specifies the publisher of the image used to create the virtual machine | string | `"Canonical"` | no |
| storage\_image\_sku | Specifies the SKU of the image used to create the virtual machine | string | `"18.04-LTS"` | no |
| storage\_os\_disk\_caching | Specifies the caching requirements for the OS Disk | string | `"ReadWrite"` | no |
| storage\_os\_disk\_create\_option | Specifies how the OS disk shoulb be created | string | `"FromImage"` | no |
| storage\_os\_disk\_managed\_disk\_type | Specifies the type of Managed Disk which should be created [Standard_LRS, StandardSSD_LRS, Premium_LRS] | string | `"Standard_LRS"` | no |
| storage\_os\_disk\_size\_gb | Specifies the size of the OS Disk in gigabytes | string | n/a | yes |
| subnet\_bastion\_id | The bastion subnet id | string | n/a | yes |
| vm\_size | Bastion virtual machine size | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_network\_interface\_id | Bastion network interface id |
| bastion\_network\_interface\_private\_ip | Bastion private ip |
| bastion\_network\_public\_ip | Bastion public ip |
| bastion\_network\_public\_ip\_id | Bastion public ip id |
| bastion\_virtual\_machine\_id | Bastion virtual machine id |
| bastion\_virtual\_machine\_name | Bastion virtual machine name |

## Related documentation

Azure remote management security documentation: [https://docs.microsoft.com/en-us/azure/security/azure-security-management]
