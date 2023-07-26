provider "azurerm" {
  features {}
  alias = "storage_account"
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  tenant_id = var.tenant_id
} 

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

locals {
  storage_account_name            = lower(length(var.storage_account_name_prefix) > 0 && length(var.storage_account_name_suffix) > 0 ? "${var.storage_account_name_prefix}${var.base_name}${var.storage_account_name_suffix}" : length(var.storage_account_name_suffix) > 0 ? "${var.base_name}${var.storage_account_name_suffix}" : length(var.storage_account_name_prefix) > 0 ? "${var.storage_account_name_prefix}${var.base_name}" : var.base_name)
  storage_container_name          = lower(length(var.storage_container_name_prefix) > 0 && length(var.storage_container_name_suffix) > 0 ? "${var.storage_container_name_prefix}-${var.base_name}-${var.storage_container_name_suffix}" : length(var.storage_container_name_suffix) > 0 ? "${var.base_name}-${var.storage_container_name_suffix}" : length(var.storage_container_name_prefix) > 0 ? "${var.storage_container_name_prefix}-${var.base_name}" : var.base_name)
  private_endpoint_name           = lower(length(var.private_endpoint_name_prefix) > 0 && length(var.private_endpoint_name_suffix) > 0 ? "${var.private_endpoint_name_prefix}-${var.base_name}-${var.private_endpoint_name_suffix}" : length(var.private_endpoint_name_suffix) > 0 ? "${var.base_name}-${var.private_endpoint_name_suffix}" : length(var.private_endpoint_name_prefix) > 0 ? "${var.private_endpoint_name_prefix}-${var.base_name}" : var.base_name)
  private_service_connection_name = lower(length(var.private_service_connection_name_prefix) > 0 && length(var.private_service_connection_name_suffix) > 0 ? "${var.private_service_connection_name_prefix}-${var.base_name}-${var.private_service_connection_name_suffix}" : length(var.private_service_connection_name_suffix) > 0 ? "${var.base_name}-${var.private_service_connection_name_suffix}" : length(var.private_service_connection_name_prefix) > 0 ? "${var.private_service_connection_name_prefix}-${var.base_name}" : var.base_name)
}

resource "azurerm_storage_account" "storage_account" {
  name                      = local.storage_account_name
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = data.azurerm_resource_group.rg.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  tags                      = var.tags
  provider                  = azurerm.storage_account
}

resource "azurerm_storage_container" "storage_container" {
  name                  = local.storage_container_name
  container_access_type = "private"
  storage_account_name  = azurerm_storage_account.storage_account.name
  provider              = azurerm.storage_account
}

/*
resource "azurerm_private_endpoint" "pep" {
  name                = local.private_endpoint_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = var.private_endpoint_subnet_id
  provider            = azurerm.storage_account

  private_service_connection {
    name                           = local.private_service_connection_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }
  depends_on = [azurerm_storage_account.storage_account, azurerm_storage_container.storage_container]
}
*/
