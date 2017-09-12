resource "azurerm_storage_account" "bastion" {
  name                = "accsa${var.environment}bastion"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.az_region}"
  account_type        = "Standard_LRS"

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_storage_container" "bastion" {
  name                  = "vhds"
  resource_group_name   = "${var.resource_group_name}"
  storage_account_name  = "${azurerm_storage_account.bastion.name}"
  container_access_type = "private"
}
