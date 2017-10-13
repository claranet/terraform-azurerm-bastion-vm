# Azure Support Bastion module #

Workaround :

- SSH Key file should be : ~/.ssh/keys/${var.client_name}_${var.environment}.pem for now
- A variable map will be implemented to associate "West Europe" to "westeurope" or something like that

Terraform module declaration example for your bastion support stack with default values :
```
module "bastion" {
  source = "git::ssh://git@bitbucket.org/morea/terraform.feature.azurerm.support.bastion.git?ref=TER-14-azure-bastion-zabbix-proxy-templa"
  
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

Terraform module declaration example for your bastion support stack with custom values :
```
module "bastion" {
  source = "git::ssh://git@bitbucket.org/morea/terraform.feature.azurerm.support.bastion.git?ref=TER-14-azure-bastion-zabbix-proxy-templa"
  
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
}
```

Outputs available:
```
bastion_network_interface_id

bastion_network_private_ip

bastion_network_public_ip

record_bastion_name

record_zabbix_name
```