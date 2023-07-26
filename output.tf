output "storage_account" {
  value = azurerm_storage_account.storage_account
}

output "storage_container" {
  value = azurerm_storage_container.storage_container
}

/*

output "private_endpoint" {
  value = azurerm_private_endpoint.pep
}

output "private_service_connection" {
  value = azurerm_private_endpoint.pep.private_service_connection
}
*/
