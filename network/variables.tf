variable "resource_group_name" {}

variable "environment" {}

variable "az_region" {}

variable "private_ip_bastion" {}

variable "subnet_bastion_id" {}

variable "morea_admin_ips" {
  type = "list"
}
