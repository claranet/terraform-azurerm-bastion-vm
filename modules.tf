resource "azurerm_public_ip" "bastion" {
  name                         = "${local.default_basename}-pubip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"

  tags = "${merge(local.bastion_tags, var.pubip_extra_tags)}"
}

resource "azurerm_network_interface" "bastion" {
  name                = "${local.default_basename}-nic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "${local.default_basename}-ipconfig"
    subnet_id                     = "${var.subnet_bastion_id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.private_ip_bastion}"
    public_ip_address_id          = "${azurerm_public_ip.bastion.id}"
  }

  tags = "${merge(local.bastion_tags, var.ani_extra_tags)}"
}

resource "azurerm_virtual_machine" "bastion_instance" {
  name                  = "${coalesce(var.custom_vm_name, "${local.default_basename}-vm")}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.bastion.id}"]
  vm_size               = "${var.vm_size}"

  delete_os_disk_on_termination = "${var.delete_os_disk_on_termination}"

  storage_image_reference {
    publisher = "${var.storage_image_publisher}"
    offer     = "${var.storage_image_offer}"
    sku       = "${var.storage_image_sku}"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${coalesce(var.custom_disk_name, "${local.default_basename}-osdisk")}"
    caching           = "${var.storage_os_disk_caching}"
    create_option     = "${var.storage_os_disk_create_option}"
    managed_disk_type = "${var.storage_os_disk_managed_disk_type}"
    disk_size_gb      = "${var.storage_os_disk_size_gb}"
  }

  os_profile {
    computer_name  = "${coalesce(var.custom_vm_hostname, "${local.default_basename}")}"
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

  tags = "${merge(local.bastion_tags, var.bastion_extra_tags)}"
}

data "template_file" "ansible_inventory" {
  template = "${file("${path.module}/playbook-ansible/host_ini.tpl")}"

  vars {
    vm_fullname = "${azurerm_virtual_machine.bastion_instance.name}"
    vm_ip       = "${azurerm_public_ip.bastion.ip_address}"
    vm_user     = "claranet"
  }
}

resource "local_file" "rendered_ansible_inventory" {
  content  = "${data.template_file.ansible_inventory.rendered}"
  filename = "${path.module}/playbook-ansible/host.ini"
}

resource "null_resource" "ansible_bootstrap_vm" {
  depends_on = ["azurerm_virtual_machine.bastion_instance"]

  triggers {
    uuid = "${azurerm_virtual_machine.bastion_instance.id}"
  }

  provisioner "local-exec" {
    command = "ansible-galaxy install -r requirements.yml && ansible-playbook --private-key=${var.private_key_path} main.yml -e hostname=${azurerm_virtual_machine.bastion_instance.name}-${replace(azurerm_public_ip.bastion.ip_address, ".", "-")}"

    working_dir = "${path.module}/playbook-ansible"
  }
}
