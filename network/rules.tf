resource "azurerm_network_security_rule" "bastion-allow-outbound" {
  name                        = "AllowOutBound"
  priority                    = "100"
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
  priority                    = "300"
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

resource "azurerm_network_security_rule" "bastion-allow-ssh-cloudpublic" {
  name                        = "AllowSshFromCloudPublic${count.index}"
  priority                    = "10${count.index}"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${element(var.cloudpublic_admin_ips, count.index)}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.bastion.name}"

  count = "${length(var.cloudpublic_admin_ips)}"
}

resource "azurerm_network_security_rule" "bastion-allow-zabbix-passive-from-omni-cidr-to-bastion" {
  count                       = "${var.zabbix_proxy ? 1 : 0}"
  name                        = "AllowZabbixPassiveFromOmni"
  priority                    = "200"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "10050"
  source_address_prefix       = "${var.zabbix_omni_cidr}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.bastion.name}"
}

resource "azurerm_network_security_rule" "bastion-allow-zabbix-from-infra" {
  count                       = "${(var.zabbix_proxy ? 1 : 0) * var.zabbix_use_allowed_cidrs}"
  name                        = "AllowZabbixFromInfra${count.index}"
  priority                    = "21${count.index}"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "10051"
  source_address_prefix       = "${element(var.zabbix_allowed_cidrs, count.index)}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.bastion.name}"
}

resource "azurerm_network_security_rule" "bastion-allow-zabbix-proxy" {
  count                       = "${var.zabbix_proxy ? 0 : 1}"
  name                        = "AllowZabbixPassiveFromOmni"
  priority                    = "200"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "10050"
  source_address_prefix       = "${var.zabbix_proxy_cidr}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.bastion.name}"
}
