// Base Information
variable "base_name" {
  description = "Base name for all resources"
  type = string
}

variable "resource_group_name" {
  description = "value of the resource group name"
  type = string
}

variable "tags" {
  type    = map(string)
  description = "Tags to be applied to all resources"
  default = {}
}

// Storage Account
variable "storage_account_name_prefix" {
  description = "Prefix that will be applied before the base name for the storage account name"
  type    = string
  default = "st"
}

variable "storage_account_name_suffix" {
  description = "Suffix that will be applied after the base name for the storage account name"
  type    = string
  default = ""
}

variable "storage_container_name_prefix" {
  description = "Prefix that will be applied before the base name for the storage container name"
  type    = string
  default = ""
}

variable "storage_container_name_suffix" {
  description = "Suffix that will be applied after the base name for the storage container name"
  type    = string
  default = ""
}

// Private Endpoint
variable "private_endpoint_name_prefix" {
  description = "Prefix that will be applied before the base name for the private endpoint name"
  type    = string
  default = ""
}

variable "private_endpoint_name_suffix" {
  description = "Suffix that will be applied after the base name for the private endpoint name"
  type    = string
  default = ""
}

variable "private_service_connection_name_prefix" {
  description = "Prefix that will be applied before the base name for the private service connection name"
  type    = string
  default = ""
}

variable "private_service_connection_name_suffix" {
  description = "Suffix that will be applied after the base name for the private service connection name"
  type    = string
  default = ""
}

variable "private_endpoint_subnet_id" {
  description = "ID of the subnet to use for the private endpoint"
  type = string
  default = ""
}
