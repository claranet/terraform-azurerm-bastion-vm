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

variable "name" {
  description = "Name used for resource naming"
  type        = "string"
}

variable "extra_tags" {
  description = "Custom map of tags to apply on every resources"
  type        = "map"
  default     = {}
}

# Azure Network Interface

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

variable "private_key_path" {
  description = "Root SSH private key path"
  type        = "string"
}

variable "delete_os_disk_on_termination" {
  description = "Enable delete disk on termination"
  type        = "string"
  default     = "true"
}

variable "storage_image_publisher" {
  description = "Specifies the publisher of the image used to create the virtual machine"
  type        = "string"
  default     = "Canonical"
}

variable "storage_image_offer" {
  description = "Specifies the offer of the image used to create the virtual machine"
  type        = "string"
  default     = "UbuntuServer"
}

variable "storage_image_sku" {
  description = "Specifies the SKU of the image used to create the virtual machine"
  type        = "string"
  default     = "16.04-LTS"
}

variable "storage_os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk"
  type        = "string"
  default     = "ReadWrite"
}

variable "storage_os_disk_create_option" {
  description = "Specifies how the OS disk shoulb be created"
  type        = "string"
  default     = "FromImage"
}

variable "storage_os_disk_managed_disk_type" {
  description = "Specifies the type of Managed Disk which should be created [Standard_LRS, StandardSSD_LRS, Premium_LRS]"
  type        = "string"
  default     = "Standard_LRS"
}

variable "storage_os_disk_disk_size_gb" {
  description = "Specifies the size of the OS Disk in gigabytes"
  type        = "string"
}
