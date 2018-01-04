output "bastion_network_interface_id" {
  value = "${module.network.bastion_network_interface_id}"
}

output "bastion_network_private_ip" {
  value = "${module.network.bastion_network_private_ip}"
}

output "bastion_network_public_ip" {
  value = "${module.network.bastion_network_public_ip}"
}

output "record_bastion_name" {
  value = "${module.dns.record_bastion_name}"
}

output "record_zabbix_name" {
  value = "${module.dns.record_zabbix_name}"
}
