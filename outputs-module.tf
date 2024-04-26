output "terraform_module" {
  description = "Information about this Terraform module"
  value = {
    name       = "bastion-vm"
    provider   = "azurerm"
    maintainer = "claranet"
  }
}
