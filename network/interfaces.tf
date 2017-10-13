resource "azurerm_public_ip" "bastion" {
  name                         = "ip.pub.${var.environment}.bastion"
  location                     = "${var.azurerm_region}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_network_interface" "bastion" {
  name                      = "ani.${var.environment}.bastion"
  location                  = "${var.azurerm_region}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${azurerm_network_security_group.bastion.id}"

  ip_configuration {
    name                          = "ipconfig.${var.environment}.bastion"
    subnet_id                     = "${var.subnet_bastion_id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.private_ip_bastion}"
    public_ip_address_id          = "${azurerm_public_ip.bastion.id}"
  }
}
