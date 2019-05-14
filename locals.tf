locals {
  default_basename = "${var.name}-${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"

  bastion_tags = {
    env   = "${var.environment}"
    stack = "bastion"
  }
}
