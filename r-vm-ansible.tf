data "template_file" "ansible_inventory" {
  template = file("${path.module}/playbook-ansible/host_ini.tpl")

  vars = {
    vm_fullname = module.bastion-vm.vm_name
    vm_ip       = module.bastion-vm.vm_public_ip_address
    vm_user     = var.admin_username
  }
}

resource "local_file" "rendered_ansible_inventory" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "${path.module}/playbook-ansible/host.ini"
}

resource "null_resource" "ansible_bootstrap_vm" {
  triggers = {
    uuid = module.bastion-vm.vm_id
  }

  provisioner "local-exec" {
    command = "ansible-galaxy install -r requirements.yml --force && ansible-playbook --private-key=${var.private_key_path} main.yml -e ansible_cloud_provider=azure -e hostname=${module.bastion-vm.vm_name}-${replace(module.bastion-vm.vm_public_ip_address, ".", "-")}"

    working_dir = "${path.module}/playbook-ansible"
  }
}
