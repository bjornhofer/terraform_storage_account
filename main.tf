data "azurerm_resource_group" "rg" {
  name = var.storage_account_resource_group_name
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
  location                  = length(var.storage_account_location) > 0 ? var.storage_account_location : data.azurerm_resource_group.rg.location
  account_kind              = var.storage_account_account_kind
  account_tier              = var.storage_account_account_tier
  account_replication_type  = var.storage_account_account_replication_type
  enable_https_traffic_only = true
  tags                      = var.tags
}

resource "azurerm_storage_container" "storage_container" {
  name                  = local.storage_container_name
  container_access_type = "private"
  storage_account_name  = azurerm_storage_account.storage_account.name
}


resource "azurerm_private_endpoint" "pep" {
  count               = var.private_endpoint_creation ? 1 : 0
  name                = local.private_endpoint_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = var.private_endpoint_subnet_id
  private_service_connection {
    name                           = local.private_service_connection_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }
  depends_on = [azurerm_storage_account.storage_account, azurerm_storage_container.storage_container]
}
