# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = "bastion"
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_caf_naming" {
  description = "Use the Azure CAF naming provider to generate default resource name. `custom_*_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}

# Custom naming override
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

variable "custom_public_ip_name" {
  description = "Name for the Public IP Address resource"
  type        = string
  default     = ""
}

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

variable "storage_os_disk_custom_name" {
  description = "Bastion OS disk name as displayed in the console"
  type        = string
  default     = ""
}
