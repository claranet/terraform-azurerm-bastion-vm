module "network" {
  source = "./network"
  env = "${var.env}"
  az_region = "${var.az_region}"
  resource_group_name = "${var.resource_group_name}"
  ip_bastion = "${var.ip_bastion}"
  subnet_id = "${var.subnet_id}"
}

module "storage" {
  source = "./storage"
  env = "${var.env}"
  az_region = "${var.az_region}"
  resource_group_name = "${var.resource_group_name}"
}

module "instance" {
  source = "./instance"
  env = "${var.env}"
  az_region = "${var.az_region}"
  resource_group_name = "${var.resource_group_name}"
  ssh_key_pub = "${var.ssh_key_pub}"
  network_interface_id = "${module.network.network_interface_id}"
  primary_blob_endpoint = "${module.storage.primary_blob_endpoint}"
  container_name = "${module.storage.container_name}"
  vm_size = "${var.vm_size}"
  client_name = "${var.client_name}"
  private_ip = "${var.ip_bastion}"
  public_ip = "${module.network.ip_address}"
}
