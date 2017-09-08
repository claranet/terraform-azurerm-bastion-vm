variable "client_name" {}

variable "az_region" {}

variable "environment" {}

variable "resource_group_name" {}

variable "subnet_bastion_id" {}

variable "vm_size" {}

variable "ip_bastion" {
  default = "10.10.1.10"
}

variable "ssh_key_pub" {}

variable "zabbix_omni_cidr" {}
