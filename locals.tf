locals {
  bastion_tags = {
    env   = "${var.environment}"
    stack = "bastion"
  }
}
