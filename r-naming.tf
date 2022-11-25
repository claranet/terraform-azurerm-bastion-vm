data "azurecaf_name" "vm_host" {
  name          = var.stack
  resource_type = "azurerm_linux_virtual_machine"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}
