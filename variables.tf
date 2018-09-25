variable "client_name" {}

variable "azurerm_region" {}

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

variable "custom_vm_name" {
  description = "VM Name as displayed on the console"
  default     = ""
}

variable "custom_vm_hostname" {
  description = "Bastion hostname"
  default     = ""
}

variable "custom_disk_name" {
  description = "Bastion disk name as displayed in the console"
  default     = ""
}

variable "custom_username" {
  description = "Default username to create on the bastion"
  default     = ""
}

variable "custom_admin_ips" {
  description = "Others administrator IPs to allow"
  type        = "list"
  default     = []
}
