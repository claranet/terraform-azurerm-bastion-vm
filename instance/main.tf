locals {
  bastion_tags = {
    env   = "${var.environment}"
    stack = "bastion"
  }
}

resource "azurerm_virtual_machine" "bastion_instance" {
  name                  = "${coalesce(var.custom_vm_name, "vm.${var.environment}.bastion")}"
  location              = "${var.location}"
  resource_group_name   = "${var.support_resourcegroup_name}"
  network_interface_ids = ["${var.bastion_network_interface_id}"]
  vm_size               = "${var.vm_size}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${coalesce(var.custom_disk_name, "md.${var.environment}.bastion")}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${coalesce(var.custom_vm_hostname, "vm-${var.environment}-bastion")}"
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

  tags = "${merge(local.bastion_tags, var.custom_tags)}"

  connection {
    user        = "claranet"
    private_key = "${file("~/.ssh/keys/${var.client_name}_${var.environment}.pem")}"
    host        = "${var.public_ip}"
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
      "NAME=${var.client_name}-bastion IP=${var.private_ip} /tmp/set_hostname_bastion.sh",
    ]
  }
}
