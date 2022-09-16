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

# Azure Public IP
variable "public_ip_sku" {
  description = <<EOD
Public IP SKU attached to the VM. Can be `null` if no public IP is needed.
If set to `null`, the Terraform module must be executed from a host having connectivity to the bastion private ip.
Thus, the bootstrap's ansible playbook will use the bastion private IP for inventory.
EOD
  type        = string
  default     = "Standard"
}

variable "public_ip_zones" {
  description = "Zones for public IP attached to the VM. Can be `null` if no zone distpatch."
  type        = list(number)
  default     = [1, 2, 3]
}

# Azure Network Interface
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

variable "vm_zone" {
  description = "Bastion Virtual Machine zone."
  type        = number
  default     = 1
}

variable "admin_username" {
  description = "Name of the admin user."
  type        = string
  default     = "claranet"
}

variable "ssh_public_key" {
  description = "SSH public key, generated if empty"
  type        = string
}

variable "ssh_private_key" {
  description = "SSH private key, generated if empty"
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

variable "storage_image_id" {
  description = "Specifies the image ID used to create the virtual machine"
  type        = string
  default     = null
}

variable "storage_os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk"
  type        = string
  default     = "ReadWrite"
}

variable "storage_os_disk_size_gb" {
  description = "Specifies the size of the OS Disk in gigabytes."
  type        = string
}

## Identity variables
variable "identity" {
  description = "Map with identity block informations as described here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}

## Backup variable
variable "backup_policy_id" {
  description = "Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup)."
  type        = string
}
