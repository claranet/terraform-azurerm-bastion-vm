variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
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
