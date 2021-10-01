variable "azure_region" {
  description = "Azure region to use."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
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

variable "ssh_private_key_path" {
  description = "SSH Private Key path on bastion VM"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key to authorize on bastion"
  type        = string
}

variable "security_group_name" {
  description = "Custom name for the Network Security Group"
  type        = string
}
