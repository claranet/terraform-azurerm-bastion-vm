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

# Ansible playbook
variable "deploy_builtin_ansible_playbook" {
  description = "If set to the `true`, the builtin bootstrapped ansible playbook will be exectued."
  type        = bool
  default     = true
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

variable "custom_facing_ip_address" {
  description = "Custom IP address to use (for ansible provisioning, and SSH connection), useful if you have a firewall in front of the VM."
  default     = null
  type        = string
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

# VM boot scripts

variable "custom_data" {
  description = "The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "user_data" {
  description = "The Base64-Encoded User Data which should be used for this Virtual Machine."
  type        = string
  default     = null
}

# VM OS disk/image

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

variable "storage_os_disk_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`."
  type        = string
  default     = "Premium_ZRS"
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

# Update Management
variable "patch_mode" {
  description = "Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are `AutomaticByPlatform` and `ImageDefault`"
  type        = string
  default     = "ImageDefault"
}
