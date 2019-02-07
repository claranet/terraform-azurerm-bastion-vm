# Azure Support Bastion module #

Workaround:

- SSH Key file should be: `~/.ssh/keys/${var.client_name}_${var.environment}.pem` for now

Terraform module declaration example for your bastion support stack with all required modules :

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

module "subnet" {
    source              = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/subnet.git?ref=vX.X.X"

    environment         = "${var.environment}"
    location-short      = "${module.azure-region.location-short}" 
    client_name         = "${var.client_name}"
    stack               = "${var.stack}"
    custom_subnet_name  = "${var.custom_subnet_name}"

    resource_group_name     = "${module.rg.resource_group_name}"
    virtual_network_name    = "${module.vnet.virtual_network_name}"
    subnet_cidr             = "${var.subnet_cidr}"
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
  resource_group_name          = "${module.rg.resource_group_name}"

  network_security_group_id    = "${module.nsg.network_security_group_id}"
  subnet_bastion_id            = "${module.subnet.subnet_id}"

  vm_size                      = "${var.vm_size}"
  
  # Put your SSK Public Key here
  ssh_key_pub                  = "${file("./put_the_key_here.pub")}"
  
  support_dns_zone_name        = "${var.support_dns_zone_name}"
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
| private_ip_bastion | Allows to define the private ip to associate with the bastion | string | `` | no |
| resource_group_name | Name of the resource group | string | - | yes |
| ssh_key_pub | Root SSH pub key to deploy on the bastion | string | - | yes |
| stack | Project stack name | string | - | yes |
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
