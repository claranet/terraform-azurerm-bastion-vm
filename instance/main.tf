resource "azurerm_managed_disk" "managed_data_bastion" {
  name                 = "managed_data_bastion"
  location             = "${var.az_region}"
  resource_group_name  = "${var.support_resourcegroup_name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

resource "azurerm_virtual_machine" "bastion_instance" {
  name                  = "bastion"
  location              = "${var.az_region}"
  resource_group_name   = "${var.support_resourcegroup_name}"
  network_interface_ids = ["${var.bastion_network_interface_id}"]
  vm_size               = "${var.vm_size}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "bastion_os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  # Optional data disks
  storage_data_disk {
    name            = "${azurerm_managed_disk.managed_data_bastion.name}"
    managed_disk_id = "${azurerm_managed_disk.managed_data_bastion.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.managed_data_bastion.disk_size_gb}"
  }
  os_profile {
    computer_name  = "bastion"
    admin_username = "morea"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path = "/home/morea/.ssh/authorized_keys"
      key_data = "${var.ssh_key_pub}"
    }
  }
  tags {
    environment = "${var.environment}"
  }
  connection {
    user = "morea"
    private_key = "${file("~/.ssh/keys/${var.client_name}_${var.environment}.pem")}"
    host = "${var.public_ip}"
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
    source      = "${path.module}/files/set_hostname.sh"
    destination = "/tmp/set_hostname_bastion.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/set_hostname_bastion.sh",
      "NAME=${var.client_name}-bastion IP=${var.private_ip} /tmp/set_hostname_bastion.sh",
    ]
  }
}
