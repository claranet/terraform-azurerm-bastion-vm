# Global module variable definition
variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "name_prefix" {
  description = "Optional prefix for resources naming"
  type        = string
  default     = "bastion-"
}

# Azure Public IP

variable "custom_public_ip_name" {
  description = "Name for the Public IP Address resource"
  type        = string
  default     = ""
}

# Azure Network Interface

variable "custom_nic_name" {
  description = "Name for the Network Interface"
  type        = string
  default     = ""
}

variable "custom_ipconfig_name" {
  description = "Name for the Network Interface ip configuration"
  type        = string
  default     = ""
}

variable "subnet_bastion_id" {
  description = "The bastion subnet id"
  type        = string
}

variable "private_ip_bastion" {
  description = "Allows to define the private ip to associate with the bastion"
  type        = string
}

# Azure Virtual Machine
variable "vm_size" {
  description = "Bastion virtual machine size"
  type        = string
}

variable "custom_vm_name" {
  description = "VM Name as displayed on the console"
  type        = string
  default     = ""
}

variable "custom_vm_hostname" {
  description = "Bastion hostname"
  type        = string
  default     = ""
}

variable "admin_username" {
  description = "Name of the admin user"
  type        = string
  default     = "claranet"
}

variable "ssh_key_pub" {
  description = "Root SSH pub key to deploy on the bastion"
  type        = string
}

variable "private_key_path" {
  description = "Root SSH private key path"
  type        = string
}

variable "storage_image_publisher" {
  description = "Specifies the publisher of the image used to create the virtual machine"
  type        = string
  default     = "Canonical"
}

variable "storage_image_offer" {
  description = "Specifies the offer of the image used to create the virtual machine"
  type        = string
  default     = "UbuntuServer"
}

variable "storage_image_sku" {
  description = "Specifies the SKU of the image used to create the virtual machine"
  type        = string
  default     = "18.04-LTS"
}

variable "storage_image_version" {
  description = "Specifies the version of the image used to create the virtual machine"
  type        = string
  default     = "latest"
}

variable "storage_os_disk_custom_name" {
  description = "Bastion OS disk name as displayed in the console"
  type        = string
  default     = ""
}

variable "storage_os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk"
  type        = string
  default     = "ReadWrite"
}

variable "storage_os_disk_size_gb" {
  description = "Specifies the size of the OS Disk in gigabytes"
  type        = string
}

variable "bastion_extra_tags" {
  description = "Additional tags to associate with your bastion instance."
  type        = map(string)
  default     = {}
}

variable "ani_extra_tags" {
  description = "Additional tags to associate with your network interface."
  type        = map(string)
  default     = {}
}

variable "pubip_extra_tags" {
  description = "Additional tags to associate with your public ip."
  type        = map(string)
  default     = {}
}

# Diagnostics/Logs
variable "diagnostics_storage_account_name" {
  description = "Name of the Storage Account in which store vm diagnostics"
  type        = string
}

variable "diagnostics_storage_account_sas_token" {
  description = "SAS token of the Storage Account in which store vm diagnostics"
  type        = string
}
