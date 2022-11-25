locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  hostname = coalesce(var.custom_vm_hostname, data.azurecaf_name.vm_host.result)
}
