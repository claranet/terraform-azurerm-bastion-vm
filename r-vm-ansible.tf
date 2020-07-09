data "template_file" "ansible_inventory" {
  template = file("${path.module}/playbook-ansible/host_ini.tpl")

  vars = {
    vm_fullname = azurerm_virtual_machine.bastion_instance.name
    vm_ip       = azurerm_public_ip.bastion.ip_address
    vm_user     = var.admin_username
  }
}

resource "local_file" "rendered_ansible_inventory" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "${path.module}/playbook-ansible/host.ini"
}

resource "null_resource" "ansible_bootstrap_vm" {
  depends_on = [azurerm_virtual_machine.bastion_instance]

  triggers = {
    uuid = azurerm_virtual_machine.bastion_instance.id
  }

  provisioner "local-exec" {
    command = "ansible-galaxy install -r requirements.yml --force && ansible-playbook --private-key=${var.private_key_path} main.yml -e ansible_cloud_provider=azure -e hostname=${azurerm_virtual_machine.bastion_instance.name}-${replace(azurerm_public_ip.bastion.ip_address, ".", "-")}"

    working_dir = "${path.module}/playbook-ansible"
  }
}
