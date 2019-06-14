locals {
  default_basename = "bastion-${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"

  bastion_tags = {
    env    = "${var.environment}"
    stack  = "${var.stack}"
    module = "bastion"
  }
}
