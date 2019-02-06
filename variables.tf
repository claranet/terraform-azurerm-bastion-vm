# Global module variable definition
variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "location" {
  description = "Azure region to use"
}

variable "location-short" {
  description = "Short string for Azure location"
}

variable "environment" {
  description = "Project environment"
}

variable "stack" {
  description = "Project stack name"
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = "string"
}

variable "extra_tags" {
  description = "Custom map of tags to apply on every resources"
  type        = "map"
  default     = {}
}

# Azure Network Interface
variable "network_security_group_id" {
  description = "The network security group id to associate with the interface"
  type        = "string"
}

variable "subnet_bastion_id" {
  description = "The bastion subnet id"
  type        = "string"
}

variable "private_ip_bastion" {
  description = "Allows to define the private ip to associate with the bastion"
  type        = "string"
  default     = ""
}

# Azure Virtual Machine
variable "vm_size" {
  description = "Bastion virtual machine size"
  type        = "string"
}

variable "custom_vm_name" {
  description = "VM Name as displayed on the console"
  type        = "string"
  default     = ""
}

variable "custom_vm_hostname" {
  description = "Bastion hostname"
  type        = "string"
  default     = ""
}

variable "custom_disk_name" {
  description = "Bastion disk name as displayed in the console"
  type        = "string"
  default     = ""
}

variable "custom_username" {
  description = "Default username to create on the bastion"
  type        = "string"
  default     = ""
}

variable "ssh_key_pub" {
  description = "Root SSH pub key to deploy on the bastion"
  type        = "string"
}

# Azure DNS

variable "support_dns_zone_name" {
  description = "Support DNS zone name"
  type        = "string"
}
