variable "client_name" {}

variable "az_region" {}

variable "environment" {}

variable "support_resourcegroup_name" {}

variable "support_dns_zone_name" {}

variable "subnet_bastion_id" {}

variable "private_ip_bastion" {
  default = "10.10.1.10"
}

variable "ssh_key_pub" {}

variable "vm_size" {}

variable "zabbix_omni_cidr" {
  default = "31.3.142.1/32"
}

variable "zabbix_proxy" {
  default = "true"
}

variable "zabbix_use_allowed_cidrs" {
  default = 0
}

variable "zabbix_allowed_cidrs" {
  type    = "list"
  default = []
}

variable "zabbix_proxy_cidr" {
  #SET IF DIFFERENT FROM BASTION
  default = ""
}

variable "morea_admin_ips" {
  type = "list"
}
