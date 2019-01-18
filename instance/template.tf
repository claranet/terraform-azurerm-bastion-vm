data "template_file" "pillar" {
  template = "${file("${path.module}/templates/pillar.tpl")}"

  vars {
    zabbix_hostname = "${var.client_name}-${var.location}-zabbix-proxy"
  }
}

data "template_file" "top-pillar" {
  template = "${file("${path.module}/templates/pillar_top.sls")}"
}

data "template_file" "top-salt" {
  template = "${file("${path.module}/templates/top.sls")}"
}
