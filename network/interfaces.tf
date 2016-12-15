resource "azurerm_public_ip" "bastion" {
    name =  "ippub.${var.env}.bastion"
    location = "${var.az_region}"
    resource_group_name = "${var.resource_group_name}"
    public_ip_address_allocation = "static"

    tags {
        environment = "${var.env}"
    }
}

resource "azurerm_network_interface" "bastion" {
    name = "acctni.${var.env}.bastion"
    location = "${var.az_region}"
    resource_group_name = "${var.resource_group_name}"
    network_security_group_id = "${azurerm_network_security_group.bastion.id}"

    ip_configuration {
        name = "ipconfig.${var.env}.bastion"
        subnet_id = "${var.subnet_id}"
        private_ip_address_allocation = "static"
        private_ip_address = "${var.ip_bastion}"
        public_ip_address_id = "${azurerm_public_ip.bastion.id}"
    }
}
