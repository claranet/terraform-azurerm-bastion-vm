variable "support_resourcegroup_name" {}

variable "environment" {}

variable "location" {}

variable "bastion_network_interface_id" {}

variable "client_name" {}

variable "private_ip" {}

variable "public_ip" {}

variable "ssh_key_pub" {}

variable "vm_size" {}

variable "custom_vm_name" {}

variable "custom_vm_hostname" {}

variable "custom_disk_name" {}

variable "custom_username" {}

variable "custom_tags" {
  description = "Custom map of tags to apply on every resources"
  type        = "map"
}
