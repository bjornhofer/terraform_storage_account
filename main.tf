data "azurerm_resource_group" "rg" {
  name = var.storage_account_resource_group_name
}

module "naming" {
  source  = "Azure/naming/azurerm"
  suffix = [ "${var.storage_account_name_suffix}" ]
  prefix = [ "${var.storage_account_name_prefix}" ]
}

resource "azurerm_storage_account" "storage_account" {
  name                      = module.naming.storage_account.name
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = length(var.storage_account_location) > 0 ? var.storage_account_location : data.azurerm_resource_group.rg.location
  account_kind              = var.storage_account_account_kind
  account_tier              = var.storage_account_account_tier
  account_replication_type  = var.storage_account_account_replication_type
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "storage_container" {
  name                  = module.naming.storage_container.name
  container_access_type = "private"
  storage_account_name  = azurerm_storage_account.storage_account.name
}


resource "azurerm_private_endpoint" "pep" {
  count               = var.private_endpoint_creation ? 1 : 0
  name                = module.naming.private_endpoint.name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = var.private_endpoint_subnet_id
  private_service_connection {
    name                           = module.naming.private_service_connection.name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }
  depends_on = [azurerm_storage_account.storage_account, azurerm_storage_container.storage_container]
}
