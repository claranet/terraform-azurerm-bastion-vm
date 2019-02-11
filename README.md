# Azure Support Bastion module #

Requirements:

- SSH Key file should be generated: `~/.ssh/keys/${var.client_name}_${var.environment}.pem`
- Ansible version >= 2.5

Terraform module declaration example for your bastion support stack with all required modules:

```shell
module "azure-region" {
    source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

    azure_region = "${var.azure_region}"
}

module "rg" {
    source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

    location     = "${module.azure-region.location}"
    client_name  = "${var.client_name}"
    environment  = "${var.environment}"
    stack        = "${var.stack}"
}

module "vnet" {
    source              = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/vnet.git?ref=xxx"
    
    environment         = "${var.environment}"
    location            = "${module.azure-region.location}"
    location-short      = "${module.azure-region.location-short}"
    client_name         = "${var.client_name}"
    stack               = "${var.stack}"
    custom_vnet_name    = "${var.custom_vnet_name}"

    resource_group_name     = "${module.rg.resource_group_name}"
    vnet_cidr               = ["10.10.0.0/16"]
}

module "subnet" {
    source              = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/subnet.git?ref=vX.X.X"

    environment         = "${var.environment}"
    location-short      = "${module.azure-region.location-short}" 
    client_name         = "${var.client_name}"
    stack               = "${var.stack}"
    custom_subnet_name  = "${var.custom_subnet_name}"

    resource_group_name     = "${module.rg.resource_group_name}"
    virtual_network_name    = "${module.vnet.virtual_network_name}"
    subnet_cidr             = "10.10.10.0/24"
}

module "nsg" {
    source                      = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/nsg.git?ref=xxx"
    client_name                 = "${var.client_name}"
    environment                 = "${var.environment}"
    stack                       = "${var.stack}"
    resource_group_name         = "${module.rg.resource_group_name}"
    location                    = "${module.azure-region.location}"
    location_short              = "${module.azure-region.location_short}"
    name                        = "${var.name}"
}

module "bastion" {
  source = "git@git.fr.clara.net:claranet/cloudnative/projects/cloud/azure/terraform/modules/bastion.git?ref=xxx"
  
  client_name                  = "${var.client_name}"
  location                     = "${module.azure-region.location}"
  location-short               = "${module.azure-region.location-short}"
  environment                  = "${var.environment}"
  stack                        = "${var.stack}"
  name                         = "${var.name}"
  resource_group_name          = "${module.rg.resource_group_name}"

  subnet_bastion_id            = "${module.subnet.subnet_id}"
  
  vm_size                      = "Standard_DS1_v2"
  
  # Put your SSK Public Key here
  ssh_key_pub                  = "${file("./put_the_key_here.pub")}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client_name | Client name/account used in naming | string | - | yes |
| custom_disk_name | Bastion disk name as displayed in the console | string | `` | no |
| custom_username | Default username to create on the bastion | string | `` | no |
| custom_vm_hostname | Bastion hostname | string | `` | no |
| custom_vm_name | VM Name as displayed on the console | string | `` | no |
| delete_os_disk_on_termination | Enable delete disk on termination | string | `true` | no |
| environment | Project environment | string | - | yes |
| extra_tags | Custom map of tags to apply on every resources | map | `<map>` | no |
| location | Azure region to use | string | - | yes |
| location-short | Short string for Azure location | string | - | yes |
| name | Name used for resource naming | string | - | yes |
| private_ip_bastion | Allows to define the private ip to associate with the bastion | string | `` | no |
| resource_group_name | Name of the resource group | string | - | yes |
| ssh_key_pub | Root SSH pub key to deploy on the bastion | string | - | yes |
| stack | Project stack name | string | - | yes |
| storage_image_offer | Specifies the offer of the image used to create the virtual machine | string | `UbuntuServer` | no |
| storage_image_publisher | Specifies the publisher of the image used to create the virtual machine | string | `Canonical` | no |
| storage_image_sku | Specifies the SKU of the image used to create the virtual machine | string | `16.04-LTS` | no |
| storage_os_disk_caching | Specifies the caching requirements for the OS Disk | string | `ReadWrite` | no |
| storage_os_disk_create_option | Specifies how the OS disk shoulb be created | string | `FromImage` | no |
| storage_os_disk_disk_size_gb | Specifies the size of the OS Disk in gigabytes | string | - | yes |
| storage_os_disk_managed_disk_type | Specifies the type of Managed Disk which should be created [Standard_LRS, StandardSSD_LRS, Premium_LRS] | string | `Standard_LRS` | no |
| subnet_bastion_id | The bastion subnet id | string | - | yes |
| vm_size | Bastion virtual machine size | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion_network_interface_id | Bastion network interface id |
| bastion_network_interface_private_ip | Bastion private ip |
| bastion_network_public_ip | Bastion public ip |
| bastion_network_public_ip_id | Bastion public ip id |
| bastion_virtual_machine_id | Bastion virtual machine id |
