variable "client_name" {}
variable "az_region" {}
variable "env" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "vm_size" {}
variable "ip_bastion" {
  default = "10.10.1.10"
}
variable "ssh_key_pub" {}
