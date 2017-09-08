resource "azurerm_virtual_machine" "bastion" {
    name = "acctvm.${var.environment}.bastion"
    location = "${var.az_region}"
    resource_group_name =  "${var.resource_group_name}"
    network_interface_ids = ["${var.network_interface_id}"]
    vm_size = "${var.vm_size}"

    storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "14.04.2-LTS"
        version = "latest"
    }

    storage_os_disk {
        name = "osdisk.${var.environment}.bastion"
        vhd_uri = "${var.primary_blob_endpoint}${var.container_name}/bastion.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
        #disk_size_gb = "10"
    }

    os_profile {
        computer_name = "bastion"
        admin_username = "morea"
        admin_password = "morea1234!"
    }

    os_profile_linux_config {
      disable_password_authentication = false
      ssh_keys {
        path = "/home/morea/.ssh/authorized_keys"
        key_data = "${var.ssh_key_pub}"
      }
    }

    tags {
      environment = "${var.environment}"
    }

    connection {
      user        = "morea"
      #private_key = "${file("~/.ssh/keys/${var.client_name}_${var.environment}_${var.aws_region}.pem")}"
      #private_key = "${file("~/.ssh/keys/baptiste-morea.pem")}"
      host        = "${var.public_ip}"
      password    = "morea1234!"
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
      source = "${path.module}/files/set_hostname.sh"
      destination = "/tmp/set_hostname_bastion.sh"
    }

    provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/set_hostname_bastion.sh",
        "NAME=${var.client_name}-bastion IP=${var.private_ip} /tmp/set_hostname_bastion.sh"
      ]
    }


}
