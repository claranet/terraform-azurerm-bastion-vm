module "network" {
  source = "./network"

  environment      = "${var.environment}"
  azurerm_region   = "${var.azurerm_region}"

  resource_group_name = "${var.support_resourcegroup_name}"
  private_ip_bastion  = "${var.private_ip_bastion}"
  subnet_bastion_id   = "${var.subnet_bastion_id}"

  zabbix_omni_cidr         = "${var.zabbix_omni_cidr}"
  cloudpublic_admin_ips    = "${var.morea_admin_ips}"
  zabbix_use_allowed_cidrs = "${var.zabbix_use_allowed_cidrs}"
  zabbix_allowed_cidrs     = "${var.zabbix_allowed_cidrs}"

  zabbix_proxy      = "${var.zabbix_proxy}"
  zabbix_proxy_cidr = "${var.zabbix_proxy_cidr}"
}

module "dns" {
  source = "./dns"

  support_dns_zone_name      = "${var.support_dns_zone_name}"
  support_resourcegroup_name = "${var.support_resourcegroup_name}"

  bastion_ip   = "${module.network.bastion_network_public_ip}"
  zabbix_proxy = "${var.zabbix_proxy}"
}

module "instance" {
  source = "./instance"

  environment      = "${var.environment}"
  azurerm_region   = "${var.azurerm_region}"

  support_resourcegroup_name   = "${var.support_resourcegroup_name}"
  bastion_network_interface_id = "${module.network.bastion_network_interface_id}"
  vm_size                      = "${var.vm_size}"

  private_ip = "${module.network.bastion_network_private_ip}"
  public_ip  = "${module.network.bastion_network_public_ip}"

  ssh_key_pub = "${var.ssh_key_pub}"
  client_name = "${var.client_name}"
}
