output "primary_blob_endpoint" {
  value = "${azurerm_storage_account.bastion.primary_blob_endpoint}"
}

output "container_name" {
  value = "${azurerm_storage_container.bastion.name}"
}
