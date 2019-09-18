locals {
  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : "bastion-"

  default_basename = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"

  bastion_tags = {
    env    = var.environment
    stack  = var.stack
    module = "bastion"
  }
}

