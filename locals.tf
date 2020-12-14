locals {
  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""

  default_basename = lower("${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")

  hostname = coalesce(var.custom_vm_hostname, local.default_basename)

  bastion_tags = {
    env    = var.environment
    stack  = var.stack
    module = "bastion"
  }
}

