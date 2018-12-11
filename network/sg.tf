resource "azurerm_network_security_group" "bastion" {
  name                = "sg.${var.environment}.bastion"
  location            = "${var.azurerm_region}"
  resource_group_name = "${var.resource_group_name}"

  tags = "${merge(local.bastion_tags, var.custom_tags)}"
}
