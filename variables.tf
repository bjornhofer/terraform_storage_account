// Base Information
variable "storage_account_location" {
  description = "Location of the storage account"
  type = string
  default = ""
}

variable "storage_account_resource_group_name" {
  description = "value of the resource group name"
  type = string
}

variable "storage_account_name_prefix" {
  description = "Prefix that will be applied before the base name for the storage account name"
  type    = string
  default = ""
}

variable "storage_account_name_suffix" {
  description = "Suffix that will be applied after the base name for the storage account name"
  type    = string
  default = ""
}

// Storage Account
variable "storage_account_account_tier" {
  type = string
  default = "Standard"
}

variable "storage_account_account_replication_type" {
  type = string
  default = "LRS"
}

variable "storage_account_account_kind" {
  type = string
  default = "StorageV2"
}

// Storage Container

// Private Endpoint
variable "private_endpoint_creation" {
  type = bool
  default = false
  description = "Create a private endpoint for storage account"
}

variable "private_endpoint_subnet_id" {
  description = "ID of the subnet to use for the private endpoint"
  type = string
  default = ""
}
