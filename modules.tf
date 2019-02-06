resource "azurerm_public_ip" "bastion" {
  name                         = "${var.stack}-${var.environment}-${var.location-short}-pubip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"

  tags = "${merge(local.bastion_tags, var.extra_tags)}"
}

resource "azurerm_network_interface" "bastion" {
  name                      = "${var.stack}-${var.environment}-${var.location-short}-nic"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${var.network_security_group_id}"

  ip_configuration {
    name                          = "${var.stack}-${var.environment}-${var.location-short}-ipconfig"
    subnet_id                     = "${var.subnet_bastion_id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.private_ip_bastion}"
    public_ip_address_id          = "${azurerm_public_ip.bastion.id}"
  }

  tags = "${merge(local.bastion_tags, var.extra_tags)}"
}

resource "azurerm_virtual_machine" "bastion_instance" {
  name                  = "${coalesce(var.custom_vm_name, "${var.stack}-${var.environment}-${var.location-short}-vm")}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.bastion.id}"]
  vm_size               = "${var.vm_size}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = "true"

  # To update ?
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${coalesce(var.custom_disk_name, "${var.stack}-${var.environment}-${var.location-short}-osdisk")}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${coalesce(var.custom_vm_hostname, "${var.stack}-${var.environment}-${var.location-short}-osprofile")}"
    admin_username = "${coalesce(var.custom_username, "claranet")}"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = "true"

    ssh_keys {
      path     = "/home/claranet/.ssh/authorized_keys"
      key_data = "${var.ssh_key_pub}"
    }
  }
  tags = "${merge(local.bastion_tags, var.extra_tags)}"
  connection {
    user        = "claranet"
    private_key = "${file("~/.ssh/keys/${var.client_name}_${var.environment}.pem")}"
    host        = "${azurerm_public_ip.bastion.ip_address}"
  }
  provisioner "local-exec" {
    command = "bash ${path.module}/files/prepare-formula.sh"
  }
  provisioner "file" {
    source      = "/tmp/bastion-formula"
    destination = "/tmp/"
  }
  provisioner "file" {
    source      = "/tmp/morea-tools"
    destination = "/tmp/"
  }
  provisioner "file" {
    content     = "${data.template_file.top-pillar.rendered}"
    destination = "/tmp/bastion-formula/pillar/top.sls"
  }
  provisioner "file" {
    content     = "${data.template_file.pillar.rendered}"
    destination = "/tmp/bastion-formula/pillar/bastion.sls"
  }
  provisioner "file" {
    content     = "${data.template_file.top-salt.rendered}"
    destination = "/tmp/bastion-formula/salt/top.sls"
  }
  provisioner "remote-exec" {
    script = "${path.module}/files/configure-bastion.sh"
  }
  provisioner "file" {
    source      = "${var.custom_vm_hostname == "" ? "${path.module}/files/set_hostname.sh" : "${path.module}/files/empty_script.sh" }"
    destination = "/tmp/set_hostname_bastion.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/set_hostname_bastion.sh",
      "NAME=${var.client_name}-bastion IP=${azurerm_network_interface.bastion.private_ip_address} /tmp/set_hostname_bastion.sh",
    ]
  }
}

resource "azurerm_dns_a_record" "record_bastion" {
  name                = "bastion"
  zone_name           = "${var.support_dns_zone_name}"
  resource_group_name = "${var.resource_group_name}"
  ttl                 = 300
  records             = ["${azurerm_public_ip.bastion.ip_address}"]
}
