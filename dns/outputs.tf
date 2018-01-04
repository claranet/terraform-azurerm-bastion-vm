output "record_bastion_name" {
  value = "${azurerm_dns_a_record.record_bastion.name}"
}

output "record_zabbix_name" {
  value = "${azurerm_dns_cname_record.record_zabbix.name}"
}
