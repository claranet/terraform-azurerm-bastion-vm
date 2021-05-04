data "template_file" "ansible_inventory" {
  template = file("${path.module}/playbook-ansible/host_ini.tpl")

  vars = {
    vm_fullname = module.bastion_vm.vm_name
    vm_ip       = module.bastion_vm.vm_public_ip_address
    vm_user     = var.admin_username
  }
}

resource "local_file" "rendered_ansible_inventory" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "${path.module}/playbook-ansible/host.ini"
}

resource "local_file" "ssh_private_key" {
  content         = local.ssh_private_key
  filename        = "${path.module}/playbook-ansible/ssh_private_key.pem"
  file_permission = "0400"
}

resource "null_resource" "ansible_bootstrap_vm" {
  triggers = {
    uuid = module.bastion_vm.vm_id
  }

  provisioner "local-exec" {
    command = <<EOC
      set -e
      ansible-galaxy install -r requirements.yml --force
      ansible-playbook \
        --private-key="ssh_private_key.pem" \
        -e cloud_provider=azure \
        -e hostname="${module.bastion_vm.vm_name}-${replace(module.bastion_vm.vm_public_ip_address, ".", "-")}" \
        main.yml
    EOC

    working_dir = "${path.module}/playbook-ansible"
  }
}
