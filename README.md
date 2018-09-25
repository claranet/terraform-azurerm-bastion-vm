# Azure Support Bastion module #

Workaround:

- SSH Key file should be: `~/.ssh/keys/${var.client_name}_${var.environment}.pem` for now

Terraform module declaration example for your bastion support stack with default values:
```shell
module "bastion" {
  source = "git::ssh://git@bitbucket.org/morea/terraform.feature.azurerm.support.bastion.git?ref=xxx"
  
  client_name                  = "${var.client_name}"
  azurerm_region               = "${var.azurerm_region}"
  environment                  = "${var.environment}"
  
  support_resourcegroup_name   = "${var.support_resourcegroup_name}"
  support_dns_zone_name        = "${var.support_dns_zone_name}"
  
  subnet_bastion_id            = "${var.subnet_bastion_id}"
  
  vm_size                      = "${var.vm_size}"
  
  # Put your SSK Public Key here
  ssh_key_pub                  = "${file("./put_the_key_here.pub")}"
}

```

Terraform module declaration example for your bastion support stack with custom values:
```shell
module "bastion" {
  source = "git::ssh://git@bitbucket.org/morea/terraform.feature.azurerm.support.bastion.git?ref=xxx"
  
  client_name                  = "morea-demo"
  azurerm_region               = "West Europe"
  environment                  = "support"
  
  support_resourcegroup_name   = "${module.infra.support_resourcegroup_name}"
  support_dns_zone_name        = "${module.infra.support_dns_zone_name}"
  
  subnet_bastion_id            = "${module.infra.subnets_support_id[0]}"
  private_ip_bastion           = "10.10.10.10"
  
  vm_size                      = "Standard_DS1_v2"
  
  # Put your SSK Public Key here
  ssh_key_pub                  = "${file("./put_the_key_here.pub")}"

  custom_vm_name     = "${var.custom_vm_name}"
  custom_vm_hostname = "${var.custom_vm_hostname}"
  custom_disk_name   = "${var.custom_disk_name}"
  custom_username    = "${var.custom_username}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| azurerm_region |  | string | - | yes |
| client_name |  | string | - | yes |
| custom_admin_ips | Others administrator IPs to allow | list | `<list>` | no |
| custom_disk_name | Bastion disk name as displayed in the console | string | `` | no |
| custom_tags | Custom map of tags to apply on every resources | map | `<map>` | no |
| custom_username | Default username to create on the bastion | string | `` | no |
| custom_vm_hostname | Bastion hostname | string | `` | no |
| custom_vm_name | VM Name as displayed on the console | string | `` | no |
| environment |  | string | - | yes |
| private_ip_bastion |  | string | `10.10.1.10` | no |
| ssh_key_pub |  | string | - | yes |
| subnet_bastion_id |  | string | - | yes |
| support_dns_zone_name |  | string | - | yes |
| support_resourcegroup_name |  | string | - | yes |
| vm_size |  | string | - | yes |
| zabbix_allowed_cidrs |  | list | `<list>` | no |
| zabbix_omni_cidr |  | string | `31.3.142.1/32` | no |
| zabbix_proxy |  | string | `true` | no |
| zabbix_proxy_cidr |  | string | `` | no |
| zabbix_use_allowed_cidrs |  | string | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion_network_interface_id |  |
| bastion_network_private_ip |  |
| bastion_network_public_ip |  |
| record_bastion_name |  |
| record_zabbix_name |  |
