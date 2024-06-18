variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "uhpldc-ms"
}

variable "location" {
  description = "Location for the resources"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  default     = "uhpldcmsstorage"
}

variable "container_name" {
  description = "Name of the storage container"
  type        = string
  default     = "tfstate"
}
