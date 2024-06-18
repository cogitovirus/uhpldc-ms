variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "default-rg"
}

variable "location" {
  description = "Location for the resources"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  default     = "defaultstorageacct"
}

variable "prefix" {
  description = "Prefix for generating unique ID"
  type        = string
  default     = "dev"
}
