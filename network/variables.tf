variable "resource_group_name" {}

variable "environment" {}

variable "az_region" {}

variable "private_ip_bastion" {}

variable "subnet_bastion_id" {}

variable "cloudpublic_admin_ips" {
  type = "list"
}

variable "zabbix_omni_cidr" {}

variable "zabbix_allowed_cidrs" {
  type = "list"
}

variable "zabbix_use_allowed_cidrs" {}

variable "zabbix_proxy" {}

variable "zabbix_proxy_cidr" {}
