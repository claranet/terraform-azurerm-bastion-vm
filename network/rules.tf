resource "azurerm_network_security_rule" "bastion-allow-outbound" {
    name                        = "AllowOutBound"
    priority                    = 100
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = "${var.resource_group_name}"
    network_security_group_name = "${azurerm_network_security_group.bastion.name}"
}

resource "azurerm_network_security_rule" "bastion-deny-default" {
    name                        = "DenyInBound"
    priority                    = 101
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = "${var.resource_group_name}"
    network_security_group_name = "${azurerm_network_security_group.bastion.name}"
}

resource "azurerm_network_security_rule" "bastion-allow-ssh-morea" {
    name                        = "AllowSshFromMorea"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "31.3.136.12/32"
    destination_address_prefix  = "*"
    resource_group_name         = "${var.resource_group_name}"
    network_security_group_name = "${azurerm_network_security_group.bastion.name}"
}

resource "azurerm_network_security_rule" "bastion-allow-zabbix-morea" {
    name                        = "AllowSshFromMorea"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "10050"
    source_address_prefix       = ["${var.zabbix_omni_cidr}"]
    destination_address_prefix  = "*"
    resource_group_name         = "${var.resource_group_name}"
    network_security_group_name = "${azurerm_network_security_group.bastion.name}"
}