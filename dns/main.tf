resource "azurerm_dns_a_record" "record_bastion" {
  name                = "bastion"
  zone_name           = "${var.support_dns_zone_name}"
  resource_group_name = "${var.support_resourcegroup_name}"
  ttl                 = 300
  records             = ["${var.bastion_ip}"]
}

resource "azurerm_dns_cname_record" "record_zabbix" {
  count               = "${var.zabbix_proxy == "true" ? 1 : 0 }"
  name                = "zabbix"
  zone_name           = "${var.support_dns_zone_name}"
  resource_group_name = "${var.support_resourcegroup_name}"
  ttl                 = 300
  record              = "bastion.${var.support_dns_zone_name}"
}
